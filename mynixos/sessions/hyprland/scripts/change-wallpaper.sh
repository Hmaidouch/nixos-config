#!/usr/bin/env bash

WALL_DIR="$HOME/Images/Wallpapers"

IMG=$(find "$WALL_DIR" -type f | shuf -n 1)

swww img "$IMG" --transition-type wipe --transition-duration 1