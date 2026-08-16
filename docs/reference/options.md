# Options reference

!!! info "This page is generated"
    Produced from `config/00-options.conf` by `scripts/gen-options.py`,
    so it cannot drift from the actual defaults. Regenerate with:

    ```bash
    ./scripts/gen-options.py > docs/reference/options.md
    ```

Every option below is set in [`config/00-options.conf`](../configuration/index.md). Change a value there, or override it in `local.conf`, then press ++ctrl+b++ ++r++.

## All options at a glance

| Option | Default | Accepted values |
| --- | --- | --- |
| [`@cfg_prefix`](#cfg-prefix) | `C-b` | `C-b` · `C-a` · `C-Space` · `any tmux key name` |
| [`@cfg_keep_default_prefix`](#cfg-keep-default-prefix) | `off` | `on` · `off` |
| [`@cfg_mouse`](#cfg-mouse) | `on` | `on` · `off` |
| [`@cfg_base_index`](#cfg-base-index) | `1` | `0` · `1` |
| [`@cfg_renumber_windows`](#cfg-renumber-windows) | `off` | `on` · `off` |
| [`@cfg_automatic_rename`](#cfg-automatic-rename) | `off` | `on` · `off` |
| [`@cfg_history_limit`](#cfg-history-limit) | `10000` | — |
| [`@cfg_escape_time`](#cfg-escape-time) | `10` | — |
| [`@cfg_repeat_time`](#cfg-repeat-time) | `500` | — |
| [`@cfg_focus_events`](#cfg-focus-events) | `on` | `on` · `off` |
| [`@cfg_vi_pane_keys`](#cfg-vi-pane-keys) | `on` | `on` · `off` |
| [`@cfg_alt_window_keys`](#cfg-alt-window-keys) | `on` | `on` · `off` |
| [`@cfg_plugin_navigator`](#cfg-plugin-navigator) | `off` | `on` · `off` |
| [`@cfg_key_explorer_fzf`](#cfg-key-explorer-fzf) | `off` | `on` · `off` |
| [`@cfg_mode_keys`](#cfg-mode-keys) | `vi` | `vi` · `emacs` |
| [`@cfg_system_clipboard`](#cfg-system-clipboard) | `on` | `on` · `off` |
| [`@cfg_osc52`](#cfg-osc52) | `on` | `on` · `off` · `external` |
| [`@cfg_copy_stays_in_mode`](#cfg-copy-stays-in-mode) | `off` | `on` · `off` |
| [`@cfg_truecolor`](#cfg-truecolor) | `auto` | `auto` · `on` · `off` |
| [`@cfg_symbols`](#cfg-symbols) | `auto` | `auto` · `unicode` · `ascii` |
| [`@cfg_extended_keys`](#cfg-extended-keys) | `auto` | `auto` · `on` · `off` |
| [`@cfg_theme`](#cfg-theme) | `catppuccin-mocha` | `catppuccin-mocha` · `catppuccin-latte` · `tokyonight` · `nord` · `gruvbox-dark` · `rose-pine` · `custom` |
| [`@cfg_status_position`](#cfg-status-position) | `bottom` | `bottom` · `top` |
| [`@cfg_status_interval`](#cfg-status-interval) | `5` | — |
| [`@cfg_status_style`](#cfg-status-style) | `default` | — |
| [`@cfg_show_session`](#cfg-show-session) | `on` | `on` · `off` |
| [`@cfg_clock_format`](#cfg-clock-format) | `%H:%M` | — |
| [`@cfg_date_format`](#cfg-date-format) | `%d.%m.%Y` | — |
| [`@cfg_pane_border_lines`](#cfg-pane-border-lines) | `single` | `single` · `double` · `heavy` · `simple` · `number` |
| [`@cfg_dim_inactive`](#cfg-dim-inactive) | `off` | `on` · `off` |
| [`@cfg_plugins`](#cfg-plugins) | `off` | `on` · `off` |
| [`@cfg_plugin_resurrect`](#cfg-plugin-resurrect) | `off` | `on` · `off` |
| [`@cfg_plugin_continuum`](#cfg-plugin-continuum) | `off` | `on` · `off` |
| [`@cfg_plugin_navigator`](#cfg-plugin-navigator) | `off` | `on` · `off` |
| [`@cfg_plugin_open`](#cfg-plugin-open) | `off` | `on` · `off` |
| [`@cfg_plugin_logging`](#cfg-plugin-logging) | `off` | `on` · `off` |
| [`@cfg_plugin_extrakto`](#cfg-plugin-extrakto) | `off` | `on` · `off` |
| [`@cfg_plugin_fpp`](#cfg-plugin-fpp) | `off` | `on` · `off` |
| [`@cfg_plugin_sessionist`](#cfg-plugin-sessionist) | `off` | `on` · `off` |

## Prefix

### `@cfg_prefix` { #cfg-prefix }

```tmux
set -g @cfg_prefix "C-b"
```

**Accepted values:** `C-b` · `C-a` · `C-Space` · `any tmux key name`

The prefix key. "C-b" is the tmux default and does not collide with anything.
"C-a" is the classic screen-style choice — comfier to reach, but it takes over
"jump to start of line" in every shell and readline app inside your panes.

### `@cfg_keep_default_prefix` { #cfg-keep-default-prefix }

```tmux
set -g @cfg_keep_default_prefix "off"
```

**Accepted values:** `on` · `off`

Keep the original C-b working as a secondary prefix after remapping above.
Useful while your fingers are still relearning. Costs you nothing otherwise.

## Behaviour

### `@cfg_mouse` { #cfg-mouse }

```tmux
set -g @cfg_mouse "on"
```

**Accepted values:** `on` · `off`

Mouse: click to select panes/windows, drag borders to resize, scroll to enter
copy mode. Turning this off gives you back your terminal's native selection.

### `@cfg_base_index` { #cfg-base-index }

```tmux
set -g @cfg_base_index "1"
```

**Accepted values:** `0` · `1`

Window/pane numbering start. 1 keeps the number keys aligned with the keyboard
row; 0 is the tmux default.

### `@cfg_renumber_windows` { #cfg-renumber-windows }

```tmux
set -g @cfg_renumber_windows "off"
```

**Accepted values:** `on` · `off`

Close a gap in the window list when a window is closed.
off = a window keeps its number for the whole session (muscle memory stays
valid); on = numbers are always contiguous.

### `@cfg_automatic_rename` { #cfg-automatic-rename }

```tmux
set -g @cfg_automatic_rename "off"
```

**Accepted values:** `on` · `off`

Let running programs rename your windows. Off means the name you set stays
set — recommended, otherwise every `cd` or command rewrites your window list.

### `@cfg_history_limit` { #cfg-history-limit }

```tmux
set -g @cfg_history_limit "10000"
```

Scrollback lines per pane. Each pane reserves this independently, so very
large values cost real memory (roughly: lines x panes x line length).
10000 is a good balance; 50000+ is noticeable with many panes open.

### `@cfg_escape_time` { #cfg-escape-time }

```tmux
set -g @cfg_escape_time "10"
```

Time in ms tmux waits after ESC to see if it starts an escape sequence.
Keep this LOW. The tmux default of 500ms is what makes Neovim feel laggy
when leaving insert mode. 10 is responsive and still safe over SSH.

### `@cfg_repeat_time` { #cfg-repeat-time }

```tmux
set -g @cfg_repeat_time "500"
```

How long (ms) a `-r` binding stays repeatable without re-pressing the prefix.

### `@cfg_focus_events` { #cfg-focus-events }

```tmux
set -g @cfg_focus_events "on"
```

**Accepted values:** `on` · `off`

Forward focus events to programs inside panes. Neovim needs this for
'autoread' and for its FocusGained/FocusLost autocommands to fire.

## Keybindings

### `@cfg_vi_pane_keys` { #cfg-vi-pane-keys }

```tmux
set -g @cfg_vi_pane_keys "on"
```

**Accepted values:** `on` · `off`

vi-style hjkl for moving between panes (with prefix).

### `@cfg_alt_window_keys` { #cfg-alt-window-keys }

```tmux
set -g @cfg_alt_window_keys "on"
```

**Accepted values:** `on` · `off`

Alt+1..9 to jump straight to a window, with NO prefix.
TRADEOFF, on by default but worth understanding: this steals Alt+number from
every program running inside your panes. Notably it breaks Alt+number tab
switching in terminal browsers, some TUI editors, and Windows Terminal's own
tab shortcuts. Set to "off" if you live in those.

### `@cfg_plugin_navigator` { #cfg-plugin-navigator }

```tmux
set -g @cfg_plugin_navigator "off"
```

**Accepted values:** `on` · `off`

Seamless pane<->split navigation with Ctrl+hjkl shared between tmux and
Neovim. Requires the christoomey/vim-tmux-navigator plugin on the Neovim side.
See docs/plugins/available.md#neovim-integration — turning this on without the Neovim
half will make Ctrl+hjkl do nothing useful inside Neovim.

### `@cfg_key_explorer_fzf` { #cfg-key-explorer-fzf }

```tmux
set -g @cfg_key_explorer_fzf "off"
```

**Accepted values:** `on` · `off`

Let the Key Explorer (prefix + H) use fzf for its search, when fzf is
installed. This is a convenience, never a requirement: with this off, or with
fzf missing, the Explorer uses its own built-in search and behaves the same.

## Copy mode & clipboard

### `@cfg_mode_keys` { #cfg-mode-keys }

```tmux
set -g @cfg_mode_keys "vi"
```

**Accepted values:** `vi` · `emacs`

vi or emacs keys inside copy mode. This affects copy mode ONLY — it has no
effect on Neovim or on your shell's line editor.

### `@cfg_system_clipboard` { #cfg-system-clipboard }

```tmux
set -g @cfg_system_clipboard "on"
```

**Accepted values:** `on` · `off`

Copy to the OS clipboard, not just tmux's internal buffer.
The right tool is picked per platform (pbcopy / wl-copy / xclip / clip.exe).

### `@cfg_osc52` { #cfg-osc52 }

```tmux
set -g @cfg_osc52 "on"
```

**Accepted values:** `on` · `off` · `external`

Send copied text to your *local* terminal via OSC 52 escape sequences.
This is what makes copying work when tmux runs on a remote host over SSH.
Your terminal emulator must support OSC 52 (most modern ones do; see
docs/reference/troubleshooting.md#clipboard for a compatibility list).

### `@cfg_copy_stays_in_mode` { #cfg-copy-stays-in-mode }

```tmux
set -g @cfg_copy_stays_in_mode "off"
```

**Accepted values:** `on` · `off`

Keep the selection visible and stay in copy mode after yanking, instead of
jumping straight back to the prompt.

## These three are TRI-STATE:

### `@cfg_truecolor` { #cfg-truecolor }

```tmux
set -g @cfg_truecolor "auto"
```

**Accepted values:** `auto` · `on` · `off`

24-bit colour. On "auto", COLORTERM and the terminal name decide.
Forcing "on" is occasionally right behind a serial link or another
multiplexer, where a capable terminal exports nothing that proves it.

### `@cfg_symbols` { #cfg-symbols }

```tmux
set -g @cfg_symbols "auto"
```

**Accepted values:** `auto` · `unicode` · `ascii`

Which glyphs the status bar may use.
This is NOT cosmetic: in a non-UTF-8 locale tmux replaces every non-ASCII
character with "_", so a Unicode status bar degrades into unreadable noise.
On "auto" the locale is checked and ASCII is used when UTF-8 is absent.
No Nerd Font is required by any setting.

### `@cfg_extended_keys` { #cfg-extended-keys }

```tmux
set -g @cfg_extended_keys "auto"
```

**Accepted values:** `auto` · `on` · `off`

Extended key reporting (CSI u). Lets applications distinguish keys the old
encoding cannot, such as Ctrl-Shift-Letter.
Deliberately "auto", never "always": forcing it sends a keyboard protocol
through to Neovim that the outer terminal may not round-trip correctly, and
the failure mode is keys silently doing nothing.

## Appearance

### `@cfg_theme` { #cfg-theme }

```tmux
set -g @cfg_theme "catppuccin-mocha"
```

**Accepted values:** `catppuccin-mocha` · `catppuccin-latte` · `tokyonight` · `nord` · `gruvbox-dark` · `rose-pine` · `custom`

Colour scheme. Files live in config/themes/.
Adding your own is a 20-line file — see docs/customization/themes.md.

### `@cfg_status_position` { #cfg-status-position }

```tmux
set -g @cfg_status_position "bottom"
```

**Accepted values:** `bottom` · `top`

Status bar position.

### `@cfg_status_interval` { #cfg-status-interval }

```tmux
set -g @cfg_status_interval "5"
```

Status bar refresh in seconds.
PERFORMANCE: this is the single most important number in this file. Every
refresh re-renders the bar, and if you add a `#(shell command)` to the status
it forks a process at this interval, on every session. 5 is comfortable.
Only go to 1 if you add a seconds-precision clock, and never combine 1 with
`#()`. See docs/configuration/index.md#status-bar-performance.

### `@cfg_status_style` { #cfg-status-style }

```tmux
set -g @cfg_status_style "default"
```

Preset for what the status bar shows.
minimal  — session name + windows only. Fastest, quietest.
default  — adds clock and date on the right.
detailed — adds hostname and pane/zoom indicators.

### `@cfg_show_session` { #cfg-show-session }

```tmux
set -g @cfg_show_session "on"
```

**Accepted values:** `on` · `off`

Show the session name block on the left.

### `@cfg_clock_format` { #cfg-clock-format }

```tmux
set -g @cfg_clock_format "%H:%M"
```

Clock format on the right. Standard strftime.
examples: "%H:%M" (24h) | "%I:%M %p" (12h)

### `@cfg_date_format` { #cfg-date-format }

```tmux
set -g @cfg_date_format "%d.%m.%Y"
```

Date format on the right. Empty string "" hides the date entirely.
examples: "%d.%m.%Y" (DE) | "%Y-%m-%d" (ISO) | "%a %d %b" | ""

### `@cfg_pane_border_lines` { #cfg-pane-border-lines }

```tmux
set -g @cfg_pane_border_lines "single"
```

**Accepted values:** `single` · `double` · `heavy` · `simple` · `number`

Pane border line style. "single" is universally safe. The heavier styles need
a font with good box-drawing glyphs and can look broken in some terminals.

### `@cfg_dim_inactive` { #cfg-dim-inactive }

```tmux
set -g @cfg_dim_inactive "off"
```

**Accepted values:** `on` · `off`

Dim inactive panes slightly so the focused one stands out.
Costs nothing, but looks wrong on themes with low contrast.

## Plugins

### `@cfg_plugins` { #cfg-plugins }

```tmux
set -g @cfg_plugins "off"
```

**Accepted values:** `on` · `off`

Master switch. With this off, no adapter is even sourced.

### `@cfg_plugin_resurrect` { #cfg-plugin-resurrect }

```tmux
set -g @cfg_plugin_resurrect "off"
```

**Accepted values:** `on` · `off`

Save and restore sessions, windows, panes and layouts across a reboot.
Manual save = prefix + Ctrl-s, manual restore = prefix + Ctrl-r.

### `@cfg_plugin_continuum` { #cfg-plugin-continuum }

```tmux
set -g @cfg_plugin_continuum "off"
```

**Accepted values:** `on` · `off`

Automatic save every 15 min, and restore on server start.
Requires @cfg_plugin_resurrect — it is NOT enabled for you automatically;
you get a message instead, because silently turning on a second plugin is
exactly the hidden behaviour this project avoids.
Keeps a background process alive for the life of the server and writes to
disk on a timer. Deliberately opt-in.

### `@cfg_plugin_navigator` { #cfg-plugin-navigator }

```tmux
set -g @cfg_plugin_navigator "off"
```

**Accepted values:** `on` · `off`

Move between Neovim splits and tmux panes with one set of keys
(Ctrl-h/j/k/l). Needs the Neovim-side plugin as well.
WARNING: this is the only shipped plugin that intercepts application input.
It binds Ctrl-hjkl globally and forwards them when the pane runs vim/nvim.
`scripts/check` reports that interception — correctly. See docs/integration/neovim.md.

### `@cfg_plugin_open` { #cfg-plugin-open }

```tmux
set -g @cfg_plugin_open "off"
```

**Accepted values:** `on` · `off`

Open a highlighted file or URL from copy mode (`o`, and `Ctrl-o` in $EDITOR).

### `@cfg_plugin_logging` { #cfg-plugin-logging }

```tmux
set -g @cfg_plugin_logging "off"
```

**Accepted values:** `on` · `off`

Log a pane's output to a file, capture the screen, or dump full history.
Bindings: prefix+Shift-P toggles logging, prefix+Alt-P screen-captures,
prefix+Alt-Shift-P saves the complete history.

### `@cfg_plugin_extrakto` { #cfg-plugin-extrakto }

```tmux
set -g @cfg_plugin_extrakto "off"
```

**Accepted values:** `on` · `off`

Fuzzy-find and copy anything visible on screen — paths, URLs, hashes, words.
Needs `fzf` on PATH; you get a message if it is missing rather than a
binding that silently does nothing.

### `@cfg_plugin_fpp` { #cfg-plugin-fpp }

```tmux
set -g @cfg_plugin_fpp "off"
```

**Accepted values:** `on` · `off`

Pick a file path out of pane output and open it. Needs `fpp` on PATH.

### `@cfg_plugin_sessionist` { #cfg-plugin-sessionist }

```tmux
set -g @cfg_plugin_sessionist "off"
```

**Accepted values:** `on` · `off`

Extra session management from inside the current session.
Note: binds prefix+S, which this config already uses for choose-tree.
`scripts/check` reports the clash.

