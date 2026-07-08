#!/usr/bin/env bash

set -euo pipefail

PROJECT_NAME="Niri"

fetch_latest() {
    fetch_github_release_or_tag "niri-wm" "niri" "Niri"
}