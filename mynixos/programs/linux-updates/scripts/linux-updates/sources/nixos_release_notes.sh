#!/usr/bin/env bash

set -euo pipefail

PROJECT_NAME="NixOS Release Notes"

fetch_latest() {
    local page_url="https://nixos.org/manual/nixos/stable/release-notes"
    local html=""
    local title=""
    local content=""

    html="$(fetch_url "$page_url")" || {
        log_warn "[nixos_release_notes] failed to download NixOS release notes page"
        return 1
    }

    # الخبر نفسه هو صفحة الـ release notes الحالية
    NEWS_URL="$page_url"
    NEWS_ID="$page_url"
    NEWS_SOURCE="release_notes"

    title="$(
        printf '%s' "$html" |
        sed -n 's:.*<title>\(.*\)</title>.*:\1:p' |
        head -n1
    )"

    [[ -n "${title:-}" ]] || title="NixOS Release Notes"

    content="$(
        printf '%s' "$html" |
        sed 's/<[^>]*>/ /g' |
        tr -s '[:space:]' ' ' |
        cut -c1-25000
    )"

    NEWS_TITLE="$title"
    NEWS_CONTENT="$content"

    return 0
}