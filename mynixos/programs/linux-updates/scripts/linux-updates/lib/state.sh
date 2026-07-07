#!/usr/bin/env bash

set -euo pipefail

CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/linux-updates"
STATE_DIR="$CACHE_DIR/state"

# ============================================================
# Init state directory
# ============================================================

state_init() {
    mkdir -p "$CACHE_DIR"

    # إذا كان state ملفاً من نسخة قديمة، احذفه
    if [[ -f "$STATE_DIR" ]]; then
        rm -f "$STATE_DIR"
    fi

    mkdir -p "$STATE_DIR"
}

state_init

# ============================================================
# State file path
# ============================================================

state_file() {
    local project="$1"
    echo "$STATE_DIR/${project}.last"
}

# ============================================================
# Check if news already seen
# ============================================================

state_is_seen() {
    local project="$1"
    local news_id="$2"
    local file

    file=$(state_file "$project")

    [[ -f "$file" ]] && [[ "$(cat "$file")" == "$news_id" ]]
}

# ============================================================
# Mark news as seen
# ============================================================

state_mark_seen() {
    local project="$1"
    local news_id="$2"
    local file

    file=$(state_file "$project")

    printf "%s\n" "$news_id" > "$file"
}