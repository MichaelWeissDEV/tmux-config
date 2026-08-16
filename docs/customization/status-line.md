# Customising the status line

The shipped bar is driven by options; you rarely need to write status-line
format strings by hand. Start with [status line](../tmux/status-line.md) for
what the options do.

## Small changes — options only

```tmux
# in local-options.conf
set -g @cfg_status_position "top"
set -g @cfg_status_style    "minimal"
set -g @cfg_show_session    "off"
set -g @cfg_clock_format    "%I:%M %p"
set -g @cfg_date_format     ""          # hide the date
set -g @cfg_status_interval "5"
```

## Bigger changes — raw tmux

Anything tmux can do, set it in `local.conf`. Because that file is sourced last,
it overrides `60-status.conf` entirely:

```tmux
set -g status-right " #{=20:pane_title} | #{host_short} "
set -g status-left  " #S "
set -g window-status-current-format " #I:#W "
```

## Adding a shell command

This is where status lines get expensive. `#()` forks a process **every
refresh, for every attached session**:

```tmux
set -g status-right " #(uptime | cut -d, -f1) "
```

At `@cfg_status_interval 5` that is one fork every five seconds per client. It
is fine. At interval 1 it is not — see
[performance](../tmux/status-line.md#performance).

Cheaper alternatives, in order of preference:

1. a tmux format (`#{...}`) instead of a shell command — no fork at all
2. a script that caches its result and prints the cached value
3. a longer `@cfg_status_interval`

## Using theme colours

The bar reads the same variables your [theme](themes.md) sets, so referring to
them keeps your customisation theme-agnostic:

```tmux
set -g status-right "#[fg=#{@thm_accent}] #S #[default]"
```

Available variables are listed in [theming](themes.md). Using them means
switching `@cfg_theme` recolours your additions too, instead of leaving a
hardcoded colour that clashes.

## Symbols

Anything non-ASCII you add is subject to the same locale caveat as the shipped
bar: in a non-UTF-8 locale tmux renders it as `_`. Check `@cfg_symbols` and
[capabilities](../reference/capabilities.md) before reaching for box-drawing
characters. No setting in this config requires a Nerd Font, and additions of
your own should not either if you use the config on more than one machine.
