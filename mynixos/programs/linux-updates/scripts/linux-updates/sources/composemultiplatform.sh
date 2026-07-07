#!/usr/bin/env bash

set -euo pipefail

PROJECT_NAME="Compose Multiplatform"

fetch_latest() {
    local response
    local latest_url="https://api.github.com/repos/JetBrains/compose-multiplatform/releases/latest"
    local tags_url="https://api.github.com/repos/JetBrains/compose-multiplatform/tags?per_page=1"

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
        NEWS_TITLE=$(echo "$response" | jq -r '.name // .tag_name // "New Compose Multiplatform release"')
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
        echo "Failed to download Compose Multiplatform tags" >&2
        return 1
    }

    if ! echo "$response" | jq -e 'type == "array" and length > 0' >/dev/null 2>&1; then
        echo "No Compose Multiplatform tags found" >&2
        return 1
    fi

    local tag_name
    local tag_sha

    tag_name=$(echo "$response" | jq -r '.[0].name')
    tag_sha=$(echo "$response" | jq -r '.[0].commit.sha')

    NEWS_ID="$tag_sha"
    NEWS_TITLE="Compose Multiplatform ${tag_name}"
    NEWS_URL="https://github.com/JetBrains/compose-multiplatform/releases/tag/${tag_name}"
    NEWS_SOURCE="github_tag"
    NEWS_CONTENT="New Compose Multiplatform tag detected: ${tag_name}"

    return 0
}