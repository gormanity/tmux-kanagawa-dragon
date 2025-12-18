#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && cd .. && pwd)"

source "$ROOT_DIR/scripts/utils.sh"

mark_if_active() {
  local current=$1
  local check=$2
  local label=$3
  if [ "$current" = "$check" ]; then
    echo "${label}*"
  else
    echo "$label"
  fi
}

render() {
  local current_theme=$(get_tmux_option "@ukiyo-theme" "wave")

  # Normalize legacy values
  case "$current_theme" in
    wave|dragon|lotus)
      current_theme="kanagawa/$current_theme"
      ;;
  esac

  # Kanagawa variants
  local k_wave=$(mark_if_active "$current_theme" "kanagawa/wave" "Wave")
  local k_dragon=$(mark_if_active "$current_theme" "kanagawa/dragon" "Dragon")
  local k_lotus=$(mark_if_active "$current_theme" "kanagawa/lotus" "Lotus")

  # Tokyo Night variants
  local t_moon=$(mark_if_active "$current_theme" "tokyonight/moon" "Moon")
  local t_storm=$(mark_if_active "$current_theme" "tokyonight/storm" "Storm")
  local t_night=$(mark_if_active "$current_theme" "tokyonight/night" "Night")

  # Catppuccin variants
  local c_mocha=$(mark_if_active "$current_theme" "catppuccin/mocha" "Mocha")
  local c_macchiato=$(mark_if_active "$current_theme" "catppuccin/macchiato" "Macchiato")
  local c_frappe=$(mark_if_active "$current_theme" "catppuccin/frappe" "Frappé")
  local c_latte=$(mark_if_active "$current_theme" "catppuccin/latte" "Latte")

  tmux display-menu -T "#[align=centre fg=green]Themes" -x R -y P \
    "" \
    "#[align=centre]─── Kanagawa ───" "" "" \
    "$k_wave" 1 "run -b '#{@ukiyo-root}/scripts/actions.sh set_state_and_tmux_option theme kanagawa/wave'" \
    "$k_dragon" 2 "run -b '#{@ukiyo-root}/scripts/actions.sh set_state_and_tmux_option theme kanagawa/dragon'" \
    "$k_lotus" 3 "run -b '#{@ukiyo-root}/scripts/actions.sh set_state_and_tmux_option theme kanagawa/lotus'" \
    "" \
    "#[align=centre]─── Tokyo Night ───" "" "" \
    "$t_moon" 4 "run -b '#{@ukiyo-root}/scripts/actions.sh set_state_and_tmux_option theme tokyonight/moon'" \
    "$t_storm" 5 "run -b '#{@ukiyo-root}/scripts/actions.sh set_state_and_tmux_option theme tokyonight/storm'" \
    "$t_night" 6 "run -b '#{@ukiyo-root}/scripts/actions.sh set_state_and_tmux_option theme tokyonight/night'" \
    "" \
    "#[align=centre]─── Catppuccin ───" "" "" \
    "$c_mocha" 7 "run -b '#{@ukiyo-root}/scripts/actions.sh set_state_and_tmux_option theme catppuccin/mocha'" \
    "$c_macchiato" 8 "run -b '#{@ukiyo-root}/scripts/actions.sh set_state_and_tmux_option theme catppuccin/macchiato'" \
    "$c_frappe" 9 "run -b '#{@ukiyo-root}/scripts/actions.sh set_state_and_tmux_option theme catppuccin/frappe'" \
    "$c_latte" 0 "run -b '#{@ukiyo-root}/scripts/actions.sh set_state_and_tmux_option theme catppuccin/latte'" \
    "" \
    "<-- Back" b "run -b 'source #{@ukiyo-root}/menu_items/main.sh'" \
    "Close menu" q ""
}

render
