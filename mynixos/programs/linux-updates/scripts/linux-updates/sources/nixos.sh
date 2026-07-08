#!/usr/bin/env bash

set -euo pipefail

PROJECT_NAME="NixOS"

fetch_latest() {
    local html
    local article_path
    local article_url
    local article_html

    html=$(curl \
        --silent \
        --show-error \
        --fail \
        "https://nixos.org/blog/announcements/") || {
        echo "Failed to download NixOS announcements page" >&2
        return 1
    }

    article_path=$(
        printf "%s" "$html" |
        grep -oE '/blog/announcements/[0-9]{4}/[^"/]+/' |
        awk '!seen[$0]++' |
        tail -n1 || true
    )

    if [[ -z "$article_path" ]]; then
        article_path=$(
            printf "%s" "$html" |
            grep -oE '/blog/announcements/[^"]+/' |
            grep -v '/blog/announcements/$' |
            awk '!seen[$0]++' |
            tail -n1 || true
        )
    fi

    [[ -n "$article_path" ]] || {
        echo "Failed to find latest NixOS article link" >&2
        return 1
    }

    article_url="https://nixos.org${article_path}"

    article_html=$(curl \
        --silent \
        --show-error \
        --fail \
        "$article_url") || {
        echo "Failed to download NixOS article page" >&2
        return 1
    }

    NEWS_URL="$article_url"
    NEWS_ID="$article_url"
    NEWS_SOURCE="announcements"

    NEWS_TITLE=$(printf "%s" "$article_html" |
        sed -n 's:.*<title>\(.*\) | Blog | Nix & NixOS</title>.*:\1:p' |
        head -n1)

    [[ -n "${NEWS_TITLE:-}" ]] || NEWS_TITLE="NixOS announcement"

    NEWS_CONTENT=$(printf "%s" "$article_html" |
        sed -n '/<main/,/<\/main>/p' |
        sed 's/<script[^>]*>.*<\/script>//g' |
        sed 's/<style[^>]*>.*<\/style>//g' |
        sed 's/<[^>]*>/ /g' |
        sed 's/&quot;/"/g; s/&amp;/\&/g; s/&nbsp;/ /g' |
        tr -s ' ' |
        fold -s -w 1000 |
        head -n 20)

    [[ -n "${NEWS_TITLE:-}" && -n "${NEWS_URL:-}" && -n "${NEWS_ID:-}" ]]
}