# SSH

tmux over SSH mostly just works. The parts that do not are worth knowing in
advance, because each has a specific cause.

## Detection

`capabilities/detect.conf` sets `@cap_ssh` when `SSH_CONNECTION` or
`SSH_TTY` is present. Nothing dramatic keys off it — it exists so that
`./scripts/doctor` can explain behaviour that only shows up remotely.

## Clipboard

The important one. A copy inside a remote tmux goes to the **remote** machine's
clipboard by default, which helps nobody.

[OSC 52](clipboard.md) is what fixes it: tmux asks your *local* terminal to set
the clipboard, and the escape sequence rides the SSH connection like any other
output. It is on by default.

If your terminal does not support OSC 52, there is no way for a remote tmux to
reach your local clipboard, and no configuration will change that.

## Nested tmux

A tmux on your laptop and a tmux on the server both want the prefix. Two
workable answers:

- **do not nest.** `ssh` from inside a window of your local tmux and run no
  second server. Usually the right answer.
- **send the prefix through.** Press <kbd>prefix</kbd> twice — the second one is
  passed to the inner tmux. This config binds that automatically when you
  change `@cfg_prefix`, and `@cfg_keep_default_prefix` keeps
  <kbd>Ctrl</kbd>+<kbd>b</kbd> working as a second prefix.

## Colours

Colour is decided by what the **remote** tmux can detect, and `COLORTERM` is
usually not forwarded by `ssh`. So a truecolor terminal can end up looking
washed out remotely.

```tmux
# in local-options.conf on the remote machine
set -g @cfg_truecolor "on"
```

Forcing it is the documented use of that override — see
[capabilities](../reference/capabilities.md).

## `TERM`

If the remote machine has no terminfo entry for your terminal, tmux falls back
and things like italics or cursor shapes stop working. Either install the entry
on the remote (`ncurses-term` on most distributions) or let tmux use a common
one. The config never sets a `TERM` your system cannot resolve —
`./scripts/doctor` reports the effective value.

## Latency

```tmux
set -g @cfg_escape_time "10"
```

Low, because tmux's 500 ms default is what makes Neovim feel laggy leaving
insert mode. 10 ms is responsive and still safe over a slow link; raise it if
you see stray characters on a very high-latency connection.
