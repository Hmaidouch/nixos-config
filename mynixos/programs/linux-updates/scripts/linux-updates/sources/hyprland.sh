#!/usr/bin/env bash

set -euo pipefail

PROJECT_NAME="Hyprland"

fetch_latest() {
    fetch_github_release_or_tag "hyprwm" "Hyprland" "Hyprland"
}