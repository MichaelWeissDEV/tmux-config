# Mouse

The mouse is on by default:

```tmux
set -g @cfg_mouse "on"
```

Turn it off to get your terminal's own selection and scrolling back.

## What the mouse does

| Action | Result |
| --- | --- |
| click a pane | focus it |
| click a window in the status bar | select it |
| drag a pane border | resize |
| scroll in a pane | enter copy mode and scroll |
| drag in a pane | select text, and copy it on release |
| right-click a pane | tmux's pane context menu |
| right-click the status bar | tmux's window context menu |
| middle-click | paste the most recent buffer |

All of these are tmux's own, and all of them are in the
[complete keymap](complete.md) — the mouse bindings live in the `root` table
and in the two copy-mode tables, and the Key Explorer lists them like any other
key.

## What tmux-config changes

Two enhancements inside copy mode, both keeping tmux's purpose:

- **the wheel scrolls three lines**, not five. Five is a lot per notch and makes
  a scrollback feel like it is skipping.
- **a click without a drag clears the selection.** Without this, a stray click
  leaves a highlighted region on screen that nothing obvious removes.

Nothing else about the mouse is touched.

## Selecting text when the mouse is grabbed

With `mouse on`, tmux takes the mouse before your terminal sees it, so your
terminal's own click-drag-to-select no longer works. Two ways around it:

- hold <kbd>Shift</kbd> while dragging — most terminals bypass the application
  and do their own selection
- select with copy mode instead, which also copies to your system clipboard

## Copying with the mouse

Drag to select, release to copy. The text goes through the same `copy-command`
path as [copy mode](copy-mode.md), which means it lands on your system
clipboard, not only in tmux's buffer.

Over SSH that still works, because
[OSC 52](../integration/clipboard.md) forwards the copy to your local terminal.
