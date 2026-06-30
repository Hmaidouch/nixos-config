#!/usr/bin/env bash

set -euo pipefail

# ============================================================
# Directories
# ============================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="$SCRIPT_DIR/lib"

CACHE_BASE="$HOME/.cache/waybar/news/$CACHE_ID"
mkdir -p "$CACHE_BASE"

# ============================================================
# Load libraries
# ============================================================

source "$LIB_DIR/cache.sh"
source "$LIB_DIR/ui.sh"
source "$LIB_DIR/reddit.sh"

source "$LIB_DIR/github_api.sh"
source "$LIB_DIR/github_releases.sh"
source "$LIB_DIR/github_tags.sh"
source "$LIB_DIR/github_commits.sh"
source "$LIB_DIR/github_issues.sh"

source "$LIB_DIR/gemini.sh"

# ============================================================
# Load Gemini API Key
# ============================================================

ENV_FILE="$HOME/nixos-config/.env"

if [[ -f "$ENV_FILE" ]]; then
    source "$ENV_FILE"
    API_KEY="$GEMINI_API_KEY"
else
    API_KEY=$(cat "$HOME/.config/gemini_api.txt" 2>/dev/null || true)
fi

if [[ -z "${API_KEY:-}" ]]; then
    notify-send "Gemini" "API Key not found"
    exit 1
fi

# ============================================================
# Source Labels
# ============================================================

declare -A SOURCE_LABELS

SOURCE_LABELS[reddit]="📰 Reddit"
SOURCE_LABELS[releases]="🚀 GitHub Releases"
SOURCE_LABELS[tags]="🏷 GitHub Tags"
SOURCE_LABELS[commits]="📝 GitHub Commits"
SOURCE_LABELS[issues]="🐞 GitHub Issues"

# ============================================================
# Build Menu
# ============================================================

MENU_ITEMS=()

for source in "${NEWS_SOURCES[@]}"
do
    MENU_ITEMS+=("${SOURCE_LABELS[$source]}")
done

SOURCE=$(
    printf "%s\n" "${MENU_ITEMS[@]}" |
    rofi \
        -dmenu \
        -i \
        -p "$PROJECT_ICON $PROJECT_NAME" \
        -config "$HOME/.config/rofi/themes/general_news.rasi"
)

[[ -z "$SOURCE" ]] && exit 0

# ============================================================
# Fetch Data
# ============================================================

case "$SOURCE" in

"${SOURCE_LABELS[reddit]}")
    fetch_reddit
    ;;

"${SOURCE_LABELS[releases]}")
    fetch_releases
    ;;

"${SOURCE_LABELS[tags]}")
    fetch_tags
    ;;

"${SOURCE_LABELS[commits]}")
    fetch_commits
    ;;

"${SOURCE_LABELS[issues]}")
    fetch_issues
    ;;

*)
    exit 0
    ;;

esac

# ============================================================
# Read Cache
# ============================================================

mapfile -t titles < "$TITLE_FILE"
mapfile -t urls < "$URL_FILE"

choice=$(
    printf "%s\n" "${titles[@]}" |
    rofi \
        -dmenu \
        -i \
        -p "$SOURCE" \
        -kb-custom-1 MouseSecondary \
        -mesg "🖱 Left: Gemini Summary    |    Right: Open Link" \
        -config "$HOME/.config/rofi/themes/general_news.rasi"
)

exit_code=$?

[[ -z "$choice" ]] && exit 0

index=-1

for i in "${!titles[@]}"
do
    if [[ "${titles[$i]}" == "$choice" ]]; then
        index=$i
        break
    fi
done

[[ $index -lt 0 ]] && exit 1

URL="${urls[$index]}"

# ============================================================
# Right Click
# ============================================================

if [[ $exit_code -eq 10 ]]; then
    xdg-open "$URL" &
    disown
    exit 0
fi

# ============================================================
# Gemini Summary
# ============================================================

summarize_url "$URL"

printf "%s\n" "$SUMMARY" | wl-copy

printf "%s" "$SUMMARY" | zenity \
    --text-info \
    --title="$PROJECT_NAME AI" \
    --width=750 \
    --height=650 \
    --font="Vazirmatn 14"