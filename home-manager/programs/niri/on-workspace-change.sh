#!/usr/bin/env bash

while read -r line; do
  workspaceChanged=$(jq '.WorkspaceActivated | . != null' <<< "$line")
  if [ "$workspaceChanged" = "true" ]; then
    awww img "backgrounds/bg-$(shuf -i 1-5 -n 1).png"
  fi
done < <(niri msg --json event-stream)
