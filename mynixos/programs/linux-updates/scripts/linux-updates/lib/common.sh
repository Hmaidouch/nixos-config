#!/usr/bin/env bash

set -euo pipefail

# ============================================================
# Common helpers
# ============================================================

require_cmd() {
    local cmd="$1"

    command -v "$cmd" >/dev/null 2>&1 || {
        echo "Required command not found: $cmd" >&2
        exit 1
    }
}

trim() {
    local s="$1"

    # حذف الفراغات من البداية والنهاية
    s="${s#"${s%%[![:space:]]*}"}"
    s="${s%"${s##*[![:space:]]}"}"

    printf '%s\n' "$s"
}

escape_markdown_v2() {
    local text="$1"

    text="${text//\\/\\\\}"
    text="${text//_/\\_}"
    text="${text//*/\\*}"
    text="${text//[/\\[}"
    text="${text//]/\\]}"
    text="${text//(/\\(}"
    text="${text//)/\\)}"
    text="${text//~/\\~}"
    text="${text//\`/\\\`}"
    text="${text//>/\\>}"
    text="${text//#/\\#}"
    text="${text//+/\\+}"
    text="${text//-/\\-}"
    text="${text//= /\\= }"
    text="${text//= /\\= }"
    text="${text//=/\\=}"
    text="${text//|/\\|}"
    text="${text//\{/\\{}"
    text="${text//\}/\\}}"
    text="${text//./\\.}"
    text="${text//!/\\!}"

    printf '%s\n' "$text"
}