# tmux-config

A tmux configuration that is **readable, portable, and fast** — and documented
well enough that you can change any part of it without reading the tmux manual
first.

:::{note}
**Part of the Arch Dotfiles Ecosystem**: Built for **Arch Linux** as part of [`arch-dotfiles`](https://arch-dotfiles.readthedocs.io/en/latest/),
this tmux configuration is engineered to be portable and beginner-friendly, with one single options
file to configure, six themes, and complete documentation so anyone can use it
out-of-the-box on Arch Linux or seamlessly across any Linux distribution, macOS,
WSL2, and MSYS2.
:::

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

```tmux
set -g @cfg_theme  "catppuccin-mocha"
set -g @cfg_prefix "C-b"
set -g @cfg_mouse  "on"
```

Change a value in `config/00-options.conf`, press <kbd>Ctrl+b</kbd> <kbd>r</kbd>, and it applies. You do not need to know
which tmux option, which key table, or which of the seven `pane-*-style`
settings implements it.

---

## Table of Contents

```{toctree}
:maxdepth: 1
:caption: Getting Started

getting-started/quick-start
getting-started/installation
```

```{toctree}
:maxdepth: 1
:caption: Configuration

configuration/index
configuration/local-overrides
```

```{toctree}
:maxdepth: 1
:caption: Keybindings

keybindings/quick
keybindings/mouse
keybindings/copy-mode
keybindings/key-explorer
keybindings/complete
```

```{toctree}
:maxdepth: 1
:caption: Concepts

tmux/sessions
tmux/windows
tmux/panes
tmux/layouts
tmux/buffers
tmux/status-line
```

```{toctree}
:maxdepth: 1
:caption: Integration

integration/neovim
integration/clipboard
integration/ssh
```

```{toctree}
:maxdepth: 1
:caption: Plugins

plugins/available
plugins/enabling
```

```{toctree}
:maxdepth: 1
:caption: Customization

customization/themes
customization/keybindings
customization/status-line
customization/recipes
```

```{toctree}
:maxdepth: 1
:caption: Reference

reference/options
reference/capabilities
reference/compatibility
reference/troubleshooting
reference/diagnostics
```

```{toctree}
:maxdepth: 1
:caption: Development

philosophy
architecture
publishing
```

```{toctree}
:caption: Related documentation
:hidden:

Arch Dotfiles (main hub) <https://arch-dotfiles.readthedocs.io/en/latest/>
Neovim (nvim-config) <https://nvim-config.readthedocs.io/en/latest/>
Ghostty (ghostty-config) <https://ghostty-config.readthedocs.io/en/latest/>
Kitty (kitty-config) <https://kitty-config.readthedocs.io/en/latest/>
Vim (vim-config) <https://vim-config.readthedocs.io/en/latest/>
```

---

## What you get

- ⚙ **One file to configure**: Every setting is a named `@cfg_*` option with its default, its accepted values, and the reason it is set that way written next to it. ([Configuration](configuration/index.md))
- 🎨 **Six themes, ten variables**: Themes define ten colours and nothing else. Writing your own is a twenty-line file that touches no layout. ([Theming](customization/themes.md))
- 📋 **Clipboard that works everywhere**: Detects macOS, Wayland, X11, WSL, and Cygwin, plus OSC 52 so copy works over SSH. ([Clipboard](configuration/index.md))
- 🛡 **Degrades instead of breaking**: True colour, Unicode glyphs and clipboard route are detected, not assumed. No UTF-8 locale? ASCII separators, automatically. ([Capabilities](reference/capabilities.md))
- 📦 **Plugins vendored, not fetched**: Pinned inside the repo via `git subtree`. No plugin manager, no download at startup, works offline. ([Plugins](plugins/available.md))
- ⚡ **No forks in the hot path**: Conditionals resolve at parse time. The status bar runs no subprocesses. Plugins are off by default. ([Architecture](architecture.md))

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

```{warning}
tmux does **not** run on native Windows — not in PowerShell, not in
`cmd.exe`, not in Windows Terminal by itself. It needs WSL2, MSYS2, or
Cygwin. This config supports all three, but the requirement is real and no
configuration can remove it. See the [platform matrix](getting-started/installation.md).
```

---

## Connected Dotfiles Ecosystem

This tmux setup integrates seamlessly with:

- **[Arch Dotfiles Hub (`arch-dotfiles`)](https://arch-dotfiles.readthedocs.io/en/latest/)**: Central Arch Linux dotfiles hub and Hyprland desktop (managed via `adot update`, `adot update tmux`, `adot status`).
- **[nvim-config](https://nvim-config.readthedocs.io/en/latest/)**: Seamless navigation between tmux panes and Neovim splits via `Ctrl+h/j/k/l`.
- **[ghostty-config](https://ghostty-config.readthedocs.io/en/latest/)** & **[kitty-config](https://kitty-config.readthedocs.io/en/latest/)**: Terminal emulators with matching Catppuccin Mocha colors and truecolor support.
- **[vim-config](https://vim-config.readthedocs.io/en/latest/)**: Synchronized navigation and keybindings.
