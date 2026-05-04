#!/usr/bin/env bash

plugins=(
"calendar"
"darlal-switcher-plus"
"folder-notes"
"obsidian-git"
"obsidian-latex-suite"
"vim-yank-highlight"
"vimium"
"vim-yank-highlight"
  )

in_array() {
  local needle=$1
  shift

  local item
  for item in "$@"; do
    [[ $item == "$needle" ]] && return 0
  done

  return 1
}

shopt -s nullglob
declare -A installed_versions
for i in ./plugins/*/manifest.json; do
  IFS='=' read -r k v < <(jq -r '"\(.id)=\(.version)"' "$i")
  if ! in_array "$k" "${plugins[@]}"; then
    echo "deleting '$k'"
    rm -rf "./plugins/$k"
    continue
  else 
    true
  fi
  installed_versions["$k"]="${v#v}"
done

for p in "${plugins[@]}"; do
  if [[ ! -v "installed_versions[$p]" ]]; then 
    installed_versions["$p"]="0"
  fi
done


declare -A repos
while IFS=';' read -r plugin repo; do
  repos["$plugin"]="$repo"
done < <(
curl -s "https://raw.githubusercontent.com/obsidianmd/obsidian-releases/master/community-plugins.json" \
  | jq -r --args '.[] | select(.id | IN($ARGS.positional[])) | "\(.id);\(.repo)"' "${!installed_versions[@]}"
  )

declare -A newer_versions
while IFS=';' read -r plugin version; do
  current_version=${installed_versions["$plugin"]}
  #remove the `v` prefix plugin versions sometimes have
  version="${version#v}"
  if [[ "$current_version" != "$version" ]]; then
    echo -e "\x1b[31mOutdated: $plugin"
    echo -e "\tCurrent version: $current_version"
    echo -e "\tLatest version: \x1b[32m$version\x1b[0m"
    newer_versions["$plugin"]="$version"
  fi
done < <(
curl -s "https://raw.githubusercontent.com/obsidianmd/obsidian-releases/master/community-plugin-stats.json" \
  | jq -r --args '
      def opt(f):
          . as $in | try f catch $in;
      def semver_cmp:
          sub("\\+.*$"; "")
        | capture("^(?<v>[^-]+)(?:-(?<p>.*))?$") | [.v, .p // empty]
        | map(split(".") | map(opt(tonumber)))
        | .[1] |= (. // {});

      . as $stats 
      | $ARGS.positional[] 
      | . as $plugin 
      | $stats.[.]
      | del(.downloads, .updated)
      | keys
      | map(select(contains("beta") | not))
      | max_by(semver_cmp)
      | "\($plugin);\(.)"
      ' "${!installed_versions[@]}"
  )

for k in "${!newer_versions[@]}"; do
  plugin="$k"
  version="${newer_versions["$k"]}"
  repo="${repos["$k"]}"
  rm -rf "./plugins/$plugin"
  mkdir -p "./plugins/$plugin"
  gh release download --clobber "$version" -D "./plugins/$plugin" -R "$repo"
done

if [[ "${#newer_versions[@]}" -eq 0 ]]; then
  echo -e "\x1b[32mAll plugins are up to date\x1b[0m"
else
  echo -e "\x1b[32mUpdated ${#newer_versions[@]} plugins\x1b[0m"
fi
