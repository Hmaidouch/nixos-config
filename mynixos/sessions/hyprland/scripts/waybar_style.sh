#!/usr/bin/env bash

SOURCE_DIR="../../../programs/waybar/style"

CACHE_DIR="$HOME/.cache/waybar"
TARGET_FILE="$CACHE_DIR/active_style.css"
STATE_FILE="$CACHE_DIR/state"

mkdir -p "$CACHE_DIR"

# قائمة الثيمات بالترتيب
THEMES=(
circle_dark
circle_light
rectangle_dark
rectangle_light
)

# إذا لم يوجد state
if [ ! -f "$STATE_FILE" ]; then
    echo "${THEMES[0]}" > "$STATE_FILE"
fi

CURRENT=$(cat "$STATE_FILE")

# إيجاد موقع الثيم الحالي
INDEX=0
for i in "${!THEMES[@]}"; do
    if [[ "${THEMES[$i]}" == "$CURRENT" ]]; then
        INDEX=$i
        break
    fi
done

# حساب الثيم التالي (بشكل دائري)
NEXT_INDEX=$(( (INDEX + 1) % ${#THEMES[@]} ))
NEXT_THEME="${THEMES[$NEXT_INDEX]}"

# تطبيقه
cp "$SOURCE_DIR/$NEXT_THEME.css" "$TARGET_FILE"
echo "$NEXT_THEME" > "$STATE_FILE"

notify-send -t 2000 "Waybar Theme" "$NEXT_THEME"

# إعادة تحميل Waybar
pkill -SIGUSR2 waybar