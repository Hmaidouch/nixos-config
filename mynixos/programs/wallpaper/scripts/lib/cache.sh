#!/usr/bin/env bash

set -euo pipefail

# ============================================================
# Cache Library
# ============================================================

CACHE_DIR="$HOME/.cache/wallpaper"

CURRENT_FILE="$CACHE_DIR/current"
HISTORY_FILE="$CACHE_DIR/history"
FAVORITES_FILE="$CACHE_DIR/favorites"

mkdir -p "$CACHE_DIR"

# ------------------------------------------------------------
# Current wallpaper
# ------------------------------------------------------------

cache_set_current() {

    printf "%s\n" "$1" > "$CURRENT_FILE"
}

cache_get_current() {

    [[ -f "$CURRENT_FILE" ]] || return 1

    cat "$CURRENT_FILE"
}

# ------------------------------------------------------------
# History
# ------------------------------------------------------------

cache_add_history() {

    printf "%s\n" "$1" >> "$HISTORY_FILE"

    tac "$HISTORY_FILE" \
        | awk '!seen[$0]++' \
        | head -30 \
        | tac \
        > "$HISTORY_FILE.tmp"

    mv "$HISTORY_FILE.tmp" "$HISTORY_FILE"
}