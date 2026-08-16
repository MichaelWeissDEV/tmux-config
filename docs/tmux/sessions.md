# Sessions

A session is a collection of windows that outlives your terminal. Close the
terminal, reattach later, and everything is still running — that is the reason
tmux exists.

## What tmux does by default

| Key | Action |
| --- | --- |
| <kbd>prefix</kbd> <kbd>s</kbd> | choose a session from a list |
| <kbd>prefix</kbd> <kbd>d</kbd> | detach — leave everything running |
| <kbd>prefix</kbd> <kbd>$</kbd> | rename the session |
| <kbd>prefix</kbd> <kbd>(</kbd> / <kbd>)</kbd> | previous / next session |
| <kbd>prefix</kbd> <kbd>L</kbd> | back to the last session |
| <kbd>prefix</kbd> <kbd>D</kbd> | choose a client to detach |

From the shell:

```bash
tmux new -s work      # create a named session
tmux attach -t work   # reattach to it
tmux ls               # list sessions
```

## What tmux-config changes

**Nothing.** tmux's session keys are good, and this config binds none of its
own over them.

One behaviour is adjusted, in `10-general.conf`:

```tmux
set -g detach-on-destroy off
```

When the last session a client is showing is destroyed, tmux's default is to
detach you entirely. With this off, you are switched to another session
instead — you only get dropped to a shell when there is genuinely nothing left.

## Session persistence across a reboot

Not built in, and deliberately not on by default. The optional
[`tmux-resurrect` plugin](../plugins/available.md) saves and restores sessions,
windows, panes and layouts; `tmux-continuum` adds an automatic timer on top.

Both are off unless you turn them on, because both write to disk on a schedule
and one of them keeps a background process alive for the life of the server.

## Customising

```tmux
# in local.conf
bind C-s choose-tree -Zs        # a second key for the session chooser
bind N   command-prompt { new-session -s "%%" }
```

Anything you bind there shows up in the [Key Explorer](../keybindings/key-explorer.md)
under *Local and plugin keys*, so you can always see what you added.
