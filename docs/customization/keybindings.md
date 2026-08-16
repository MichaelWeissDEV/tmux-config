# Customising keybindings

## Adding your own

Put them in `local.conf`, which is sourced last and therefore wins over
everything:

```tmux
bind -N "Paste the top buffer" C-p paste-buffer -p
bind -N "New named session"    N   command-prompt { new-session -s "%%" }
bind -T copy-mode-vi -N "Yank to end of line" Y send-keys -X copy-end-of-line
```

The `-N "..."` note is worth the few extra characters: tmux itself shows it in
<kbd>prefix</kbd> <kbd>?</kbd>, and the [Key Explorer](../keybindings/key-explorer.md)
picks it up too.

## Changing one of this config's bindings

Rebind it in `local.conf`. Because that file is last, yours wins:

```tmux
bind h select-pane -L    # keep it
unbind M-h               # but drop the Alt resize row
```

The Key Explorer's Active view will show your version and label it as an
override of the shipped binding, so you can always see what you changed.

## Switching a feature off wholesale

Some binding groups have an option, which is cleaner than unbinding one by one:

```tmux
# in local-options.conf
set -g @cfg_vi_pane_keys    "off"   # drops prefix h/j/k/l, restores prefix l
set -g @cfg_alt_window_keys "off"   # drops the global Alt+1..9
```

## Contributing a binding to the project

Bindings that ship with tmux-config are not written directly into a `.conf`
file — they are registered in [`keys/custom/`](../keybindings/complete.md) and
the checks enforce the rules from there:

- a key tmux already uses must declare itself `tmux-enhanced` (same purpose,
  improved) or `tmux-override` (displaced, with a written justification)
- `scripts/check-key-conflicts` fails the build on a silent repurposing
- `scripts/check` fails if a binding exists on the server but not in the registry

So the first question for a new binding is always: *does tmux already use this
key, and for what?*

```bash
./scripts/check-key-conflicts
```

## The rule this config follows

tmux stays tmux. A default may be improved but never given a different job. The
whole config displaces exactly four tmux defaults, each recorded and each
explained in the [complete keymap](../keybindings/complete.md).

Your own config is yours — nothing above applies to your `local.conf`.
