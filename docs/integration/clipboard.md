# Clipboard

Copying in tmux should put text on **your** clipboard — the one your editor and
browser use — whether tmux is running locally or on a machine three hops away.

There are two independent mechanisms, and they are complementary rather than
redundant.

## `copy-command` — the local helper

tmux pipes the selection to a program on the machine tmux itself runs on:

| Platform | Tool |
| --- | --- |
| macOS | `pbcopy` |
| Wayland | `wl-copy` |
| X11 | `xclip` |
| WSL / MSYS2 | `clip.exe` |

`capabilities/detect.conf` resolves which one exists at startup, and
`40-clipboard.conf` points `copy-command` at it. Nothing is probed at copy time.

Over SSH this puts text on the **remote** clipboard, which is almost never what
you want — which is why the second mechanism exists.

```tmux
set -g @cfg_system_clipboard "on"
```

A headless box with no clipboard tool is a valid outcome, not a failure:
`copy-command` is left alone and copying still works through OSC 52 and tmux's
own [buffers](../tmux/buffers.md).

## OSC 52 — clipboard across SSH

tmux emits an escape sequence asking your **terminal emulator** to set the
clipboard. Because the terminal is on your local machine, this crosses SSH.

```tmux
set -g @cfg_osc52 "on"      # on | external | off
```

- `on` — set tmux's buffer *and* forward outward
- `external` — only forward outward, never set tmux's own buffer
- `off` — disabled

Supported by Ghostty, kitty, WezTerm, Alacritty, foot, iTerm2, Windows Terminal
and xterm (with `allowWindowOps`). Apple's Terminal.app does **not** support it;
`terminals/corrections.conf` flags that case.

## Programs inside panes

```tmux
set -g allow-passthrough on
```

This lets a program in a pane — Neovim's OSC 52 provider, for instance — reach
your clipboard *through* tmux rather than being swallowed by it.

## Pasting

Into tmux, from your OS clipboard: use your terminal's own shortcut
(<kbd>Cmd</kbd>+<kbd>V</kbd>, <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>V</kbd>).
That path never goes through tmux at all.

From tmux's own buffers: <kbd>prefix</kbd> <kbd>]</kbd>. See
[buffers](../tmux/buffers.md).

## When it does not work

`./scripts/doctor` reports which helper was detected, whether OSC 52 is on, and
what `copy-command` ended up as. That is usually enough to see which of the two
paths is failing. More in
[troubleshooting](../reference/troubleshooting.md).
