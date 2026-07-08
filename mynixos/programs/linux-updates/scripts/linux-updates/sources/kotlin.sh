#!/usr/bin/env bash

set -euo pipefail

PROJECT_NAME="Kotlin"

fetch_latest() {
    fetch_github_release_or_tag "JetBrains" "kotlin" "Kotlin"
}