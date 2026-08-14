# Keybindings

!!! info "This page is generated"
    Do not edit it by hand. It is produced from the live config by
    `scripts/gen-keybindings.sh`, so it always matches what is actually bound.
    Regenerate with:

    ```bash
    ./scripts/gen-keybindings.sh > docs/keybindings.md
    ```

Throughout this page, **`prefix`** means the prefix key — <kbd>Ctrl</kbd>+<kbd>b</kbd>
by default. Change it with `@cfg_prefix` in
[`config/00-options.conf`](configuration.md#prefix).

You can always see the live list inside tmux with <kbd>prefix</kbd> <kbd>?</kbd>.

## With prefix

Press the prefix key first, release, then the key below.

| Key | Action |
| --- | --- |
| `!` | Break the pane into a new window |
| `"` | Split vertically (stacked) |
| `#` | List all paste buffers |
| `$` | Rename the current session |
| `%` | Split horizontally (side by side) |
| `&` | Kill current window |
| `'` | Prompt for window index to select |
| `(` | Switch to previous client |
| `)` | Switch to next client |
| `*` | New floating pane |
| `+` | Balance panes vertically |
| `,` | Rename current window |
| `-` | Split vertically (stacked) |
| `.` | Move the current window |
| `/` | Search backwards in the scrollback |
| `0` | Select window 0 |
| `1` | Select window 1 |
| `2` | Select window 2 |
| `3` | Select window 3 |
| `4` | Select window 4 |
| `5` | Select window 5 |
| `6` | Select window 6 |
| `7` | Select window 7 |
| `8` | Select window 8 |
| `9` | Select window 9 |
| `:` | Prompt for a command |
| `;` | Move to the previously active pane |
| `<` | Move window left |
| `=` | Balance panes horizontally |
| `>` | Move window right |
| `?` | List key bindings |
| `@` | Join a pane from another window |
| `C-Down` | Resize the pane down |
| `C-Left` | Resize the pane left |
| `C-Right` | Resize the pane right |
| `C-Up` | Resize the pane up |
| `C-b` | Send the prefix key |
| `C-h` | Previous window |
| `C-k` | Clear screen and history |
| `C-l` | Next window |
| `C-o` | Rotate through the panes |
| `C-p` | Jump to the previous prompt |
| `C-z` | Suspend the current client |
| `C` | Customize options |
| `DC` | Reset so the visible part of the window follows the cursor |
| `D` | Choose and detach a client from a list |
| `Down` | Select the pane below the active pane |
| `E` | Spread panes out evenly |
| `H` | Resize pane left |
| `J` | Resize pane down |
| `K` | Resize pane up |
| `L` | Resize pane right |
| `Left` | Select the pane to the left of the active pane |
| `M-1` | Set the even-horizontal layout |
| `M-2` | Set the even-vertical layout |
| `M-3` | Set the main-horizontal layout |
| `M-4` | Set the main-vertical layout |
| `M-5` | Select the tiled layout |
| `M-6` | Set the main-horizontal-mirrored layout |
| `M-7` | Set the main-vertical-mirrored layout |
| `M-Down` | Resize the pane down by 5 |
| `M-Left` | Resize the pane left by 5 |
| `M-Right` | Resize the pane right by 5 |
| `M-Up` | Resize the pane up by 5 |
| `M-n` | Select the next window with an alert |
| `M-o` | Rotate through the panes in reverse |
| `M-p` | Select the previous window with an alert |
| `M` | Clear the marked pane |
| `PPage` | Enter copy mode and scroll up |
| `P` | Choose a buffer to paste from |
| `Right` | Select the pane to the right of the active pane |
| `S-Down` | Move the visible part of the window down |
| `S-Left` | Move the visible part of the window left |
| `S-Right` | Move the visible part of the window right |
| `S-Up` | Move the visible part of the window up |
| `S` | Choose a session from a list |
| `Space` | Select next layout |
| `Tab` | Jump to the last used window |
| `Up` | Select the pane above the active pane |
| `[` | Enter copy mode |
| `\` | Split full height (side by side) |
| `]` | Paste the most recent paste buffer |
| `_` | Split full width (stacked) |
| `b` | Toggle the status bar |
| `c` | New window in the current directory |
| `d` | Detach from the session |
| `f` | Search for a pane |
| `g` | Toggle a floating scratch terminal |
| `h` | Select pane to the left |
| `i` | Display window information |
| `j` | Select pane below |
| `k` | Select pane above |
| `l` | Select pane to the right |
| `m` | Toggle the marked pane |
| `n` | Select the next window |
| `o` | Select the next pane |
| `p` | Paste the most recent tmux buffer |
| `q` | Display pane numbers |
| `r` | Reload the tmux config |
| `s` | Choose a session from a list |
| `t` | Show a clock |
| `w` | Choose a window from a list |
| `x` | Kill the active pane |
| `z` | Zoom the current pane in/out |
| `{` | Swap the active pane with the pane above |
| `|` | Split horizontally (side by side) |
| `}` | Swap the active pane with the pane below |
| `~` | Show messages |

## Without prefix

These are bound globally. tmux intercepts them before the program running in your pane sees them — see [the tradeoff note](configuration.md#alt-number-window-switching).

| Key | Action |
| --- | --- |
| `M-1` | Go to window 1 |
| `M-2` | Go to window 2 |
| `M-3` | Go to window 3 |
| `M-4` | Go to window 4 |
| `M-5` | Go to window 5 |
| `M-6` | Go to window 6 |
| `M-7` | Go to window 7 |
| `M-8` | Go to window 8 |
| `M-9` | Go to window 9 |

## Copy mode (vi)

Active **only** inside copy mode. These have no effect on Neovim or your shell. Enter copy mode with <kbd>prefix</kbd> <kbd>[</kbd>, leave it with <kbd>q</kbd>.

| Key | Action |
| --- | --- |
| `C-d` | Scroll half a page down |
| `C-u` | Scroll half a page up |
| `C-v` | Toggle block/rectangle select |
| `Enter` | Copy the selection and exit |
| `H` | Jump to start of line |
| `L` | Jump to end of line |
| `V` | Select the whole line |
| `v` | Start a selection |
| `y` | Copy the selection and exit |

---

*Generated from `tmux 3.7b`.*
