#!/usr/bin/env bash


#THEMES=$(ls /run/current-system/sw/share/themes)
# قراءة ثيمات النظام + ثيمات الـ Home Manager الخاص بالمستخدم + ثيمات المجلد المحلي المباشر
THEMES=$( ( ls /run/current-system/sw/share/themes 2>/dev/null
            ls $HOME/.local/state/home-manager/gcroots/current-home/home-path/share/themes 2>/dev/null
          ) | sort -u )

CACHE_DIR="$HOME/.cache/themes"
STATE_FILE="$CACHE_DIR/state"

# إنشاء مجلد الكاش إن لم يكن موجوداً
mkdir -p "$CACHE_DIR"

if [ ! -f "$STATE_FILE" ]; then
  echo "Matcha-light-sea" > "$STATE_FILE"
fi

CHOICE=$(echo "$THEMES" | rofi -dmenu -p "Select GTK Theme")

[ -z "$CHOICE" ] && exit


gsettings set org.gnome.desktop.interface gtk-theme "$CHOICE"

	# 2. حفظ الاختيار للمستقبل (ليقرأه Nix)
echo -n "$CHOICE" > "$STATE_FILE"
notify-send -t 2000 "Theme Updated" "New theme: $CHOICE"