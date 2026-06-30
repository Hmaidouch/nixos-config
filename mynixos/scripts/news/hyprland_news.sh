#!/usr/bin/env bash

# ============================================================
# Project configuration
# ============================================================

PROJECT_NAME="Hyprland"
PROJECT_ICON=""

# Reddit
SUBREDDIT="Hyprland"

# GitHub
GITHUB_OWNER="hyprwm"
GITHUB_REPO="Hyprland"

# Gemini
MODEL="gemini-2.5-flash"

# Cache
CACHE_ID="hyprland"

# ============================================================
# Run main script
# ============================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/news.sh"