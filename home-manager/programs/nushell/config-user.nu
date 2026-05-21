$env.config.keybindings ++= [{
    name: vim_delete_line
    modifier: control
    keycode: Char_u
    mode: vi_insert
    event: [{ edit: Clear }]
}]

export def --wrapped run [
  derivation: string
  --cmd: string
  ...arguments
] {
  mut deriv = ""
  try {
    let url = $derivation | url parse
    if $url.scheme in ["http" "https" "ftp"] {
      $deriv = $"($url.host | str replace ".com" ""):($url.path | str trim -l -c '/')"
    } else {
      $deriv = $"($url.scheme):($url.path)"
    }
  } catch { |err|
    if $err.msg == "Input type not supported." {
      panic $err.rendered
    }
  } 

  if ($deriv | is-empty) {
    $deriv = if '#' not-in $deriv { 
      $"nixpkgs#($derivation)" 
    } else {
      $derivation
    }
  }

  if ($cmd | is-empty) {
    nix run --inputs-from /etc/nixos $deriv -- ...$arguments
  } else {
    nix shell --inputs-from /etc/nixos $deriv --command $cmd ...$arguments
  }
}

# Derefence a symlink into a full copy
export def makereal [path?: string ]: oneof<string, nothing> -> nothing {
  let path = if ($path | is-empty) {
    $in 
  } else {
    $path
  }
  if ($path | path type) != symlink {
    return
  }
  let tmp = mktemp
  cat $path | save --force $tmp
  rm $path 
  mv $tmp $path
}

# Edits a file of the same name in the nixos config
# It dereferences the provided path if it happens to be a symlink
export def edit-conf-symlink [ 
  file: string 
]: nothing -> nothing {

  let files = git -C "/etc/nixos" ls-files | complete | if $in.exit_code == 0 { 
    get stdout | lines | where { |e| ($e | path basename) == ($file | path basename) }
  } else { 
    glob $"/etc/nixos/**/(file)"
  }

  if ($files | is-not-empty) {
    let config_files = $files | each {|x| $"/etc/nixos/($x)" }
    print $config_files
    let index = (input "Select file to update: " | into int)
    let config_file = $config_files | get $index
    $file | makereal
    run-external $env.EDITOR $file
    cp $file $config_file

    if ($"($file).bk" | path exists) {
      match (input -n 1 $"Found a backup file at ($file).bk, remove? \(y/n): ") {
        'y' => { rm $"($file).bk" }
        _ => {}
      }
    }

    print $"wrote changes to ($config_file)"
  } else {
    print "No such file found in the nixos config"
  }
}

export def --wrapped lsgit [
  --all (-a)
  ...rest
]: nothing -> table  {
  if (git rev-parse --git-dir | complete | get exit_code) != 0 {
    return []
  }

  if "--help" in $rest or "-h" in $rest { 
    git ls-files -h
  } else if $all { 
    let args = $rest | where { $in != --all and $in != -a }
    git ls-files ...$args | lines | ls ...$in 
  } else { 
    ls | where name in (git ls-files ...$rest | lines | each {path split | get 0} | uniq)
  }
}

# copies provided file/s into the clipboard with a proper mimetype
export def cpfile [ file?: string ]: oneof<nothing, string, list<string>> -> nothing {
  if ($file | is-empty) {
    match ($in | describe) {
      nothing => {},
      string => { 
        wl-copy -t 'text/uri-list' $"file://($in | path expand)" 
      },
      list<string> => { 
        each {|e| $"file://($e | path expand)"} 
        | str join "\n" 
        | wl-copy -t "text/uri-list"
      }
    }
  } else {
    wl-copy -t 'text/uri-list' $"file://($file | path expand)"
  }
}
