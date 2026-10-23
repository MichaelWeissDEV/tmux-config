# Neovim

Neovim compatibility is a hard requirement of this project, not a feature. The
default config is built so that **Neovim receives your keystrokes unchanged**.

---

## What the default does for you

| Setting | Value | Why Neovim cares |
| --- | --- | --- |
| `escape-time` | `10` | tmux defaults to **500 ms**. That delay is the single most common reason Neovim feels sluggish leaving insert mode. |
| `focus-events` | `on` | Needed for `:set autoread` and the `FocusGained` / `FocusLost` autocommands to fire. |
| `terminal-features …:usstyle` | on | Undercurls, so LSP diagnostics underline correctly. |
| `terminal-features …:cstyle` | on | Cursor shape changes between insert and normal mode. |
| `default-terminal` | `tmux-256color` | A `screen*`/`tmux*` entry, so Neovim negotiates correctly instead of assuming it talks to the outer terminal. |

Verify on your machine:

```bash
tmux show -sv escape-time    # expect 10
tmux show -gv focus-events   # expect on
```

---

## What the default does NOT do

**No Ctrl-based key is bound globally.** <kbd>Ctrl</kbd>+<kbd>h/j/k/l</kbd>,
<kbd>Ctrl</kbd>+<kbd>w</kbd>, <kbd>Ctrl</kbd>+<kbd>v</kbd>,
<kbd>Ctrl</kbd>+<kbd>o</kbd> and <kbd>Escape</kbd> all reach Neovim untouched.

This is enforced, not just intended:

```bash
./scripts/check      # fails if any of those appear in the root key table
./tests/run          # same assertion, across environments
```

Pane navigation therefore uses the prefix:

```
prefix h/j/k/l
```

which cannot collide with anything running inside a pane.

```{note} The Alt+number exception
<kbd>Alt</kbd>+<kbd>1</kbd>…<kbd>9</kbd> *is* bound globally by default.
It does not affect Neovim's normal keymaps, but it is still interception —
see [Philosophy](../philosophy.md#the-one-exception-to-rule-3). Turn it off
with `@cfg_alt_window_keys "off"`.
```
---

## Copy mode does not touch Neovim

`@cfg_mode_keys "vi"` gives you `v` / `y` / <kbd>Ctrl</kbd>+<kbd>v</kbd> inside
**tmux's copy mode only**. Copy mode is a separate tmux mode with its own key
table; it has no effect on Neovim, your shell, or anything running in a pane.

---

## Optional: shared navigation

If you want <kbd>Ctrl</kbd>+<kbd>h/j/k/l</kbd> to move between Neovim splits
*and* tmux panes with the same keys:

```tmux title="config/00-options.conf"
set -g @cfg_plugins          "on"
set -g @cfg_plugin_navigator "on"
```

Plus the Neovim half:

```lua
{ "christoomey/vim-tmux-navigator", lazy = false }
```

```{warning} This deliberately breaks the input-safety rule
The plugin binds Ctrl-hjkl in the root table and forwards them when the
pane runs vim/nvim. `scripts/check` will report the interception — that is
correct behaviour from the checker, not a bug.

It is off by default for exactly this reason. Enable it only if you want
that tradeoff.
```
The plugin must be vendored first — see [Plugins](../plugins/available.md).

---

## Extended keys

```tmux
set -g @cfg_extended_keys "auto"
```

CSI-u encoding lets applications distinguish keys the legacy encoding cannot,
such as <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+letter.

The default is `auto` and **not** `on`, on purpose: forcing the protocol pushes
an encoding through to Neovim that the *outer* terminal may not round-trip, and
the failure mode is keys silently doing nothing — worse than not having the
feature. On `auto`, tmux enables it only for terminals that advertise support.

---

## Troubleshooting

**Insert mode exit feels slow**
:   `escape-time`. It is a *server* option, so `tmux kill-server` is needed —
    a config reload is not enough.

**Colours differ inside tmux**
:   See [Troubleshooting → Colours](../reference/troubleshooting.md#colours-are-wrong-or-washed-out).

**Undercurls do not render**
:   Your terminal may not support them. Check `tmux info | grep usstyle`.

**`autoread` does not fire**
:   Confirm `tmux show -gv focus-events` is `on`.
