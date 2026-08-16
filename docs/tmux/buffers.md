# Buffers

tmux keeps its own clipboard — a stack of paste buffers, independent of your
system clipboard. Anything you copy in [copy mode](../keybindings/copy-mode.md)
lands here as well as on your OS clipboard.

## What tmux does by default

| Key | Action |
| --- | --- |
| <kbd>prefix</kbd> <kbd>]</kbd> | paste the most recent buffer |
| <kbd>prefix</kbd> <kbd>=</kbd> | choose a buffer to paste from |
| <kbd>prefix</kbd> <kbd>#</kbd> | list the buffers |
| <kbd>prefix</kbd> <kbd>-</kbd> | delete the most recent buffer |

From the shell:

```bash
tmux show-buffer            # print the top buffer
tmux save-buffer out.txt    # write it to a file
tmux load-buffer in.txt     # push a file onto the stack
```

## What tmux-config changes

**Nothing.** These four keys are tmux's and stay tmux's.

That is a deliberate reversal. An earlier version of this config bound
<kbd>prefix</kbd> <kbd>p</kbd> to paste and <kbd>prefix</kbd> <kbd>P</kbd> to
the buffer chooser. But <kbd>prefix</kbd> <kbd>p</kbd> is tmux's
`previous-window` — a navigation key most people press far more often than they
paste. Taking it was a repurposing, not an improvement, so it is gone.

If you want paste on a letter key, put it in your `local.conf`; it is your
config and nothing here will fight you:

```tmux
bind C-p paste-buffer -p
```

## Buffers versus your system clipboard

Two different things, and knowing which is which saves a lot of confusion:

| | tmux buffers | system clipboard |
| --- | --- | --- |
| Paste with | <kbd>prefix</kbd> <kbd>]</kbd> | your terminal's own shortcut |
| Survives tmux exit | no | yes |
| Works over SSH | yes, on the remote | yes, via OSC 52 |

This config wires copy mode to feed **both**, so a yank puts text where you
expect it either way. See [clipboard](../integration/clipboard.md).
