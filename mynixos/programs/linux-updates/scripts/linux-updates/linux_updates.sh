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
source "$LIB_DIR/helpers.sh"
source "$LIB_DIR/fetch_github.sh"
source "$LIB_DIR/fetch_rss.sh"

# ============================================================
# Lock
# ============================================================

LOCK_DIR="${XDG_RUNTIME_DIR:-/tmp}"
LOCK_FILE="$LOCK_DIR/linux-updates.lock"

exec 9>"$LOCK_FILE"

if ! flock -n 9; then
    log_info "linux-updates: another instance is already running, exiting"
    exit 0
fi

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
    nixos_release_notes
    niri
    hyprland
    kotlin
    composemultiplatform
    jetbrains_kmp
)

# ============================================================
# Process one project
# ============================================================

process_project() {
    local project="$1"
    local source_file="$SOURCES_DIR/${project}.sh"

    if [[ ! -f "$source_file" ]]; then
        log_warn "[$project] missing source file: $source_file"
        return 0
    fi

    log_info "[$project] checking..."

    # إعادة تهيئة متغيرات الخبر
    NEWS_ID=""
    NEWS_TITLE=""
    NEWS_URL=""
    NEWS_CONTENT=""
    NEWS_SOURCE=""
    PROJECT_NAME=""

    # shellcheck disable=SC1090
    source "$source_file"

    if ! fetch_latest; then
        log_warn "[$project] fetch_latest failed, skipping"
        return 0
    fi

    if [[ -z "${NEWS_ID:-}" || -z "${NEWS_TITLE:-}" || -z "${NEWS_URL:-}" ]]; then
        log_warn "[$project] incomplete news payload, skipping"
        return 0
    fi

    if state_is_seen "$project" "$NEWS_ID"; then
        log_info "[$project] already seen"
        return 0
    fi

    summarize_linux_news \
        "${PROJECT_NAME:-$project}" \
        "${NEWS_SOURCE:-unknown}" \
        "$NEWS_TITLE" \
        "$NEWS_URL" \
        "${NEWS_CONTENT:-}"

    if telegram_send_message "$SUMMARY"; then
        state_mark_seen "$project" "$NEWS_ID"
        log_info "[$project] notified: $NEWS_TITLE"
    else
        log_warn "[$project] telegram send failed"
    fi

    return 0
}

# ============================================================
# Main
# ============================================================

main() {
    local project

    for project in "${PROJECTS[@]}"; do
        process_project "$project"
    done
}

main "$@"