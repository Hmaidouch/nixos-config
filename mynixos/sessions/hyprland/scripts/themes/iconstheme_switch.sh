#!/usr/bin/env bash

ICONS=$(ls /run/current-system/sw/share/icons)

CHOICE=$(echo "$ICONS" | rofi -dmenu -p "Select Icon Theme")

[ -z "$CHOICE" ] && exit

gsettings set org.gnome.desktop.interface icon-theme "$CHOICE"