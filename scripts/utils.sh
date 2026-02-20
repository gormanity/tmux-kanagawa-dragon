#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$CURRENT_DIR/state.sh"

# Backward compatibility: migrate @kanagawa-* and @kanagawa-dragon-* options to @ukiyo-*
migrate_legacy_options() {
  local legacy_opts=$(tmux show-options -g 2>/dev/null | grep -E "^@kanagawa-|^@kanagawa-dragon-" | cut -d' ' -f1)
  for opt in $legacy_opts; do
    local new_opt="${opt/@kanagawa-dragon-/@ukiyo-}"
    new_opt="${new_opt/@kanagawa-/@ukiyo-}"
    local val=$(tmux show-option -gqv "$opt")
    if [ -n "$val" ]; then
      tmux set-option -gq "$new_opt" "$val"
      tmux set-option -gu "$opt"
    fi
  done
}

get_tmux_option() {
  local option=$1
  local default_value=$2
  local option_value=$(tmux show-option -gqv "$option")
  local state_option_value=$(read_option_from_state "$option")

  if [ ! -z "$state_option_value" ]; then
    echo $state_option_value
  elif [ ! -z "$option_value" ]; then
    echo $option_value
  else
    echo $default_value
  fi
}

get_tmux_window_option() {
  local option=$1
  local default_value=$2
  local option_value=$(tmux show-window-options -v "$option")
  if [ ! -z "$option_value" ]; then
    echo $option_value
  else
    echo $default_value
  fi
}

# normalize the percentage string to always have a length of 5
normalize_percent_len() {
  # the max length that the percent can reach, which happens for a two digit number with a decimal house: "99.9%"
  max_len=5
  percent_len=${#1}
  let diff_len=$max_len-$percent_len
  # if the diff_len is even, left will have 1 more space than right
  let left_spaces=($diff_len + 1)/2
  let right_spaces=($diff_len)/2
  printf "%${left_spaces}s%s%${right_spaces}s\n" "" $1 ""
}

installed() {
  command -v $1 &>/dev/null
}
