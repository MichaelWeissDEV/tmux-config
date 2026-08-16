# Status line

The bar along the bottom: session name on the left, window list in the middle,
clock and date on the right.

## What tmux does by default

tmux ships a green status bar with the session name, a window list, and the
host and time on the right. It refreshes every 15 seconds.

## What tmux-config changes

A quieter bar, themed, refreshing every 5 seconds. Everything is set in
`60-status.conf` and driven from a handful of options:

```tmux
set -g @cfg_status_position "bottom"    # or top
set -g @cfg_status_style    "default"   # minimal | default | detailed
set -g @cfg_show_session    "on"
set -g @cfg_clock_format    "%H:%M"
set -g @cfg_date_format     "%d.%m.%Y"  # "" hides the date
set -g @cfg_status_interval "5"
```

| Style | Shows |
| --- | --- |
| `minimal` | session name and windows only — fastest and quietest |
| `default` | adds the clock and date |
| `detailed` | adds the hostname and pane/zoom indicators |

<kbd>prefix</kbd> <kbd>b</kbd> toggles the bar away entirely. tmux leaves that
key free, so it is a pure addition.

## Performance

`@cfg_status_interval` is the most important number in the config.

Every refresh re-renders the bar. If you add a `#(shell command)` to the status
line, that forks a process **at this interval, for every attached session**. At
5 seconds this is unnoticeable. At 1 second with a `#()` in the bar, tmux will
visibly cost you CPU.

Only drop to 1 if you add a seconds-precision clock, and never combine 1 with
`#()`.

## Symbols

```tmux
set -g @cfg_symbols "auto"      # auto | unicode | ascii
```

This is not cosmetic. In a non-UTF-8 locale tmux replaces every non-ASCII
character with `_`, so a Unicode bar degrades into noise. On `auto` the locale
is checked and ASCII is used when UTF-8 is absent.

**No Nerd Font is required** by any setting. See [capabilities](../reference/capabilities.md).

## Colours

The bar follows your [theme](../customization/themes.md). To change only the
bar, override the theme variables it reads in your `local.conf` — see
[customising the status line](../customization/status-line.md).
