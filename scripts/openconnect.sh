#!/usr/bin/env bash
export LC_ALL=en_US.UTF-8

current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source $current_dir/utils.sh

main() {
  local label=$(get_tmux_option "@ukiyo-openconnect-label" "VPN")
  if pgrep -x openconnect >/dev/null 2>&1; then
    echo "$label"
  fi
}

main
