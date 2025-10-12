#!/usr/bin/env bash

# I Couldnt be bothered to individually package these, so I just store the releases
# in the repo

getPlugin() {
    local owner="$1"
    local repo="$2"
    local version="$3"
    mkdir -p "./plugins/$repo"
    gh release download --clobber "$version" -D "./plugins/$repo" -R "$owner/$repo" 
}

getPlugin "aleksey-rowan" "obsidian-vim-yank-highlight" "1.0.8"
getPlugin "karstenpedersen" "obsidian-vimium" "1.0.0"
getPlugin "liamcain" "obsidian-calendar-plugin" "2.0.0-beta.2"
