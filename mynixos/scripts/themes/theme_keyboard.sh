#!/usr/bin/env bash

THEME_DIR="/run/current-system/sw/share/themes"
STATE_FILE="$HOME/.cache/gtk_theme_index"

mkdir -p "$(dirname "$STATE_FILE")"

# جلب كل الثيمات
mapfile -t THEMES < <(ls -1 "$THEME_DIR")

# إذا لا يوجد ثيمات
[ ${#THEMES[@]} -eq 0 ] && exit 1

# إنشاء ملف الحالة إن لم يوجد
if [ ! -f "$STATE_FILE" ]; then
    echo 0 > "$STATE_FILE"
fi

INDEX=$(cat "$STATE_FILE")
TOTAL=${#THEMES[@]}

# تصحيح المؤشر إذا خرج عن الحدود
if [ "$INDEX" -ge "$TOTAL" ]; then
    INDEX=0
fi

THEME="${THEMES[$INDEX]}"

# تطبيق الثيم
gsettings set org.gnome.desktop.interface gtk-theme "$THEME"
# إشعار
notify-send -t 2000 "GTK Theme" "$THEME"

# تحديث المؤشر
NEXT=$(( (INDEX + 1) % TOTAL ))
echo "$NEXT" > "$STATE_FILE"