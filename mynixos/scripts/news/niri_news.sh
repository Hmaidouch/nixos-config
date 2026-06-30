#!/usr/bin/env bash

PROJECT_NAME="Niri"
PROJECT_ICON="󱗃"

SUBREDDIT="niri"

GITHUB_OWNER="YaLTeR"
GITHUB_REPO="niri"

MODEL="gemini-2.5-flash"

CACHE_ID="niri"

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