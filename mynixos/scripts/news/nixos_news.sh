#!/usr/bin/env bash

PROJECT_NAME="NixOS"
PROJECT_ICON=""

SUBREDDIT="NixOS"

GITHUB_OWNER="NixOS"
GITHUB_REPO="nixpkgs"

MODEL="gemini-2.5-flash"

CACHE_ID="nixos"

NEWS_SOURCES=(
    reddit
    tags
    commits
    issues
)

# ============================================================
# Run main script
# ============================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/news.sh"