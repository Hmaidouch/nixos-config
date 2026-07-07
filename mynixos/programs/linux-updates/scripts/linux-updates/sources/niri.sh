#!/usr/bin/env bash

set -euo pipefail

PROJECT_NAME="Niri"

fetch_latest() {
    local response
    local latest_url="https://api.github.com/repos/YaLTeR/niri/releases/latest"
    local tags_url="https://api.github.com/repos/YaLTeR/niri/tags?per_page=1"

    # --------------------------------------------------------
    # 1) Try latest GitHub release
    # --------------------------------------------------------
    response=$(curl \
        --silent \
        --show-error \
        --fail \
        --location \
        -H "Accept: application/vnd.github+json" \
        -H "X-GitHub-Api-Version: 2022-11-28" \
        "$latest_url" 2>/dev/null || true)

    if [[ -n "$response" ]] && echo "$response" | jq -e '.id?' >/dev/null 2>&1; then
        NEWS_ID=$(echo "$response" | jq -r '.id')
        NEWS_TITLE=$(echo "$response" | jq -r '.name // .tag_name // "New Niri release"')
        NEWS_URL=$(echo "$response" | jq -r '.html_url')
        NEWS_SOURCE="github_release"
        NEWS_CONTENT=$(echo "$response" | jq -r '.body // ""')
        return 0
    fi

    # --------------------------------------------------------
    # 2) Fallback to latest tag
    # --------------------------------------------------------
    response=$(curl \
        --silent \
        --show-error \
        --fail \
        --location \
        -H "Accept: application/vnd.github+json" \
        -H "X-GitHub-Api-Version: 2022-11-28" \
        "$tags_url") || {
        echo "Failed to download Niri tags" >&2
        return 1
    }

    if ! echo "$response" | jq -e 'type == "array" and length > 0' >/dev/null 2>&1; then
        echo "No Niri tags found" >&2
        return 1
    fi

    local tag_name
    local tag_sha

    tag_name=$(echo "$response" | jq -r '.[0].name')
    tag_sha=$(echo "$response" | jq -r '.[0].commit.sha')

    NEWS_ID="$tag_sha"
    NEWS_TITLE="Niri ${tag_name}"
    NEWS_URL="https://github.com/YaLTeR/niri/releases/tag/${tag_name}"
    NEWS_SOURCE="github_tag"
    NEWS_CONTENT="New Niri tag detected: ${tag_name}"

    return 0
}