# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

tmux-kanagawa is a multi-theme tmux status bar plugin supporting Kanagawa and Tokyo Night color schemes. Forked from dracula/tmux.

## Architecture

### Entry Point
- `kanagawa.tmux` - Main entry point, sources `scripts/kanagawa.sh`

### Theme System (themes/)
```
themes/
├── loader.sh              # Theme loading logic
├── kanagawa/
│   ├── palette.sh         # Raw color definitions
│   ├── wave.sh            # Wave variant (default dark)
│   ├── dragon.sh          # Dragon variant (darker)
│   └── lotus.sh           # Lotus variant (light)
└── tokyonight/
    ├── palette.sh         # Raw color definitions
    ├── moon.sh            # Moon variant (default)
    ├── storm.sh           # Storm variant
    └── night.sh           # Night variant (darker)
```

### Core Scripts (scripts/)
- `kanagawa.sh` - Main theme logic, plugin loading, status bar configuration
- `theme.sh` - Color override support (`override_theme_colors`)
- `utils.sh` - Shared utilities (`get_tmux_option`, `normalize_percent_len`, `installed`)
- `state.sh` - State management for runtime option overrides

### Plugin Scripts (scripts/)
Each plugin is a standalone bash script that outputs text for the status bar:
- `battery.sh`, `cpu_info.sh`, `ram_info.sh`, `gpu_usage.sh` - System metrics
- `git.sh`, `hg.sh`, `fossil.sh` - Version control status
- `network.sh`, `network_bandwidth.sh`, `network_ping.sh`, `network_vpn.sh` - Network info
- `weather.sh`, `weather_wrapper.sh` - Weather display
- `kubernetes_context.sh`, `terraform.sh` - DevOps tools
- `spotify-tui.sh`, `playerctl.sh`, `mpc.sh` - Music players
- `ssh_session.sh`, `cwd.sh`, `attached_clients.sh`, `synchronize_panes.sh`, `continuum.sh`

### Menu System (menu_items/)
Interactive tmux menus accessible via `prefix + T`:
- `main.sh` - Main menu entry point
- `colors.sh` - Theme/variant selection
- `plugins.sh`, `options.sh` - Other settings

## Color System

### Theme Loading Flow
1. `kanagawa.sh` parses `@kanagawa-theme` option (format: `theme/variant`)
2. `loader.sh` sources `themes/<theme>/palette.sh` (raw colors)
3. `loader.sh` sources `themes/<theme>/<variant>.sh` (semantic mapping)
4. `theme.sh` applies user color overrides via `override_theme_colors()`

### Semantic Color Names
| Name | Role |
|------|------|
| `text` | Primary text/foreground |
| `bg_bar` | Status bar background |
| `bg_pane` | Window/pane background |
| `highlight` | Active element highlight |
| `selection` | Selected/focused element |
| `info` | Informational status (network, system) |
| `accent` | Primary accent (VCS, success states) |
| `notice` | Performance/attention (CPU, weather) |
| `error` | Error states |
| `muted` | Secondary status (battery, GPU) |
| `alert` | Prefix/alert active state |

Legacy color names (`white`, `gray`, `dark_gray`, etc.) are aliased for backward compatibility.

## Configuration Pattern

Theme selection:
```bash
set -g @kanagawa-theme "tokyonight/moon"  # theme/variant format
set -g @kanagawa-theme "wave"              # legacy format (kanagawa/wave)
```

Color overrides:
```bash
set -g @kanagawa-color-accent "#00ff00"    # hex value
set -g @kanagawa-color-bg-bar "sumi_ink_4" # palette variable name
```

Plugin colors:
```bash
set -g @kanagawa-[plugin-name]-colors "[semantic1] [semantic2]"
```

## Adding a New Theme

1. Create `themes/<theme-name>/palette.sh` with raw color definitions
2. Create variant files (e.g., `themes/<theme-name>/default.sh`) that map palette colors to semantic names
3. Update `themes/loader.sh` `get_default_variant()` function
4. Update `menu_items/colors.sh` to include new theme options

## Adding a New Plugin

1. Create `scripts/your_plugin.sh` (must be executable, output text to stdout)
2. Add handling in `scripts/kanagawa.sh` in the plugin loop:
   ```bash
   elif [ $plugin = "your-plugin" ]; then
     IFS=' ' read -r -a colors <<<$(get_tmux_option "@kanagawa-your-plugin-colors" "info bg_pane")
     script="#($current_dir/your_plugin.sh)"
   ```

## Testing Changes

Reload tmux configuration after changes:
```bash
tmux source-file ~/.tmux.conf
```

Or restart the tmux server for a clean state.
