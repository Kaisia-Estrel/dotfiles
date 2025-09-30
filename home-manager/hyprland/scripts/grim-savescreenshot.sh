#!/bin/sh

FILE="$XDG_PICTURES_DIR/$(date +"screenshot-%m-%d-%Y.png")"

if [ -f "$FILE" ]; then 
  FILE_EXT="${FILE##*.}"
  FILE_NAME="${FILE%.*}"
  i=1
  while [ -f "$FILE_NAME--$i.$FILE_EXT" ]; do 
    i=$((i + 1))
  done
  grim "$FILE_NAME--$i.$FILE_EXT" 
  notify-send "Screenshot taken" "Screenshot saved to $FILE_NAME--$i.$FILE_EXT" -i "$FILE_NAME--$i.$FILE_EXT"
else
  grim "$FILE"
  notify-send "Screenshot taken" "Screenshot saved to $FILE" -i "$FILE"
fi
