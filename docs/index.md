# tmux-config

A tmux configuration that is **readable, portable, and fast** — and documented
well enough that you can change any part of it without reading the tmux manual
first.

It runs on macOS, Linux, WSL2, and MSYS2/Cygwin from the same files, with no
plugins required.

---

## Why another tmux config

Most shared tmux configs fall into one of two traps: a 400-line file where
every setting is entangled with every other, or a plugin stack where a dozen
repositories decide your behaviour and any of them can break on update.

This one takes a different position:

**Everything you would normally want to change lives in one file, as a named
option with a documented default.**

```tmux title="config/00-options.conf"
set -g @cfg_theme  "catppuccin-mocha"
set -g @cfg_prefix "C-b"
set -g @cfg_mouse  "on"
```

Change a value, press ++ctrl+b++ ++r++, and it applies. You do not need to know
which tmux option, which key table, or which of the seven `pane-*-style`
settings implements it.

---

## What you get

<div class="grid cards" markdown>

-   :material-tune: **One file to configure**

    Every setting is a named `@cfg_*` option with its default, its accepted
    values, and the reason it is set that way written next to it.

    [:octicons-arrow-right-24: Configuration](configuration/index.md)

-   :material-palette: **Six themes, ten variables**

    Themes define ten colours and nothing else. Writing your own is a
    twenty-line file that touches no layout.

    [:octicons-arrow-right-24: Theming](customization/themes.md)

-   :material-content-copy: **Clipboard that works everywhere**

    Detects macOS, Wayland, X11, WSL, and Cygwin, plus OSC 52 so copy works
    over SSH.

    [:octicons-arrow-right-24: Clipboard](configuration/index.md#copy-mode-clipboard)

-   :material-shield-check: **Degrades instead of breaking**

    True colour, Unicode glyphs and clipboard route are detected, not assumed.
    No UTF-8 locale? ASCII separators, automatically.

    [:octicons-arrow-right-24: Capabilities](reference/capabilities.md)

-   :material-package-variant-closed: **Plugins vendored, not fetched**

    Pinned inside the repo via `git subtree`. No plugin manager, no download
    at startup, works offline.

    [:octicons-arrow-right-24: Plugins](plugins/available.md)

-   :material-flash: **No forks in the hot path**

    Conditionals resolve at parse time. The status bar runs no subprocesses.
    Plugins are off by default.

    [:octicons-arrow-right-24: Architecture](architecture.md)

</div>

---

## Quick start

```bash
git clone https://github.com/MichaelWeissDEV/tmux-config.git ~/.config/tmux
cd ~/.config/tmux && ./install.sh
```

The installer backs up anything already there, checks your tmux version, and
verifies the config loads before it finishes. Then:

```bash
tmux
```

Full instructions, including the Windows situation, are in
[Installation](getting-started/installation.md).

!!! warning "Windows users, read this first"
    tmux does **not** run on native Windows — not in PowerShell, not in
    `cmd.exe`, not in Windows Terminal by itself. It needs WSL2, MSYS2, or
    Cygwin. This config supports all three, but the requirement is real and no
    configuration can remove it. See the
    [platform matrix](getting-started/installation.md#platform-support).

---

## The three files that matter

| File | What it is for |
| --- | --- |
| [`config/00-options.conf`](configuration/index.md) | **Change settings here.** Every tunable, with documented defaults. |
| [`local.conf`](configuration/index.md#local-overrides) | **Add your own things here.** Gitignored, loaded last, survives `git pull`. Start from `local.conf.example`, which ships every [recipe](customization/recipes.md) commented out. |
| [`tmux.conf`](architecture.md#file-layout) | The loader. You should not need to edit it. |

Everything else is a module that reads your options and applies them.

---

## Requirements

- **tmux 3.3 or newer.** Checked at startup with a clear message if not.
  ([Why 3.3?](getting-started/installation.md#older-tmux))
- A UTF-8 locale, for the status bar separators.
  ([What happens without one](reference/troubleshooting.md#status-bar-shows-underscores))
- That is all. No Nerd Font, no Python, no plugin manager.

---

## Where to go next

- Never used tmux before? → [Installation](getting-started/installation.md), then
  [Keybindings](keybindings/quick.md)
- Want to change how it looks? → [Theming](customization/themes.md)
- Want to change how it behaves? → [Configuration](configuration/index.md)
- Want ready-made additions to paste in? → [Recipes](customization/recipes.md)
- Something is broken? → [Troubleshooting](reference/troubleshooting.md)
- On a weird terminal, or over SSH? → [Capabilities](reference/capabilities.md)
- Using Neovim? → [Neovim](integration/neovim.md)
- Curious why it is built this way? → [Philosophy](philosophy.md) and
  [Architecture](architecture.md)
- Debugging? → [Diagnostics](reference/diagnostics.md)
