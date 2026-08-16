# Quick reference

The keys worth knowing first. This shortlist is chosen by hand — the
[complete keymap](complete.md) has all 300-odd — but every key on it is checked
against the registry by CI, so nothing here can quietly stop existing.

It is the same list the [Key Explorer](key-explorer.md) opens with. Press
<kbd>prefix</kbd> <kbd>H</kbd> to get it inside tmux, where it is searchable.

Throughout, **`prefix`** means <kbd>Ctrl</kbd>+<kbd>b</kbd> unless you changed
`@cfg_prefix`.


## General

| Key | Action |
| --- | --- |
| <kbd>prefix ?</kbd> | List key bindings |
| <kbd>prefix :</kbd> | Prompt for a command |
| <kbd>prefix g</kbd> | Toggle a floating scratch terminal ^*^ |
| <kbd>prefix b</kbd> | Toggle the status bar ^*^ |
| <kbd>prefix C-k</kbd> | Clear the screen and the scrollback ^*^ |

## Sessions

| Key | Action |
| --- | --- |
| <kbd>prefix s</kbd> | Choose a session from a list |
| <kbd>prefix d</kbd> | Detach the current client |
| <kbd>prefix $</kbd> | Rename current session |
| <kbd>prefix (</kbd> | Switch to previous client |
| <kbd>prefix )</kbd> | Switch to next client |

## Windows

| Key | Action |
| --- | --- |
| <kbd>prefix c</kbd> | New window in the current directory ^+^ |
| <kbd>prefix n</kbd> | Select the next window |
| <kbd>prefix p</kbd> | Select the previous window |
| <kbd>prefix Tab</kbd> | Jump to the last used window ^*^ |
| <kbd>prefix ,</kbd> | Rename current window |
| <kbd>prefix &</kbd> | Kill current window |
| <kbd>prefix w</kbd> | Choose a window from a list |
| <kbd>prefix C-h</kbd> | Previous window ^*^ |
| <kbd>prefix C-l</kbd> | Next window ^*^ |
| <kbd>M-1</kbd> | Go to window 1 ^*^ |

## Panes

| Key | Action |
| --- | --- |
| <kbd>prefix \|</kbd> | Split side by side ^*^ |
| <kbd>prefix _</kbd> | Split stacked ^*^ |
| <kbd>prefix h</kbd> | Select the pane to the left ^*^ |
| <kbd>prefix j</kbd> | Select the pane below ^*^ |
| <kbd>prefix k</kbd> | Select the pane above ^*^ |
| <kbd>prefix l</kbd> | Select the pane to the right ^!^ |
| <kbd>prefix z</kbd> | Zoom the active pane |
| <kbd>prefix x</kbd> | Kill the active pane |
| <kbd>prefix !</kbd> | Break the pane into a new window ^+^ |
| <kbd>prefix M-h</kbd> | Resize the pane left ^*^ |
| <kbd>prefix M-l</kbd> | Resize the pane right ^*^ |
| <kbd>prefix ;</kbd> | Move to the previously active pane |
| <kbd>prefix o</kbd> | Select the next pane |

## Layouts

| Key | Action |
| --- | --- |
| <kbd>prefix Space</kbd> | Select next layout |
| <kbd>prefix M-1</kbd> | Set the even-horizontal layout |
| <kbd>prefix M-5</kbd> | Select the tiled layout |

## Copy mode

| Key | Action |
| --- | --- |
| <kbd>prefix [</kbd> | Enter copy mode |
| <kbd>prefix C-f</kbd> | Search the scrollback ^*^ |
| <kbd>v</kbd> | Rectangle toggle |
| <kbd>C-v</kbd> | Rectangle toggle |
| <kbd>y</kbd> | Copy the selection and leave copy mode ^*^ |
| <kbd>q</kbd> | Cancel |

## Buffers

| Key | Action |
| --- | --- |
| <kbd>prefix ]</kbd> | Paste the most recent paste buffer |
| <kbd>prefix =</kbd> | Choose a paste buffer from a list |
| <kbd>prefix #</kbd> | List all paste buffers |
| <kbd>prefix -</kbd> | Delete the most recent paste buffer |

## Configuration

| Key | Action |
| --- | --- |
| <kbd>prefix H</kbd> | Open the Key Explorer ^*^ |
| <kbd>prefix R</kbd> | Reload the tmux config ^*^ |

---

^+^ improved tmux default  ^!^ displaced tmux default  ^*^ added by tmux-config

Copy-mode keys are shown without the prefix: press <kbd>prefix</kbd>
<kbd>[</kbd> to enter copy mode first.
