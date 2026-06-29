#!/usr/bin/env bash

ICONS=$( ( ls /run/current-system/sw/share/icons 2>/dev/null
            ls $HOME/.local/state/home-manager/gcroots/current-home/home-path/share/icons 2>/dev/null
          ) | sort -u )

CHOICE=$(echo "$ICONS" | rofi -dmenu -p "Select Icon Theme")

[ -z "$CHOICE" ] && exit

gsettings set org.gnome.desktop.interface icon-theme "$CHOICE"