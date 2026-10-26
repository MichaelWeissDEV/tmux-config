# Complete keymap

:::{note} This page is generated
Do not edit it by hand. `scripts/gen-docs` builds it from the key
registry in [`keys/`](https://github.com/MichaelWeissDEV/tmux-config/tree/main/keys),
and CI fails if the two disagree. Regenerate with:

```bash
./scripts/gen-docs
```
:::

Every key tmux-config knows about — tmux's own defaults included. Throughout,
**`prefix`** means the prefix key, <kbd>Ctrl</kbd>+<kbd>b</kbd> unless you
changed `@cfg_prefix`.

Prefer to look this up without leaving your terminal? Press
<kbd>prefix</kbd> <kbd>H</kbd> for the [Key Explorer](key-explorer.md), which
searches the same data.

| Mark | Meaning |
| --- | --- |
| *(none)* | a plain tmux default, untouched by this config |
| ^+^ | a tmux default kept for the same purpose, improved |
| ^!^ | a tmux default **displaced** — see the note under the table |
| ^\*^ | added by tmux-config on a key tmux leaves free |
| ^p^ | contributed by an optional plugin |

Bindings marked *only when* apply solely when that option is set; the tmux
default applies otherwise.


## With the prefix

Press the prefix key, release, then the key below.

### General

| Key | Action | Runs |
| --- | --- | --- |
| <kbd>/</kbd> | Describe key binding | `command-prompt -k -p key { list-keys -1N "%%" }` |
| <kbd>:</kbd> | Prompt for a command | `command-prompt` |
| <kbd>?</kbd> | List key bindings | `list-keys -N` |
| <kbd>C-b</kbd> | Send the prefix key | `send-prefix` |
| <kbd>C-k</kbd> | Clear the screen and the scrollback ^*^ | `send-keys -R \; clear-history \; display-message "  screen and history cleared"` |
| <kbd>DC</kbd> | Reset so the visible part of the window follows the cursor *(repeats)* | `refresh-client -c` |
| <kbd>S-Down</kbd> | Move the visible part of the window down *(repeats)* | `refresh-client -D 10` |
| <kbd>S-Left</kbd> | Move the visible part of the window left *(repeats)* | `refresh-client -L 10` |
| <kbd>S-Right</kbd> | Move the visible part of the window right *(repeats)* | `refresh-client -R 10` |
| <kbd>S-Up</kbd> | Move the visible part of the window up *(repeats)* | `refresh-client -U 10` |
| <kbd>b</kbd> | Toggle the status bar ^*^ | `set -g status` |
| <kbd>g</kbd> | Toggle a floating scratch terminal ^*^ | `display-popup -E -w 80% -h 75% -d "#{pane_current_path}"` |
| <kbd>i</kbd> | Display window information | `display-message` |
| <kbd>r</kbd> | Redraw the current client | `refresh-client` |
| <kbd>t</kbd> | Show a clock | `clock-mode` |
| <kbd>~</kbd> | Show messages | `show-messages` |

### Sessions

| Key | Action | Runs |
| --- | --- | --- |
| <kbd>$</kbd> | Rename current session | `command-prompt -I "#S" { rename-session "%%" }` |
| <kbd>(</kbd> | Switch to previous client | `switch-client -p` |
| <kbd>)</kbd> | Switch to next client | `switch-client -n` |
| <kbd>C-z</kbd> | Suspend the current client | `suspend-client` |
| <kbd>D</kbd> | Choose and detach a client from a list | `choose-client -Z` |
| <kbd>L</kbd> | Switch to the last client | `switch-client -l` |
| <kbd>d</kbd> | Detach the current client | `detach-client` |
| <kbd>s</kbd> | Choose a session from a list | `choose-tree -Zs` |

### Windows

| Key | Action | Runs |
| --- | --- | --- |
| <kbd>&</kbd> | Kill current window | `confirm-before -p "kill-window #W? (y/n)" kill-window` |
| <kbd>'</kbd> | Prompt for window index to select | `command-prompt -T window-target -p index { select-window -t ":%%" }` |
| <kbd>,</kbd> | Rename current window | `command-prompt -I "#W" { rename-window "%%" }` |
| <kbd>.</kbd> | Move the current window | `command-prompt -T target { move-window -t "%%" }` |
| <kbd>0</kbd> | Select window 0 | `select-window -t :=0` |
| <kbd>1</kbd> | Select window 1 | `select-window -t :=1` |
| <kbd>2</kbd> | Select window 2 | `select-window -t :=2` |
| <kbd>3</kbd> | Select window 3 | `select-window -t :=3` |
| <kbd>4</kbd> | Select window 4 | `select-window -t :=4` |
| <kbd>5</kbd> | Select window 5 | `select-window -t :=5` |
| <kbd>6</kbd> | Select window 6 | `select-window -t :=6` |
| <kbd>7</kbd> | Select window 7 | `select-window -t :=7` |
| <kbd>8</kbd> | Select window 8 | `select-window -t :=8` |
| <kbd>9</kbd> | Select window 9 | `select-window -t :=9` |
| <kbd><</kbd> | Display window menu | `display-menu -T "#[align=centre]#{window_index}:#{window_name}" -x W -y W "#{?#{>:#{session_windows},1},,-}Swap Left" l { swap-window -t :-1 } "#{?#{>:#{session_windows},1},,-}Swap Right" r { swap-window -t :+1 } "#{?pane_marked_set,,-}Swap Marked" s { swap-window } '' Kill X { kill-window } Respawn R { respawn-window -k } "#{?pane_marked,Unmark,Mark}" m { select-pane -m } Rename n { command-prompt -F -I "#W" { rename-window -t "#{window_id}" "%%" } } '' "New After" w { new-window -a } "New At End" W { new-window }` |
| <kbd>C-h</kbd> | Previous window ^*^ *(repeats)* | `previous-window` |
| <kbd>C-l</kbd> | Next window ^*^ *(repeats)* | `next-window` |
| <kbd>M-<</kbd> | Move the current window left ^*^ *(repeats)* | `swap-window -d -t -1` |
| <kbd>M-></kbd> | Move the current window right ^*^ *(repeats)* | `swap-window -d -t +1` |
| <kbd>M-n</kbd> | Select the next window with an alert | `next-window -a` |
| <kbd>M-p</kbd> | Select the previous window with an alert | `previous-window -a` |
| <kbd>Tab</kbd> | Jump to the last used window ^*^ | `last-window` |
| <kbd>c</kbd> | New window in the current directory ^+^ | `new-window -c "#{pane_current_path}"` |
| <kbd>f</kbd> | Search for a pane | `command-prompt { find-window -Z "%%" }` |
| <kbd>l</kbd> | Select the previously current window | `last-window` |
| <kbd>n</kbd> | Select the next window | `next-window` |
| <kbd>p</kbd> | Select the previous window | `previous-window` |
| <kbd>w</kbd> | Choose a window from a list | `choose-tree -Zw` |

### Panes

| Key | Action | Runs |
| --- | --- | --- |
| <kbd>!</kbd> | Break the pane into a new window ^+^ | `break-pane -d` |
| <kbd>"</kbd> | Split stacked, in the current directory ^+^ | `split-window -v -c "#{pane_current_path}"` |
| <kbd>%</kbd> | Split side by side, in the current directory ^+^ | `split-window -h -c "#{pane_current_path}"` |
| <kbd>*</kbd> | New floating pane | `new-pane` |
| <kbd>;</kbd> | Move to the previously active pane | `last-pane` |
| <kbd>></kbd> | Display pane menu | `display-menu -T "#[align=centre]#{pane_index} (#{pane_id})" -x P -y P "#{?#{m/r:(copy\|view)-mode,#{pane_mode}},Go To Top,}" < { send-keys -X history-top } "#{?#{m/r:(copy\|view)-mode,#{pane_mode}},Go To Bottom,}" > { send-keys -X history-bottom } '' "#{?#{&&:#{buffer_size},#{!:#{pane_in_mode}}},Paste #[underscore]#{=/9/...:buffer_sample},}" p { paste-buffer } '' "#{?mouse_word,Search For #[underscore]#{=/9/...:mouse_word},}" C-r { if-shell -F "#{?#{m/r:(copy\|view)-mode,#{pane_mode}},0,1}" "copy-mode -t=" ; send-keys -X -t = search-backward -- "#{q:mouse_word}" } "#{?mouse_word,Type #[underscore]#{=/9/...:mouse_word},}" C-y { copy-mode -q ; send-keys -l "#{q:mouse_word}" } "#{?mouse_word,Copy #[underscore]#{=/9/...:mouse_word},}" c { copy-mode -q ; set-buffer "#{q:mouse_word}" } "#{?mouse_line,Copy Line,}" l { copy-mode -q ; set-buffer "#{q:mouse_line}" } '' "#{?mouse_hyperlink,Type #[underscore]#{=/9/...:mouse_hyperlink},}" C-h { copy-mode -q ; send-keys -l "#{q:mouse_hyperlink}" } "#{?mouse_hyperlink,Copy #[underscore]#{=/9/...:mouse_hyperlink},}" h { copy-mode -q ; set-buffer "#{q:mouse_hyperlink}" } '' "#{?#{!:#{pane_floating_flag}},Horizontal Split,}" h { split-window -h } "#{?#{!:#{pane_floating_flag}},Vertical Split,}" v { split-window -v } '' "#{?#{&&:#{!:#{pane_floating_flag}},#{>:#{window_panes},1}},Swap Up,}" u { swap-pane -U } "#{?#{&&:#{!:#{pane_floating_flag}},#{>:#{window_panes},1}},Swap Down,}" d { swap-pane -D } "#{?pane_marked_set,,-}Swap Marked" s { swap-pane } '' Kill X { kill-pane } Respawn R { respawn-pane -k } "#{?pane_marked,Unmark,Mark}" m { select-pane -m } "#{?#{>:#{window_panes},1},,-}#{?window_zoomed_flag,Unzoom,Zoom}" z { resize-pane -Z }` |
| <kbd>@</kbd> | Join a pane from another window ^*^ | `choose-window "join-pane -h -s '%%'"` |
| <kbd>C-Down</kbd> | Resize the pane down *(repeats)* | `resize-pane -D` |
| <kbd>C-Left</kbd> | Resize the pane left *(repeats)* | `resize-pane -L` |
| <kbd>C-Right</kbd> | Resize the pane right *(repeats)* | `resize-pane -R` |
| <kbd>C-Up</kbd> | Resize the pane up *(repeats)* | `resize-pane -U` |
| <kbd>C-o</kbd> | Rotate through the panes | `rotate-window` |
| <kbd>Down</kbd> | Select the pane below the active pane *(repeats)* | `select-pane -D` |
| <kbd>Left</kbd> | Select the pane to the left of the active pane *(repeats)* | `select-pane -L` |
| <kbd>M</kbd> | Clear the marked pane | `select-pane -M` |
| <kbd>M-Down</kbd> | Resize the pane down by 5 *(repeats)* | `resize-pane -D 5` |
| <kbd>M-Left</kbd> | Resize the pane left by 5 *(repeats)* | `resize-pane -L 5` |
| <kbd>M-Right</kbd> | Resize the pane right by 5 *(repeats)* | `resize-pane -R 5` |
| <kbd>M-Up</kbd> | Resize the pane up by 5 *(repeats)* | `resize-pane -U 5` |
| <kbd>M-_</kbd> | Split full width, stacked ^*^ | `split-window -fv -c "#{pane_current_path}"` |
| <kbd>M-h</kbd> | Resize the pane left ^*^ *(repeats)* | `resize-pane -L 5` |
| <kbd>M-j</kbd> | Resize the pane down ^*^ *(repeats)* | `resize-pane -D 5` |
| <kbd>M-k</kbd> | Resize the pane up ^*^ *(repeats)* | `resize-pane -U 5` |
| <kbd>M-l</kbd> | Resize the pane right ^*^ *(repeats)* | `resize-pane -R 5` |
| <kbd>M-o</kbd> | Rotate through the panes in reverse | `rotate-window -D` |
| <kbd>M-\|</kbd> | Split full height, side by side ^*^ | `split-window -fh -c "#{pane_current_path}"` |
| <kbd>Right</kbd> | Select the pane to the right of the active pane *(repeats)* | `select-pane -R` |
| <kbd>Up</kbd> | Select the pane above the active pane *(repeats)* | `select-pane -U` |
| <kbd>_</kbd> | Split stacked ^*^ | `split-window -v -c "#{pane_current_path}"` |
| <kbd>h</kbd> | Select the pane to the left ^*^ *(only when `@cfg_vi_pane_keys=on`)* | `select-pane -L` |
| <kbd>j</kbd> | Select the pane below ^*^ *(only when `@cfg_vi_pane_keys=on`)* | `select-pane -D` |
| <kbd>k</kbd> | Select the pane above ^*^ *(only when `@cfg_vi_pane_keys=on`)* | `select-pane -U` |
| <kbd>l</kbd> | Select the pane to the right ^!^ *(only when `@cfg_vi_pane_keys=on`)* | `select-pane -R` |
| <kbd>m</kbd> | Toggle the marked pane | `select-pane -m` |
| <kbd>o</kbd> | Select the next pane | `select-pane -t :.+` |
| <kbd>q</kbd> | Display pane numbers | `display-panes` |
| <kbd>x</kbd> | Kill the active pane | `confirm-before -p "kill-pane #P? (y/n)" kill-pane` |
| <kbd>z</kbd> | Zoom the active pane | `resize-pane -Z` |
| <kbd>{</kbd> | Swap the active pane with the pane above | `swap-pane -U` |
| <kbd>\|</kbd> | Split side by side ^*^ | `split-window -h -c "#{pane_current_path}"` |
| <kbd>}</kbd> | Swap the active pane with the pane below | `swap-pane -D` |

- <kbd>l</kbd> displaces the tmux default `last-window`. Completes the vi-style h/j/k/l pane row, which is why this one key displaces a default. tmux binds l to last-window; that is still available on prefix Tab, which this config adds for exactly this reason.

### Layouts

| Key | Action | Runs |
| --- | --- | --- |
| <kbd>E</kbd> | Spread panes out evenly | `select-layout -E` |
| <kbd>M-1</kbd> | Set the even-horizontal layout | `select-layout even-horizontal` |
| <kbd>M-2</kbd> | Set the even-vertical layout | `select-layout even-vertical` |
| <kbd>M-3</kbd> | Set the main-horizontal layout | `select-layout main-horizontal` |
| <kbd>M-4</kbd> | Set the main-vertical layout | `select-layout main-vertical` |
| <kbd>M-5</kbd> | Select the tiled layout | `select-layout tiled` |
| <kbd>M-6</kbd> | Set the main-horizontal-mirrored layout | `select-layout main-horizontal-mirrored` |
| <kbd>M-7</kbd> | Set the main-vertical-mirrored layout | `select-layout main-vertical-mirrored` |
| <kbd>Space</kbd> | Select next layout | `next-layout` |

### Copy mode

| Key | Action | Runs |
| --- | --- | --- |
| <kbd>C-f</kbd> | Search the scrollback ^*^ | `copy-mode \; send-keys -X search-backward ""` |
| <kbd>C-p</kbd> | Jump to the previous shell prompt ^*^ | `copy-mode \; send-keys -X previous-prompt` |
| <kbd>PPage</kbd> | Enter copy mode and scroll up | `copy-mode -u` |
| <kbd>[</kbd> | Enter copy mode | `copy-mode` |

### Buffers

| Key | Action | Runs |
| --- | --- | --- |
| <kbd>#</kbd> | List all paste buffers | `list-buffers` |
| <kbd>-</kbd> | Delete the most recent paste buffer | `delete-buffer` |
| <kbd>=</kbd> | Choose a paste buffer from a list | `choose-buffer -Z` |
| <kbd>]</kbd> | Paste the most recent paste buffer | `paste-buffer -p` |

### Configuration

| Key | Action | Runs |
| --- | --- | --- |
| <kbd>C</kbd> | Customize options | `customize-mode -Z` |
| <kbd>H</kbd> | Open the Key Explorer ^*^ | `display-popup -E -w 80% -h 80% "~/.config/tmux/scripts/key-explorer"` |
| <kbd>R</kbd> | Reload the tmux config ^*^ | `source-file ~/.config/tmux/tmux.conf \; display-message "  config reloaded"` |

## Without the prefix

Bound globally. tmux intercepts these before the program in your pane sees them.

### General

| Key | Action | Runs |
| --- | --- | --- |
| <kbd>M-MouseDown3StatusLeft</kbd> | Display the context menu | `display-menu -T "#[align=centre]#{session_name}" -t = -x M -y W Next n { switch-client -n } Previous p { switch-client -p } '' Renumber N { move-window -r } Rename r { command-prompt -I "#S" { rename-session "%%" } } Detach d { detach-client } '' "New Session" s { new-session } "New Window" w { new-window }` |
| <kbd>MouseDown3StatusLeft</kbd> | Display the context menu | `display-menu -T "#[align=centre]#{session_name}" -t = -x M -y W Next n { switch-client -n } Previous p { switch-client -p } '' Renumber N { move-window -r } Rename r { command-prompt -I "#S" { rename-session "%%" } } Detach d { detach-client } '' "New Session" s { new-session } "New Window" w { new-window }` |

### Sessions

| Key | Action | Runs |
| --- | --- | --- |
| <kbd>MouseDown1Status</kbd> | Switch client | `switch-client -t =` |

### Windows

| Key | Action | Runs |
| --- | --- | --- |
| <kbd>C-MouseDown1Status</kbd> | Swap window | `swap-window -t @` |
| <kbd>M-1</kbd> | Go to window 1 ^*^ *(only when `@cfg_alt_window_keys=on`)* | `select-window -t :=1` |
| <kbd>M-2</kbd> | Go to window 2 ^*^ *(only when `@cfg_alt_window_keys=on`)* | `select-window -t :=2` |
| <kbd>M-3</kbd> | Go to window 3 ^*^ *(only when `@cfg_alt_window_keys=on`)* | `select-window -t :=3` |
| <kbd>M-4</kbd> | Go to window 4 ^*^ *(only when `@cfg_alt_window_keys=on`)* | `select-window -t :=4` |
| <kbd>M-5</kbd> | Go to window 5 ^*^ *(only when `@cfg_alt_window_keys=on`)* | `select-window -t :=5` |
| <kbd>M-6</kbd> | Go to window 6 ^*^ *(only when `@cfg_alt_window_keys=on`)* | `select-window -t :=6` |
| <kbd>M-7</kbd> | Go to window 7 ^*^ *(only when `@cfg_alt_window_keys=on`)* | `select-window -t :=7` |
| <kbd>M-8</kbd> | Go to window 8 ^*^ *(only when `@cfg_alt_window_keys=on`)* | `select-window -t :=8` |
| <kbd>M-9</kbd> | Go to window 9 ^*^ *(only when `@cfg_alt_window_keys=on`)* | `select-window -t :=9` |
| <kbd>M-MouseDown3Status</kbd> | Display the context menu | `display-menu -T "#[align=centre]#{window_index}:#{window_name}" -t = -x W -y W "#{?#{>:#{session_windows},1},,-}Swap Left" l { swap-window -t :-1 } "#{?#{>:#{session_windows},1},,-}Swap Right" r { swap-window -t :+1 } "#{?pane_marked_set,,-}Swap Marked" s { swap-window } '' Kill X { kill-window } Respawn R { respawn-window -k } "#{?pane_marked,Unmark,Mark}" m { select-pane -m } Rename n { command-prompt -F -I "#W" { rename-window -t "#{window_id}" "%%" } } '' "New After" w { new-window -a } "New At End" W { new-window }` |
| <kbd>MouseDown3Status</kbd> | Display the context menu | `display-menu -T "#[align=centre]#{window_index}:#{window_name}" -t = -x W -y W "#{?#{>:#{session_windows},1},,-}Swap Left" l { swap-window -t :-1 } "#{?#{>:#{session_windows},1},,-}Swap Right" r { swap-window -t :+1 } "#{?pane_marked_set,,-}Swap Marked" s { swap-window } '' Kill X { kill-window } Respawn R { respawn-window -k } "#{?pane_marked,Unmark,Mark}" m { select-pane -m } Rename n { command-prompt -F -I "#W" { rename-window -t "#{window_id}" "%%" } } '' "New After" w { new-window -a } "New At End" W { new-window }` |
| <kbd>WheelDownStatus</kbd> | Next window | `next-window` |
| <kbd>WheelUpStatus</kbd> | Previous window | `previous-window` |

### Panes

| Key | Action | Runs |
| --- | --- | --- |
| <kbd>C-MouseDown1Pane</kbd> | Swap pane | `swap-pane -s @` |
| <kbd>M-MouseDown3Pane</kbd> | Display the context menu | `display-menu -T "#[align=centre]#{pane_index} (#{pane_id})" -t = -x M -y M "#{?#{m/r:(copy\|view)-mode,#{pane_mode}},Go To Top,}" < { send-keys -X history-top } "#{?#{m/r:(copy\|view)-mode,#{pane_mode}},Go To Bottom,}" > { send-keys -X history-bottom } '' "#{?#{&&:#{buffer_size},#{!:#{pane_in_mode}}},Paste #[underscore]#{=/9/...:buffer_sample},}" p { paste-buffer } '' "#{?mouse_word,Search For #[underscore]#{=/9/...:mouse_word},}" C-r { if-shell -F "#{?#{m/r:(copy\|view)-mode,#{pane_mode}},0,1}" "copy-mode -t=" ; send-keys -X -t = search-backward -- "#{q:mouse_word}" } "#{?mouse_word,Type #[underscore]#{=/9/...:mouse_word},}" C-y { copy-mode -q ; send-keys -l "#{q:mouse_word}" } "#{?mouse_word,Copy #[underscore]#{=/9/...:mouse_word},}" c { copy-mode -q ; set-buffer "#{q:mouse_word}" } "#{?mouse_line,Copy Line,}" l { copy-mode -q ; set-buffer "#{q:mouse_line}" } '' "#{?mouse_hyperlink,Type #[underscore]#{=/9/...:mouse_hyperlink},}" C-h { copy-mode -q ; send-keys -l "#{q:mouse_hyperlink}" } "#{?mouse_hyperlink,Copy #[underscore]#{=/9/...:mouse_hyperlink},}" h { copy-mode -q ; set-buffer "#{q:mouse_hyperlink}" } '' "#{?#{!:#{pane_floating_flag}},Horizontal Split,}" h { split-window -h } "#{?#{!:#{pane_floating_flag}},Vertical Split,}" v { split-window -v } '' "#{?#{&&:#{!:#{pane_floating_flag}},#{>:#{window_panes},1}},Swap Up,}" u { swap-pane -U } "#{?#{&&:#{!:#{pane_floating_flag}},#{>:#{window_panes},1}},Swap Down,}" d { swap-pane -D } "#{?pane_marked_set,,-}Swap Marked" s { swap-pane } '' Kill X { kill-pane } Respawn R { respawn-pane -k } "#{?pane_marked,Unmark,Mark}" m { select-pane -m } "#{?#{>:#{window_panes},1},,-}#{?window_zoomed_flag,Unzoom,Zoom}" z { resize-pane -Z }` |
| <kbd>MouseDown1Border</kbd> | Select pane | `select-pane -M` |
| <kbd>MouseDown1Control8</kbd> | Resize pane | `resize-pane -Z` |
| <kbd>MouseDown1Control9</kbd> | Display the context menu | `display-menu -O -T "Kill pane #{pane_index}?" -t = -x M -y M Yes y { kill-pane -t = } No n { }` |
| <kbd>MouseDown1Pane</kbd> | Select pane | `select-pane -t = \; send-keys -M` |
| <kbd>MouseDown3Pane</kbd> | Display the context menu | `if-shell -F -t = "#{\|\|:#{mouse_any_flag},#{&&:#{pane_in_mode},#{?#{m/r:(copy\|view)-mode,#{pane_mode}},0,1}}}" { select-pane -t = ; send-keys -M } { display-menu -T "#[align=centre]#{pane_index} (#{pane_id})" -t = -x M -y M "#{?#{m/r:(copy\|view)-mode,#{pane_mode}},Go To Top,}" < { send-keys -X history-top } "#{?#{m/r:(copy\|view)-mode,#{pane_mode}},Go To Bottom,}" > { send-keys -X history-bottom } '' "#{?#{&&:#{buffer_size},#{!:#{pane_in_mode}}},Paste #[underscore]#{=/9/...:buffer_sample},}" p { paste-buffer } '' "#{?mouse_word,Search For #[underscore]#{=/9/...:mouse_word},}" C-r { if-shell -F "#{?#{m/r:(copy\|view)-mode,#{pane_mode}},0,1}" "copy-mode -t=" ; send-keys -X -t = search-backward -- "#{q:mouse_word}" } "#{?mouse_word,Type #[underscore]#{=/9/...:mouse_word},}" C-y { copy-mode -q ; send-keys -l "#{q:mouse_word}" } "#{?mouse_word,Copy #[underscore]#{=/9/...:mouse_word},}" c { copy-mode -q ; set-buffer "#{q:mouse_word}" } "#{?mouse_line,Copy Line,}" l { copy-mode -q ; set-buffer "#{q:mouse_line}" } '' "#{?mouse_hyperlink,Type #[underscore]#{=/9/...:mouse_hyperlink},}" C-h { copy-mode -q ; send-keys -l "#{q:mouse_hyperlink}" } "#{?mouse_hyperlink,Copy #[underscore]#{=/9/...:mouse_hyperlink},}" h { copy-mode -q ; set-buffer "#{q:mouse_hyperlink}" } '' "#{?#{!:#{pane_floating_flag}},Horizontal Split,}" h { split-window -h } "#{?#{!:#{pane_floating_flag}},Vertical Split,}" v { split-window -v } '' "#{?#{&&:#{!:#{pane_floating_flag}},#{>:#{window_panes},1}},Swap Up,}" u { swap-pane -U } "#{?#{&&:#{!:#{pane_floating_flag}},#{>:#{window_panes},1}},Swap Down,}" d { swap-pane -D } "#{?pane_marked_set,,-}Swap Marked" s { swap-pane } '' Kill X { kill-pane } Respawn R { respawn-pane -k } "#{?pane_marked,Unmark,Mark}" m { select-pane -m } "#{?#{>:#{window_panes},1},,-}#{?window_zoomed_flag,Unzoom,Zoom}" z { resize-pane -Z } }` |
| <kbd>MouseDrag1Border</kbd> | Resize pane | `resize-pane -M` |

### Copy mode

| Key | Action | Runs |
| --- | --- | --- |
| <kbd>DoubleClick1Pane</kbd> | Copy pipe and cancel | `select-pane -t = \; if-shell -F "#{\|\|:#{pane_in_mode},#{mouse_any_flag}}" { send-keys -M } { copy-mode -H ; send-keys -X select-word ; run-shell -d 0.3 ; send-keys -X copy-pipe-and-cancel }` |
| <kbd>MouseDown1ScrollbarDown</kbd> | Page down | `if-shell -F -t = "#{pane_in_mode}" { send-keys -X page-down } { copy-mode -d }` |
| <kbd>MouseDown1ScrollbarUp</kbd> | Page up | `if-shell -F -t = "#{pane_in_mode}" { send-keys -X page-up } { copy-mode -u }` |
| <kbd>MouseDrag1Pane</kbd> | If shell | `if-shell -F "#{\|\|:#{pane_in_mode},#{mouse_any_flag}}" { send-keys -M } { copy-mode -M }` |
| <kbd>MouseDrag1ScrollbarSlider</kbd> | Scroll to mouse | `if-shell -F -t = "#{pane_in_mode}" { send-keys -X scroll-to-mouse } { copy-mode -S }` |
| <kbd>TripleClick1Pane</kbd> | Copy pipe and cancel | `select-pane -t = \; if-shell -F "#{\|\|:#{pane_in_mode},#{mouse_any_flag}}" { send-keys -M } { copy-mode -H ; send-keys -X select-line ; run-shell -d 0.3 ; send-keys -X copy-pipe-and-cancel }` |
| <kbd>WheelUpPane</kbd> | If shell | `if-shell -F "#{\|\|:#{alternate_on},#{pane_in_mode},#{mouse_any_flag}}" { send-keys -M } { copy-mode -e }` |

### Buffers

| Key | Action | Runs |
| --- | --- | --- |
| <kbd>MouseDown2Pane</kbd> | Select pane | `select-pane -t = \; if-shell -F "#{\|\|:#{pane_in_mode},#{mouse_any_flag}}" { send-keys -M } { paste-buffer -p }` |

## Copy mode (vi keys)

Active **only** inside copy mode, and only while `@cfg_mode_keys` is `vi` — the default. These have no effect on Neovim or your shell.

### Copy mode

| Key | Action | Runs |
| --- | --- | --- |
| <kbd>#</kbd> | Search backward | `send-keys -FX search-backward -- "#{copy_cursor_word}"` |
| <kbd>$</kbd> | End of line | `send-keys -X end-of-line` |
| <kbd>%</kbd> | Next matching bracket | `send-keys -X next-matching-bracket` |
| <kbd>*</kbd> | Search forward | `send-keys -FX search-forward -- "#{copy_cursor_word}"` |
| <kbd>,</kbd> | Jump reverse | `send-keys -X jump-reverse` |
| <kbd>/</kbd> | Search forward | `command-prompt -T search -p "(search down)" { send-keys -X search-forward -- "%%" }` |
| <kbd>0</kbd> | Start of line | `send-keys -X start-of-line` |
| <kbd>1</kbd> | Command prompt | `command-prompt -N -I 1 -p (repeat) { send-keys -N "%%" }` |
| <kbd>2</kbd> | Command prompt | `command-prompt -N -I 2 -p (repeat) { send-keys -N "%%" }` |
| <kbd>3</kbd> | Command prompt | `command-prompt -N -I 3 -p (repeat) { send-keys -N "%%" }` |
| <kbd>4</kbd> | Command prompt | `command-prompt -N -I 4 -p (repeat) { send-keys -N "%%" }` |
| <kbd>5</kbd> | Command prompt | `command-prompt -N -I 5 -p (repeat) { send-keys -N "%%" }` |
| <kbd>6</kbd> | Command prompt | `command-prompt -N -I 6 -p (repeat) { send-keys -N "%%" }` |
| <kbd>7</kbd> | Command prompt | `command-prompt -N -I 7 -p (repeat) { send-keys -N "%%" }` |
| <kbd>8</kbd> | Command prompt | `command-prompt -N -I 8 -p (repeat) { send-keys -N "%%" }` |
| <kbd>9</kbd> | Command prompt | `command-prompt -N -I 9 -p (repeat) { send-keys -N "%%" }` |
| <kbd>:</kbd> | Goto line | `command-prompt -p "(goto line)" { send-keys -X goto-line -- "%%" }` |
| <kbd>;</kbd> | Jump again | `send-keys -X jump-again` |
| <kbd>?</kbd> | Search backward | `command-prompt -T search -p "(search up)" { send-keys -X search-backward -- "%%" }` |
| <kbd>A</kbd> | Append selection and cancel | `send-keys -X append-selection-and-cancel` |
| <kbd>B</kbd> | Previous space | `send-keys -X previous-space` |
| <kbd>BSpace</kbd> | Cursor left | `send-keys -X cursor-left` |
| <kbd>C-Down</kbd> | Scroll down | `send-keys -X scroll-down` |
| <kbd>C-Up</kbd> | Scroll up | `send-keys -X scroll-up` |
| <kbd>C-[</kbd> | Clear selection | `send-keys -X clear-selection` |
| <kbd>C-b</kbd> | Page up | `send-keys -X page-up` |
| <kbd>C-c</kbd> | Cancel | `send-keys -X cancel` |
| <kbd>C-d</kbd> | Halfpage down | `send-keys -X halfpage-down` |
| <kbd>C-e</kbd> | Scroll down | `send-keys -X scroll-down` |
| <kbd>C-f</kbd> | Page down | `send-keys -X page-down` |
| <kbd>C-h</kbd> | Cursor left | `send-keys -X cursor-left` |
| <kbd>C-j</kbd> | Copy pipe and cancel | `send-keys -X copy-pipe-and-cancel` |
| <kbd>C-u</kbd> | Halfpage up | `send-keys -X halfpage-up` |
| <kbd>C-v</kbd> | Rectangle toggle | `send-keys -X rectangle-toggle` |
| <kbd>C-y</kbd> | Scroll up | `send-keys -X scroll-up` |
| <kbd>D</kbd> | Copy pipe end of line and cancel | `send-keys -X copy-pipe-end-of-line-and-cancel` |
| <kbd>DoubleClick1Pane</kbd> | Copy pipe and cancel | `select-pane \; send-keys -X select-word \; run-shell -d 0.3 \; send-keys -X copy-pipe-and-cancel` |
| <kbd>Down</kbd> | Cursor down | `send-keys -X cursor-down` |
| <kbd>E</kbd> | Next space end | `send-keys -X next-space-end` |
| <kbd>End</kbd> | End of line | `send-keys -X end-of-line` |
| <kbd>Enter</kbd> | Copy the selection and stay in copy mode ^!^ *(only when `@cfg_copy_stays_in_mode=on`)* | `send-keys -X copy-pipe` |
| <kbd>Enter</kbd> | Copy pipe and cancel | `send-keys -X copy-pipe-and-cancel` |
| <kbd>Escape</kbd> | Clear selection | `send-keys -X clear-selection` |
| <kbd>F</kbd> | Jump backward | `command-prompt -1 -p "(jump backward)" { send-keys -X jump-backward -- "%%" }` |
| <kbd>G</kbd> | History bottom | `send-keys -X history-bottom` |
| <kbd>H</kbd> | Top line | `send-keys -X top-line` |
| <kbd>Home</kbd> | Start of line | `send-keys -X start-of-line` |
| <kbd>J</kbd> | Scroll down | `send-keys -X scroll-down` |
| <kbd>K</kbd> | Scroll up | `send-keys -X scroll-up` |
| <kbd>L</kbd> | Bottom line | `send-keys -X bottom-line` |
| <kbd>Left</kbd> | Cursor left | `send-keys -X cursor-left` |
| <kbd>M</kbd> | Middle line | `send-keys -X middle-line` |
| <kbd>M-x</kbd> | Jump to mark | `send-keys -X jump-to-mark` |
| <kbd>MouseDown1Pane</kbd> | Click to place the cursor and clear the selection ^+^ | `select-pane \; send-keys -X clear-selection` |
| <kbd>MouseDrag1Pane</kbd> | Begin selection | `select-pane \; send-keys -X begin-selection` |
| <kbd>MouseDragEnd1Pane</kbd> | Copy the mouse selection and stay in copy mode ^!^ *(only when `@cfg_copy_stays_in_mode=on`)* | `send-keys -X copy-pipe` |
| <kbd>MouseDragEnd1Pane</kbd> | Copy pipe and cancel | `send-keys -X copy-pipe-and-cancel` |
| <kbd>N</kbd> | Search reverse | `send-keys -X search-reverse` |
| <kbd>NPage</kbd> | Page down | `send-keys -X page-down` |
| <kbd>P</kbd> | Toggle position | `send-keys -X toggle-position` |
| <kbd>PPage</kbd> | Page up | `send-keys -X page-up` |
| <kbd>Right</kbd> | Cursor right | `send-keys -X cursor-right` |
| <kbd>Space</kbd> | Begin selection | `send-keys -X begin-selection` |
| <kbd>T</kbd> | Jump to backward | `command-prompt -1 -p "(jump to backward)" { send-keys -X jump-to-backward -- "%%" }` |
| <kbd>TripleClick1Pane</kbd> | Copy pipe and cancel | `select-pane \; send-keys -X select-line \; run-shell -d 0.3 \; send-keys -X copy-pipe-and-cancel` |
| <kbd>Up</kbd> | Cursor up | `send-keys -X cursor-up` |
| <kbd>V</kbd> | Select line | `send-keys -X select-line` |
| <kbd>W</kbd> | Next space | `send-keys -X next-space` |
| <kbd>WheelDownPane</kbd> | Scroll down three lines ^+^ | `select-pane \; send-keys -X -N 3 scroll-down` |
| <kbd>WheelUpPane</kbd> | Scroll up three lines ^+^ | `select-pane \; send-keys -X -N 3 scroll-up` |
| <kbd>X</kbd> | Set mark | `send-keys -X set-mark` |
| <kbd>^</kbd> | Back to indentation | `send-keys -X back-to-indentation` |
| <kbd>b</kbd> | Previous word | `send-keys -X previous-word` |
| <kbd>e</kbd> | Next word end | `send-keys -X next-word-end` |
| <kbd>f</kbd> | Jump forward | `command-prompt -1 -p "(jump forward)" { send-keys -X jump-forward -- "%%" }` |
| <kbd>g</kbd> | History top | `send-keys -X history-top` |
| <kbd>h</kbd> | Cursor left | `send-keys -X cursor-left` |
| <kbd>j</kbd> | Cursor down | `send-keys -X cursor-down` |
| <kbd>k</kbd> | Cursor up | `send-keys -X cursor-up` |
| <kbd>l</kbd> | Cursor right | `send-keys -X cursor-right` |
| <kbd>n</kbd> | Search again | `send-keys -X search-again` |
| <kbd>o</kbd> | Other end | `send-keys -X other-end` |
| <kbd>q</kbd> | Cancel | `send-keys -X cancel` |
| <kbd>r</kbd> | Refresh from pane | `send-keys -X refresh-from-pane` |
| <kbd>t</kbd> | Jump to forward | `command-prompt -1 -p "(jump to forward)" { send-keys -X jump-to-forward -- "%%" }` |
| <kbd>v</kbd> | Start a selection ^!^ *(only when `@cfg_mode_keys=vi`)* | `send-keys -X begin-selection` |
| <kbd>v</kbd> | Rectangle toggle | `send-keys -X rectangle-toggle` |
| <kbd>w</kbd> | Next word | `send-keys -X next-word` |
| <kbd>y</kbd> | Copy the selection and stay in copy mode ^*^ *(only when `@cfg_copy_stays_in_mode=on`)* | `send-keys -X copy-pipe` |
| <kbd>y</kbd> | Copy the selection and leave copy mode ^*^ *(only when `@cfg_copy_stays_in_mode=off`)* | `send-keys -X copy-pipe-and-cancel` |
| <kbd>z</kbd> | Scroll middle | `send-keys -X scroll-middle` |
| <kbd>{</kbd> | Previous paragraph | `send-keys -X previous-paragraph` |
| <kbd>}</kbd> | Next paragraph | `send-keys -X next-paragraph` |

- <kbd>Enter</kbd> displaces the tmux default `send-keys -X copy-pipe-and-cancel`. Only bound when you ask to stay in copy mode after yanking. With the default @cfg_copy_stays_in_mode off, Enter is left exactly as tmux binds it.
- <kbd>MouseDragEnd1Pane</kbd> displaces the tmux default `send-keys -X copy-pipe-and-cancel`. Only bound when you ask to stay in copy mode after yanking. With the default off, this is left exactly as tmux binds it.
- <kbd>v</kbd> displaces the tmux default `send-keys -X rectangle-toggle`. The one copy-mode key this config deliberately changes, because v starting a selection is the muscle memory every vi user brings. tmux binds v to rectangle-toggle; that is still available on C-v, which this config leaves untouched.

## Copy mode (emacs keys)

Active **only** inside copy mode, and only while `@cfg_mode_keys` is `emacs`.

### Copy mode

| Key | Action | Runs |
| --- | --- | --- |
| <kbd>"M-{"</kbd> | Previous paragraph | `send-keys -X previous-paragraph` |
| <kbd>"M-}"</kbd> | Next paragraph | `send-keys -X next-paragraph` |
| <kbd>,</kbd> | Jump reverse | `send-keys -X jump-reverse` |
| <kbd>;</kbd> | Jump again | `send-keys -X jump-again` |
| <kbd>C-Down</kbd> | Scroll down | `send-keys -X scroll-down` |
| <kbd>C-M-b</kbd> | Previous matching bracket | `send-keys -X previous-matching-bracket` |
| <kbd>C-M-f</kbd> | Next matching bracket | `send-keys -X next-matching-bracket` |
| <kbd>C-Space</kbd> | Begin selection | `send-keys -X begin-selection` |
| <kbd>C-Up</kbd> | Scroll up | `send-keys -X scroll-up` |
| <kbd>C-[</kbd> | Cancel | `send-keys -X cancel` |
| <kbd>C-a</kbd> | Start of line | `send-keys -X start-of-line` |
| <kbd>C-b</kbd> | Cursor left | `send-keys -X cursor-left` |
| <kbd>C-c</kbd> | Cancel | `send-keys -X cancel` |
| <kbd>C-e</kbd> | End of line | `send-keys -X end-of-line` |
| <kbd>C-f</kbd> | Cursor right | `send-keys -X cursor-right` |
| <kbd>C-g</kbd> | Clear selection | `send-keys -X clear-selection` |
| <kbd>C-k</kbd> | Copy pipe end of line and cancel | `send-keys -X copy-pipe-end-of-line-and-cancel` |
| <kbd>C-l</kbd> | Recentre top bottom | `send-keys -X recentre-top-bottom` |
| <kbd>C-n</kbd> | Cursor down | `send-keys -X cursor-down` |
| <kbd>C-p</kbd> | Cursor up | `send-keys -X cursor-up` |
| <kbd>C-r</kbd> | Search backward incremental | `command-prompt -i -I "#{pane_search_string}" -T search -p "(search up)" { send-keys -X search-backward-incremental -- "%%" }` |
| <kbd>C-s</kbd> | Search forward incremental | `command-prompt -i -I "#{pane_search_string}" -T search -p "(search down)" { send-keys -X search-forward-incremental -- "%%" }` |
| <kbd>C-v</kbd> | Page down | `send-keys -X page-down` |
| <kbd>C-w</kbd> | Copy pipe and cancel | `send-keys -X copy-pipe-and-cancel` |
| <kbd>DoubleClick1Pane</kbd> | Copy pipe and cancel | `select-pane \; send-keys -X select-word \; run-shell -d 0.3 \; send-keys -X copy-pipe-and-cancel` |
| <kbd>Down</kbd> | Cursor down | `send-keys -X cursor-down` |
| <kbd>End</kbd> | End of line | `send-keys -X end-of-line` |
| <kbd>Escape</kbd> | Cancel | `send-keys -X cancel` |
| <kbd>F</kbd> | Jump backward | `command-prompt -1 -p "(jump backward)" { send-keys -X jump-backward -- "%%" }` |
| <kbd>Home</kbd> | Start of line | `send-keys -X start-of-line` |
| <kbd>Left</kbd> | Cursor left | `send-keys -X cursor-left` |
| <kbd>M-1</kbd> | Command prompt | `command-prompt -N -I 1 -p (repeat) { send-keys -N "%%" }` |
| <kbd>M-2</kbd> | Command prompt | `command-prompt -N -I 2 -p (repeat) { send-keys -N "%%" }` |
| <kbd>M-3</kbd> | Command prompt | `command-prompt -N -I 3 -p (repeat) { send-keys -N "%%" }` |
| <kbd>M-4</kbd> | Command prompt | `command-prompt -N -I 4 -p (repeat) { send-keys -N "%%" }` |
| <kbd>M-5</kbd> | Command prompt | `command-prompt -N -I 5 -p (repeat) { send-keys -N "%%" }` |
| <kbd>M-6</kbd> | Command prompt | `command-prompt -N -I 6 -p (repeat) { send-keys -N "%%" }` |
| <kbd>M-7</kbd> | Command prompt | `command-prompt -N -I 7 -p (repeat) { send-keys -N "%%" }` |
| <kbd>M-8</kbd> | Command prompt | `command-prompt -N -I 8 -p (repeat) { send-keys -N "%%" }` |
| <kbd>M-9</kbd> | Command prompt | `command-prompt -N -I 9 -p (repeat) { send-keys -N "%%" }` |
| <kbd>M-<</kbd> | History top | `send-keys -X history-top` |
| <kbd>M-></kbd> | History bottom | `send-keys -X history-bottom` |
| <kbd>M-Down</kbd> | Halfpage down | `send-keys -X halfpage-down` |
| <kbd>M-R</kbd> | Top line | `send-keys -X top-line` |
| <kbd>M-Up</kbd> | Halfpage up | `send-keys -X halfpage-up` |
| <kbd>M-b</kbd> | Previous word | `send-keys -X previous-word` |
| <kbd>M-f</kbd> | Next word end | `send-keys -X next-word-end` |
| <kbd>M-l</kbd> | Cursor centre horizontal | `send-keys -X cursor-centre-horizontal` |
| <kbd>M-m</kbd> | Back to indentation | `send-keys -X back-to-indentation` |
| <kbd>M-r</kbd> | Middle line | `send-keys -X middle-line` |
| <kbd>M-v</kbd> | Page up | `send-keys -X page-up` |
| <kbd>M-w</kbd> | Copy pipe and cancel | `send-keys -X copy-pipe-and-cancel` |
| <kbd>M-x</kbd> | Jump to mark | `send-keys -X jump-to-mark` |
| <kbd>MouseDown1Pane</kbd> | Select pane | `select-pane` |
| <kbd>MouseDrag1Pane</kbd> | Begin selection | `select-pane \; send-keys -X begin-selection` |
| <kbd>MouseDragEnd1Pane</kbd> | Copy pipe and cancel | `send-keys -X copy-pipe-and-cancel` |
| <kbd>N</kbd> | Search reverse | `send-keys -X search-reverse` |
| <kbd>NPage</kbd> | Page down | `send-keys -X page-down` |
| <kbd>P</kbd> | Toggle position | `send-keys -X toggle-position` |
| <kbd>PPage</kbd> | Page up | `send-keys -X page-up` |
| <kbd>R</kbd> | Rectangle toggle | `send-keys -X rectangle-toggle` |
| <kbd>Right</kbd> | Cursor right | `send-keys -X cursor-right` |
| <kbd>Space</kbd> | Page down | `send-keys -X page-down` |
| <kbd>T</kbd> | Jump to backward | `command-prompt -1 -p "(jump to backward)" { send-keys -X jump-to-backward -- "%%" }` |
| <kbd>TripleClick1Pane</kbd> | Copy pipe and cancel | `select-pane \; send-keys -X select-line \; run-shell -d 0.3 \; send-keys -X copy-pipe-and-cancel` |
| <kbd>Up</kbd> | Cursor up | `send-keys -X cursor-up` |
| <kbd>WheelDownPane</kbd> | Select pane | `select-pane \; send-keys -X -N 5 scroll-down` |
| <kbd>WheelUpPane</kbd> | Select pane | `select-pane \; send-keys -X -N 5 scroll-up` |
| <kbd>X</kbd> | Set mark | `send-keys -X set-mark` |
| <kbd>f</kbd> | Jump forward | `command-prompt -1 -p "(jump forward)" { send-keys -X jump-forward -- "%%" }` |
| <kbd>g</kbd> | Goto line | `command-prompt -p "(goto line)" { send-keys -X goto-line -- "%%" }` |
| <kbd>n</kbd> | Search again | `send-keys -X search-again` |
| <kbd>q</kbd> | Cancel | `send-keys -X cancel` |
| <kbd>r</kbd> | Refresh from pane | `send-keys -X refresh-from-pane` |
| <kbd>t</kbd> | Jump to forward | `command-prompt -1 -p "(jump to forward)" { send-keys -X jump-to-forward -- "%%" }` |

---

Generated from the key registry. Upstream tmux snapshot: 3.7b.
