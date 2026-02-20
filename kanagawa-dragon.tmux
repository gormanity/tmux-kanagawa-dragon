#!/usr/bin/env bash

# source and run kanagawa-dragon theme

current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR=$current_dir
tmux set-environment -g "@ukiyo-root" "$ROOT_DIR"

$current_dir/scripts/ukiyo.sh
