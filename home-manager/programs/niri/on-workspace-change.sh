#!/usr/bin/env bash

while read -r line; do
  workspaceChanged=$(jq '.WorkspaceActivated | . != null' <<< "$line")
  if [ "$workspaceChanged" = "true" ]; then
    awww img "$XDG_CONFIG_HOME/niri/backgrounds/bg-$(( RANDOM % 5 + 1 )).png"
  fi
done < <(niri msg --json event-stream)
