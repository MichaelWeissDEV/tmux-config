# Panes

A pane is a split of a window, each running its own program.

## What tmux does by default

| Key | Action |
| --- | --- |
| <kbd>prefix</kbd> <kbd>%</kbd> | split side by side |
| <kbd>prefix</kbd> <kbd>"</kbd> | split stacked |
| <kbd>prefix</kbd> arrows | move between panes |
| <kbd>prefix</kbd> <kbd>o</kbd> | cycle to the next pane |
| <kbd>prefix</kbd> <kbd>;</kbd> | back to the last pane |
| <kbd>prefix</kbd> <kbd>z</kbd> | zoom this pane full-window |
| <kbd>prefix</kbd> <kbd>x</kbd> | kill the pane (asks first) |
| <kbd>prefix</kbd> <kbd>q</kbd> | show pane numbers |
| <kbd>prefix</kbd> <kbd>{</kbd> / <kbd>}</kbd> | swap with the previous / next pane |
| <kbd>prefix</kbd> <kbd>M-</kbd>arrow | resize by 5 |
| <kbd>prefix</kbd> <kbd>Ctrl</kbd>+arrow | resize by 1 |
| <kbd>prefix</kbd> <kbd>&gt;</kbd> | the pane context menu |

## What tmux-config changes

### Splits keep your directory

<kbd>prefix</kbd> <kbd>%</kbd> and <kbd>prefix</kbd> <kbd>"</kbd> keep their
meaning and gain `-c "#{pane_current_path}"`, so a new pane opens where you
already are instead of in your home directory.

### Added keys

| Key | Action |
| --- | --- |
| <kbd>prefix</kbd> <kbd>&#124;</kbd> | split side by side |
| <kbd>prefix</kbd> <kbd>_</kbd> | split stacked |
| <kbd>prefix</kbd> <kbd>M-&#124;</kbd> | split full height, across the window |
| <kbd>prefix</kbd> <kbd>M-_</kbd> | split full width, across the window |
| <kbd>prefix</kbd> <kbd>h</kbd> <kbd>j</kbd> <kbd>k</kbd> <kbd>l</kbd> | move between panes, vi style |
| <kbd>prefix</kbd> <kbd>M-h</kbd> <kbd>M-j</kbd> <kbd>M-k</kbd> <kbd>M-l</kbd> | resize, repeatable |
| <kbd>prefix</kbd> <kbd>!</kbd> | break the pane out into its own window |
| <kbd>prefix</kbd> <kbd>@</kbd> | pull a pane in from another window |

`|` and `_` are mnemonic — the character looks like the split it makes. The
classic pairing is `|` and `-`, but tmux uses `-` for `delete-buffer`, so `_`
takes that half. It draws the same line and tmux leaves it free.

`!` is tmux's own `break-pane` with `-d` added, so you stay where you are
instead of being dragged to the new window.

### Why resize moved to Alt

Earlier versions used <kbd>prefix</kbd> <kbd>H</kbd> <kbd>J</kbd> <kbd>K</kbd>
<kbd>L</kbd>. That cost <kbd>prefix</kbd> <kbd>H</kbd>, which is now the
[Key Explorer](../keybindings/key-explorer.md). The Alt row does the same job,
and tmux's own <kbd>prefix</kbd> <kbd>M-</kbd>arrow bindings still work too.

## Zoom

<kbd>prefix</kbd> <kbd>z</kbd> — tmux's own, not rebound. Press it again to
restore. A zoomed pane is marked in the status bar when
`@cfg_status_style` is `detailed`.

## Dimming the inactive pane

```tmux
set -g @cfg_dim_inactive "on"
```

Off by default: it looks wrong on low-contrast themes.
