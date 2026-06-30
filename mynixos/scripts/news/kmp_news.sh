#!/usr/bin/env bash

PROJECT_NAME="Kotlin Multiplatform"
PROJECT_ICON=""

SUBREDDIT="Kotlin"

GITHUB_OWNER="JetBrains"
GITHUB_REPO="kotlin"

MODEL="gemini-2.5-flash"

CACHE_ID="kmp"

NEWS_SOURCES=(
    reddit
    releases
    commits
    issues
)

# ============================================================
# Run main script
# ============================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/news.sh"