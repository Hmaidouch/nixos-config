#!/usr/bin/env bash

set -euo pipefail

CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/linux-updates"
STATE_DIR="$CACHE_DIR/state"

mkdir -p "$STATE_DIR"

state_file() {
    local project="$1"
    echo "$STATE_DIR/${project}.last"
}

state_is_seen() {
    local project="$1"
    local news_id="$2"
    local file

    file=$(state_file "$project")

    [[ -f "$file" ]] && [[ "$(cat "$file")" == "$news_id" ]]
}

state_mark_seen() {
    local project="$1"
    local news_id="$2"
    local file

    file=$(state_file "$project")

    printf "%s\n" "$news_id" > "$file"
}