#!/bin/sh

activeid=$(hyprctl activeworkspace -j | jq .id)

if [ "$1" = "+" ]; then 
  nextid=$(hyprctl workspaces -j | jq "map(.id | select(. > $activeid)) | sort | .[0]")
  if [ "$nextid" = "null" ]; then 
    hyprctl dispatch workspace "+1"
  else
    hyprctl dispatch workspace "$nextid"
  fi
elif [ "$1" = "-" ]; then
  previd=$(hyprctl workspaces -j | jq "map(.id | select(. < $activeid)) | sort | reverse | .[0]")
  if [ "$previd" = "null" ]; then 
    hyprctl dispatch workspace "-1"
  else
    hyprctl dispatch workspace "$previd"
  fi
fi
