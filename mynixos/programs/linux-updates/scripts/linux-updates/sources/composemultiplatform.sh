#!/usr/bin/env bash

set -euo pipefail

PROJECT_NAME="Compose Multiplatform"

fetch_latest() {
    fetch_github_release_or_tag "JetBrains" "compose-multiplatform" "Compose Multiplatform"
}