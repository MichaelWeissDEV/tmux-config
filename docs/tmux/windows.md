# Windows

A window is a full-screen workspace inside a session — the tabs of tmux. Each
one holds one or more [panes](panes.md).

## What tmux does by default

| Key | Action |
| --- | --- |
| <kbd>prefix</kbd> <kbd>c</kbd> | new window |
| <kbd>prefix</kbd> <kbd>n</kbd> / <kbd>p</kbd> | next / previous window |
| <kbd>prefix</kbd> <kbd>0</kbd>…<kbd>9</kbd> | select window by number |
| <kbd>prefix</kbd> <kbd>l</kbd> | last window |
| <kbd>prefix</kbd> <kbd>,</kbd> | rename |
| <kbd>prefix</kbd> <kbd>&</kbd> | kill (asks first) |
| <kbd>prefix</kbd> <kbd>w</kbd> | choose from a list |
| <kbd>prefix</kbd> <kbd>f</kbd> | find a window by name or content |
| <kbd>prefix</kbd> <kbd>.</kbd> | renumber this window |
| <kbd>prefix</kbd> <kbd>&lt;</kbd> | the window context menu |

## What tmux-config changes

### `prefix c` keeps your directory

tmux opens a new window in your home directory. This config opens it where you
already are:

```tmux
bind -N "New window in the current directory" c new-window -c "#{pane_current_path}"
```

Same key, same purpose — only the working directory differs. That makes it an
*enhancement*, not a takeover, and the Key Explorer marks it `^+^`.

### Added keys

| Key | Action | Why |
| --- | --- | --- |
| <kbd>prefix</kbd> <kbd>Ctrl</kbd>+<kbd>h</kbd> / <kbd>Ctrl</kbd>+<kbd>l</kbd> | previous / next window | repeatable, so you can hold and skim |
| <kbd>prefix</kbd> <kbd>Tab</kbd> | last window | where `last-window` lives now — see below |
| <kbd>prefix</kbd> <kbd>M-&lt;</kbd> / <kbd>M-&gt;</kbd> | move this window left / right | Alt-prefixed so tmux's own `<` and `>` menus keep working |
| <kbd>Alt</kbd>+<kbd>1</kbd>…<kbd>9</kbd> | jump to a window, **no prefix** | see the tradeoff below |

### `prefix l` — the one displaced default

This config binds <kbd>prefix</kbd> <kbd>l</kbd> to *select the pane to the
right*, completing the vi-style `h`/`j`/`k`/`l` row. tmux binds it to
`last-window`.

That behaviour is not lost — it is on <kbd>prefix</kbd> <kbd>Tab</kbd>, which
exists for exactly this reason. And if you would rather have tmux's original:

```tmux
set -g @cfg_vi_pane_keys "off"
```

### Alt+number, and its cost

<kbd>Alt</kbd>+<kbd>1</kbd>…<kbd>9</kbd> select windows with no prefix at all.
This is a **global** binding: tmux swallows those keys before the program in
your pane ever sees them. That breaks Alt+number tab switching in terminal
browsers, some TUI apps, and Windows Terminal itself.

```tmux
set -g @cfg_alt_window_keys "off"
```

They are Alt keys rather than Ctrl keys on purpose — no editor key is grabbed,
so [Neovim is unaffected](../integration/neovim.md).

## Naming and numbering

```tmux
set -g @cfg_base_index        "1"     # windows start at 1, matching the keyboard
set -g @cfg_automatic_rename  "off"   # the name you set stays set
set -g @cfg_renumber_windows  "off"   # a window keeps its number for life
```

`automatic_rename` off is the notable one: with it on, every `cd` or long
command rewrites your window list, so a name you chose never survives.
`renumber_windows` off means muscle memory stays valid — window 3 is window 3
even after window 2 closes.
