# Copy mode

Copy mode is how you scroll back, search your output, and select text with the
keyboard. Enter it with <kbd>prefix</kbd> <kbd>[</kbd>, or by scrolling up with
the mouse. Leave it with <kbd>q</kbd>.

!!! note "Copy mode is not "tmux vi mode""
    Setting `@cfg_mode_keys` to `vi` changes the keys **inside copy mode and
    nowhere else**. It has no effect on Neovim, on your shell's line editor, or
    on any program running in a pane. This is the single most common
    misunderstanding about tmux configuration.

## What tmux does by default

tmux ships two complete key tables and uses one of them:

| Table | Used when | Size |
| --- | --- | --- |
| `copy-mode-vi` | `mode-keys` is `vi` | 89 keys |
| `copy-mode` | `mode-keys` is `emacs` | 75 keys |

Both are fully documented in the [complete keymap](complete.md). The vi table
is already a faithful vi: `0` and `$` for line ends, `H`/`M`/`L` for the top,
middle and bottom of the screen, `C-u`/`C-d` for half pages, `w`/`b` for words,
`/` and `?` to search, `n`/`N` to repeat.

## What tmux-config changes

`@cfg_mode_keys` defaults to `vi`, and then exactly **two** keys differ from
stock tmux.

### `v` starts a selection

tmux binds <kbd>v</kbd> to `rectangle-toggle`. Every vi user arrives expecting
`v` to begin a visual selection, and copy mode is where that reflex is
strongest — so this config rebinds it.

Rectangle select is not lost. It keeps its other and more commonly used key,
<kbd>Ctrl</kbd>+<kbd>v</kbd>, which this config does not touch.

This is one of only four tmux defaults the whole config displaces, and like the
others it is recorded as such: the [Key Explorer](key-explorer.md) will tell you
what `v` displaced and where that behaviour went.

### `y` copies

tmux leaves <kbd>y</kbd> unbound and uses <kbd>Enter</kbd> to copy. This config
adds `y` alongside it; `Enter` keeps working exactly as tmux binds it.

So the vi triple works as you expect, and nothing else moved:

| Key | Action |
| --- | --- |
| <kbd>v</kbd> | start a selection |
| <kbd>Ctrl</kbd>+<kbd>v</kbd> | toggle rectangle/block selection |
| <kbd>y</kbd> | copy and leave copy mode |

### Two small enhancements

Same purpose as tmux's, improved:

- the mouse wheel scrolls three lines instead of five, closer to a normal terminal
- a click without a drag clears a stale selection instead of leaving it highlighted

## Staying in copy mode after yanking

By default, copying exits copy mode. To keep the selection and stay put:

```tmux
set -g @cfg_copy_stays_in_mode "on"
```

That switches <kbd>y</kbd>, <kbd>Enter</kbd> and the mouse drag to `copy-pipe`
instead of `copy-pipe-and-cancel`. With it off — the default — `Enter` and the
mouse drag are left exactly as tmux binds them.

## Searching your scrollback

<kbd>prefix</kbd> <kbd>Ctrl</kbd>+<kbd>f</kbd> enters copy mode and starts a
backward search in one step.

It is deliberately **not** on <kbd>prefix</kbd> <kbd>/</kbd>: tmux uses that for
describe-key — press it, then press any key, and tmux tells you what that key
does. That is one of tmux's few built-in help affordances and this config will
not take it.

<kbd>prefix</kbd> <kbd>Ctrl</kbd>+<kbd>p</kbd> jumps to the previous shell
prompt, if your shell emits OSC 133 prompt markers (zsh with a modern prompt,
fish, and starship all do).

## Where the copied text goes

`copy-pipe` sends the selection through tmux's `copy-command`, which
[clipboard integration](../integration/clipboard.md) points at the right tool
for your platform. That indirection is why no `pbcopy` or `xclip` is hardcoded
in any keybinding.
