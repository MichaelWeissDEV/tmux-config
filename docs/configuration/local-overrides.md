# Local overrides

Two files, neither tracked by git, both surviving a `git pull`. Which one you
want depends on *what* you are changing — and getting it wrong is the single
most common way a tmux config appears to ignore you.

| File | For | Sourced |
| --- | --- | --- |
| `local-options.conf` | changing an `@cfg_*` value | **before** the modules |
| `local.conf` | raw tmux commands, your own bindings | **after** everything |

## Why there are two

tmux evaluates `%if` at **parse time** — when a file is read, before any line of
it has run. The modules in `config/` branch on your settings that way, because
it costs nothing:

```tmux
%if "#{==:#{@cfg_dim_inactive},on}"
  setw -g window-style "fg=colour247"
%endif
```

So by the time `local.conf` is sourced at the very end, `50-theme.conf` has long
since been parsed and has already decided. Setting `@cfg_theme` there changes
the variable and nothing else — the theme does not move, and it looks like the
config ignored you.

`local-options.conf` is sourced immediately after the shipped defaults and
before any module, so a value you set there is the value every `%if` sees.

## The full load order

```text
config/00-options.conf     shipped defaults
local-options.conf         your @cfg_* values
capabilities/, config/     the modules, branching on the above
config/70-plugins.conf     plugin adapters
local.conf                 your raw tmux commands — last word
```

## `local-options.conf`

Only `set -g @cfg_*` lines. Copy the ones you want out of
[`config/00-options.conf`](../reference/options.md):

```tmux
set -g @cfg_theme           "nord"
set -g @cfg_prefix          "C-a"
set -g @cfg_alt_window_keys "off"
set -g @cfg_status_style    "minimal"
```

## `local.conf`

Anything else. Your own bindings, tmux options this config does not wrap, hooks:

```tmux
bind C-p paste-buffer -p
bind N   command-prompt { new-session -s "%%" }
set -g   pane-border-format " #{pane_index} "
```

Because it is sourced last, it wins over everything — including this config.
Start from `local.conf.example`, which ships with the repository:

```bash
cp ~/.config/tmux/local.conf.example ~/.config/tmux/local.conf
```

## Seeing what you changed

Anything you bind here shows up in the
[Key Explorer](../keybindings/key-explorer.md) under **Local and plugin keys**,
and a key where you overrode one of this config's own bindings is labelled as
an override rather than as an unknown key. Press <kbd>prefix</kbd> <kbd>H</kbd>
and switch to the Active view with <kbd>a</kbd>.

`./scripts/doctor` also reports both files and whether they loaded.
