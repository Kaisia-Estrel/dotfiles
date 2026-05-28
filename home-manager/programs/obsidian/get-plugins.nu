#!/usr/bin/env nu

def trace [msg: any]: any -> any {
  print $msg
  $in
}

def traceIDFmt [format: string]: any -> any {
  printf $format $in
  $in
}

def main [] {
  let community_plugins = http get 'https://raw.githubusercontent.com/obsidianmd/obsidian-releases/master/community-plugins.json' 
  let user_plugins = open ./plugins.txt 
    | lines 
    | where { not ($in | str starts-with "github:") }

  let user_plugins_github = open ./plugins.txt 
    | lines 
    | where { str starts-with "github:" } 
    | parse "github:{author}/{id}"
    | insert repo {|x| $"($x.author)/($x.id)" }

  let plugin_infos = $community_plugins 
    | where { $in.id in $user_plugins } 
    | append $user_plugins_github

  if ($user_plugins | any { $in not-in $plugin_infos.id } ) {
    let missing = $user_plugins 
      | where { $in not-in $plugin_infos.id } 
      | each { $"\"($in)\"" } | str join ', '
    error make -u {
      msg: $"Could not find these plugins in 'plugins.txt': ($missing)"
    }
  }
# graphql queries doesnt accept `-` but obsidian ids are in kebab-case
# so you have to turn them to and from camelCase
  let toCamel = $plugin_infos 
    | reduce --fold {} { |x,acc| $acc | merge { $x.id: ($x.id | str camel-case) } } 
  let fromCamel = $plugin_infos 
    | reduce --fold {} { |x,acc| $acc | merge { ($x.id | str camel-case) : $x.id } } 

  let queries = $plugin_infos | each { |plugin_info|
    let owner = ($plugin_info.repo | split row '/').0
    let repo = ($plugin_info.repo | split row '/').1
    $"($toCamel | get $plugin_info.id): repository\(owner:\"($owner)\", name:\"($repo)\"\) {
      releases\(first: 1, orderBy: {field: CREATED_AT, direction: DESC}\) {
        nodes {
          tagName
          releaseAssets\(first: 10\) {
            nodes {
              name
              downloadUrl
            }
          }
        }
      }
    }
    "
  }
  let query = $"query {($queries | str join "")}"

  print -e "Making the graphql API call"
  mut progress = 0
  let release_files = gh api graphql -f query=($query) 
    | trace "prefetching urls"
    | from json
    | get data
    | items { |k,v| 
        let plugin_id = $fromCamel | get $k
        print $"Prefetching assets for ($plugin_id)"
        {
          $plugin_id : {
            version: $v.releases.nodes.0.tagName
            assets: (
              $v.releases.nodes.0.releaseAssets.nodes 
                | reduce -f {} { |x|
                    print $"\tPrefetching asset ($x.name)"
                    $in | merge { $x.name : {
                        url: $x.downloadUrl 
                        sha256: $"sha256:(nix-prefetch-url $x.downloadUrl e> /dev/null)"
                      }
                    }
                  }
              )
          }
        } 
      }
    | reduce {|x| merge $x }
    | to json
    | save -f 'plugin-urls.json'
  print $"(ansi green)Saved URLs to 'plugin-urls.json'"
}

def "main add-plugin" [...plugin_ids: string] {
  let community_plugins = http get 'https://raw.githubusercontent.com/obsidianmd/obsidian-releases/master/community-plugins.json' 
  let plugins = if ($plugin_ids | is-empty) {
    let lengths = $community_plugins | reduce -f [0 0 0 0] {|x, acc| [
        ([ ($x.id | str length -b) $acc.0 ] | math max)
        ([ ($x.name | str length -b) $acc.1 ] | math max)
        ([ ($x.author | str length -b) $acc.2 ] | math max)
        ([ ($x.repo | str length -b) $acc.3 ] | math max)
      ]}
    $community_plugins 
      | reduce -f "" {|x,acc| 
          $acc + $"\n($x.id | fill -w $lengths.0)┃($x.name | fill -w $lengths.1)┃($x.author | fill -w $lengths.2)┃($x.repo | fill -w $lengths.3)" 
        }
      | fzf --no-hscroll -m 
      | lines 
      | each { split row ' ' | first }
  } else {
    $community_plugins 
      | where { $in.id in $plugin_ids }
      | get id
  }
  if ($plugins.0 | is-empty) {
    print $"(ansi red)No plugins specified, no plugins added"
    return
  }
  open ./plugins.txt
    | lines
    | append $plugins
    | uniq
    | str join "\n"
    | collect
    | save -f ./plugins.txt
  print $"(ansi green)Successfully added plugins, run './get-plugins.nu' to save to 'plugin-urls.json'"
}

