#!/bin/sh
workspace=$1

focused=$(niri msg --json workspaces | jq -r '.[] | select(.is_focused).name')


if [ "$focused" = "$workspace" ]; then
  niri msg action focus-workspace-previous
else
  niri msg action focus-workspace "$workspace"
fi
