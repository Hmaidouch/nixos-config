#!/usr/bin/env bash

# ============================================================
# GitHub API Library
# ============================================================

GITHUB_API="https://api.github.com"

# ------------------------------------------------------------
# Common headers
# ------------------------------------------------------------

github_headers() {

    printf '%s\n' \
        "-H" "Accept: application/vnd.github+json" \
        "-H" "X-GitHub-Api-Version: 2022-11-28"

    if [[ -n "${GITHUB_TOKEN:-}" ]]; then
        printf '%s\n' \
            "-H" "Authorization: Bearer ${GITHUB_TOKEN}"
    fi
}

# ------------------------------------------------------------
# Generic GET
# ------------------------------------------------------------

github_get() {

    local endpoint="$1"

    local args=()

    while read -r line
    do
        args+=("$line")
    done < <(github_headers)

    curl \
        --silent \
        --location \
        --fail \
        "${args[@]}" \
        "${GITHUB_API}${endpoint}"
}

# ------------------------------------------------------------
# Repository API
# ------------------------------------------------------------

github_repo() {

    github_get "/repos/${GITHUB_OWNER}/${GITHUB_REPO}"
}

# ------------------------------------------------------------
# Releases
# ------------------------------------------------------------

github_releases() {

    github_get "/repos/${GITHUB_OWNER}/${GITHUB_REPO}/releases?per_page=20"
}

# ------------------------------------------------------------
# Issues
# ------------------------------------------------------------

github_issues() {

    github_get "/repos/${GITHUB_OWNER}/${GITHUB_REPO}/issues?state=open&per_page=20"
}

# ------------------------------------------------------------
# Commits
# ------------------------------------------------------------

github_commits() {

    github_get "/repos/${GITHUB_OWNER}/${GITHUB_REPO}/commits?per_page=20"

}

# ------------------------------------------------------------
# Pull Requests
# ------------------------------------------------------------

github_pulls() {

    github_get "/repos/${GITHUB_OWNER}/${GITHUB_REPO}/pulls?state=open&per_page=20"
}

# ------------------------------------------------------------
# Tags
# ------------------------------------------------------------

github_tags() {

    github_get "/repos/${GITHUB_OWNER}/${GITHUB_REPO}/tags?per_page=20"
}

# ------------------------------------------------------------
# Branches
# ------------------------------------------------------------

github_branches() {

    github_get "/repos/${GITHUB_OWNER}/${GITHUB_REPO}/branches"
}

# ------------------------------------------------------------
# Latest Release
# ------------------------------------------------------------

github_latest_release() {

    github_get "/repos/${GITHUB_OWNER}/${GITHUB_REPO}/releases/latest"
}

# ------------------------------------------------------------
# Rate limit
# ------------------------------------------------------------

github_rate_limit() {

    github_get "/rate_limit"
}