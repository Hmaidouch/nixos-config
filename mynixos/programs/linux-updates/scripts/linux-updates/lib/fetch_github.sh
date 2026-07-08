#!/usr/bin/env bash

set -euo pipefail

# ============================================================
# GitHub helpers
# ============================================================

github_api_get() {
    local endpoint="$1"

    fetch_url "https://api.github.com${endpoint}"
}

github_latest_release_json() {
    local owner="$1"
    local repo="$2"

    github_api_get "/repos/${owner}/${repo}/releases/latest"
}

github_tags_json() {
    local owner="$1"
    local repo="$2"

    github_api_get "/repos/${owner}/${repo}/tags?per_page=1"
}

# ============================================================
# Generic source: release or fallback tag
# ============================================================

fetch_github_release_or_tag() {
    local owner="$1"
    local repo="$2"
    local pretty_name="$3"

    local release_json=""
    local tags_json=""
    local tag_name=""
    local html_url=""
    local body=""

    PROJECT_NAME="$pretty_name"

    # --------------------------------------------------------
    # Try latest release first
    # --------------------------------------------------------

    if release_json="$(github_latest_release_json "$owner" "$repo" 2>/dev/null)"; then
        tag_name="$(printf '%s' "$release_json" | jq -r '.tag_name // empty')"
        html_url="$(printf '%s' "$release_json" | jq -r '.html_url // empty')"
        body="$(printf '%s' "$release_json" | jq -r '.body // empty')"

        if [[ -n "$tag_name" && -n "$html_url" ]]; then
            NEWS_ID="release:${owner}/${repo}:${tag_name}"
            NEWS_TITLE="$tag_name"
            NEWS_URL="$html_url"
            NEWS_CONTENT="$body"
            NEWS_SOURCE="github_release"
            return 0
        fi
    fi

    # --------------------------------------------------------
    # Fallback to latest tag
    # --------------------------------------------------------

    if tags_json="$(github_tags_json "$owner" "$repo" 2>/dev/null)"; then
        tag_name="$(printf '%s' "$tags_json" | jq -r '.[0].name // empty')"

        if [[ -n "$tag_name" ]]; then
            NEWS_ID="tag:${owner}/${repo}:${tag_name}"
            NEWS_TITLE="$tag_name"
            NEWS_URL="https://github.com/${owner}/${repo}/tree/${tag_name}"
            NEWS_CONTENT="Latest Git tag for ${pretty_name}: ${tag_name}"
            NEWS_SOURCE="github_tag"
            return 0
        fi
    fi

    log_warn "[${pretty_name}] no GitHub release or tag found"
    return 1
}