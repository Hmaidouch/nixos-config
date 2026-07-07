#!/usr/bin/env bash

set -euo pipefail

# ============================================================
# Directories
# ============================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="$SCRIPT_DIR/lib"
SOURCES_DIR="$SCRIPT_DIR/sources"

# ============================================================
# Load libraries
# ============================================================

source "$LIB_DIR/state.sh"
source "$LIB_DIR/telegram.sh"
source "$LIB_DIR/gemini_news.sh"

# ============================================================
# Load env
# ============================================================

ENV_FILE="$HOME/nixos-config/.env"

if [[ -f "$ENV_FILE" ]]; then
    # shellcheck disable=SC1090
    source "$ENV_FILE"
fi

# ============================================================
# Projects
# ============================================================

PROJECTS=(
    nixos
    niri
    hyprland
    kotlinmultiplatform
    composemultiplatform
)

# ============================================================
# Process one project
# ============================================================

process_project() {
    local project="$1"
    local source_file="$SOURCES_DIR/${project}.sh"

    [[ -f "$source_file" ]] || {
        echo "Missing source file: $source_file" >&2
        return 1
    }

    # إعادة تهيئة المتغيرات الخاصة بالخبر
    NEWS_ID=""
    NEWS_TITLE=""
    NEWS_URL=""
    NEWS_CONTENT=""
    NEWS_SOURCE=""

    # shellcheck disable=SC1090
    source "$source_file"

    fetch_latest || return 1

    [[ -n "${NEWS_ID:-}" ]] || return 1
    [[ -n "${NEWS_TITLE:-}" ]] || return 1
    [[ -n "${NEWS_URL:-}" ]] || return 1

    if state_is_seen "$project" "$NEWS_ID"; then
        return 0
    fi

    summarize_linux_news \
        "$PROJECT_NAME" \
        "${NEWS_SOURCE:-unknown}" \
        "$NEWS_TITLE" \
        "$NEWS_URL" \
        "${NEWS_CONTENT:-}"

    telegram_send_message "$SUMMARY"
    state_mark_seen "$project" "$NEWS_ID"

    echo "[$project] Notified: $NEWS_TITLE"
}

# ============================================================
# Main
# ============================================================

main() {
    for project in "${PROJECTS[@]}"; do
        process_project "$project"
    done
}

main "$@"