#!/usr/bin/env bash

lastWorkspace=0
currentWorkspace=0

handle() {
  if [[ ${1:0:11} == "workspace>>" ]]; then
    lastWorkspace="$currentWorkspace"
    echo "$lastWorkspace" > "$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.last-workspace"
    currentWorkspace="${1:11}"
  fi
}

socat - "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" \
    | while read -r line; do 
    handle "$line"
  done
