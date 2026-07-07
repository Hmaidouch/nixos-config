#!/usr/bin/env bash

set -euo pipefail

rss_fetch() {
    local url="$1"
    curl -fsS "$url"
}