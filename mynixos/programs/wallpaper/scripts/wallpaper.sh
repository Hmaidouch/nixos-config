#!/usr/bin/env bash

set -euo pipefail

# ============================================================
# Directories
# ============================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="$SCRIPT_DIR/lib"

# ============================================================
# Load libraries
# ============================================================

source "$LIB_DIR/wallpapers.sh"
source "$LIB_DIR/cache.sh"
source "$LIB_DIR/picker.sh"
source "$LIB_DIR/random.sh"
source "$LIB_DIR/awww.sh"
source "$LIB_DIR/wallust.sh"

# ============================================================
# Choose wallpaper
# ============================================================

# لاختيار الخلفية من قائمة rofi
#picker_choose || exit 0
#IMAGE="$PICKED_WALLPAPER"

# لاختيار الخلفية عشوائيا
random_wallpaper || exit 0
IMAGE="$RANDOM_WALLPAPER"

# ============================================================
# Apply wallpaper
# ============================================================

awww_set "$IMAGE"

# ============================================================
# Generate colors
# ============================================================

wallust_apply "$IMAGE"

# ============================================================
# Cache
# ============================================================

cache_set_current "$IMAGE"
cache_add_history "$IMAGE"

exit 0