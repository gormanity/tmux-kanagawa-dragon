# Theme color override and legacy alias support

override_theme_colors() {
  local semantic_names="text bg_bar bg_pane highlight selection info accent notice error muted alert"

  for name in $semantic_names; do
    local option_name="@kanagawa-color-${name//_/-}"
    local custom_value=$(get_tmux_option "$option_name" "")

    if [ -n "$custom_value" ]; then
      if [[ "$custom_value" == \#* ]]; then
        printf -v "$name" "%s" "$custom_value"
      else
        printf -v "$name" "%s" "${!custom_value}"
      fi
    fi
  done

  # Legacy aliases (deprecated - for backward compatibility)
  white=$text
  gray=$bg_bar
  dark_gray=$bg_pane
  light_purple=$highlight
  dark_purple=$selection
  cyan=$info
  green=$accent
  orange=$notice
  red=$error
  pink=$muted
  yellow=$alert
}
