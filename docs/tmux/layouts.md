# Layouts

A layout is an arrangement of the panes in a window. tmux has five built in and
can rearrange your panes into any of them instantly.

## What tmux does by default

| Key | Layout |
| --- | --- |
| <kbd>prefix</kbd> <kbd>Space</kbd> | cycle to the next layout |
| <kbd>prefix</kbd> <kbd>M-1</kbd> | even-horizontal — panes side by side |
| <kbd>prefix</kbd> <kbd>M-2</kbd> | even-vertical — panes stacked |
| <kbd>prefix</kbd> <kbd>M-3</kbd> | main-horizontal — one large pane on top |
| <kbd>prefix</kbd> <kbd>M-4</kbd> | main-vertical — one large pane on the left |
| <kbd>prefix</kbd> <kbd>M-5</kbd> | tiled — an even grid |
| <kbd>prefix</kbd> <kbd>M-6</kbd> / <kbd>M-7</kbd> | the mirrored main layouts |
| <kbd>prefix</kbd> <kbd>E</kbd> | spread panes out evenly |

Note these are **prefix** Alt-number. The prefix-less
<kbd>Alt</kbd>+<kbd>1</kbd>…<kbd>9</kbd> that select windows are a different
table and do not collide.

## What tmux-config changes

**Nothing.** tmux's layout keys are complete and this config adds none.

Earlier versions bound <kbd>prefix</kbd> <kbd>=</kbd> and <kbd>prefix</kbd>
<kbd>+</kbd> to even-horizontal and even-vertical. That was a mistake worth
naming: tmux uses <kbd>prefix</kbd> <kbd>=</kbd> for `choose-buffer`, so the
config was taking a default and giving it an unrelated job — the exact thing
[rule 4](../philosophy.md) forbids. Both bindings are gone, and the keys are
tmux's again.

## Saving a layout

Layouts are strings, and you can capture and restore them:

```bash
tmux display -p '#{window_layout}'      # copy this
tmux select-layout '<the string>'       # restore it later
```

To keep layouts across a reboot, use the optional
[`tmux-resurrect` plugin](../plugins/available.md).
