# Compatibility

What this project actually promises, per environment. No claim of "works
everywhere" — the honest version is:

> **Safe fallback everywhere we support; enhanced capabilities where detected.**

Status meanings:

| Status | Meaning |
| --- | --- |
| :material-check: **Supported** | Tested in CI or by the maintainer. Bugs are fixed. |
| :material-check-outline: **Best effort** | Expected to work, not covered by CI. Reports welcome. |
| :material-help: **Unknown** | Nobody has reported either way. |
| :material-close: **Unsupported** | Known not to work, and not fixable here. |

---

## Operating systems

| OS | Status | Covered by | Notes |
| --- | :---: | --- | --- |
| Linux (Debian/Ubuntu) | :material-check: | CI container | |
| Linux (Fedora) | :material-check: | CI container | |
| Linux (Arch) | :material-check: | CI container | |
| Linux (Alpine/musl) | :material-check: | CI container | busybox `sh` — the scripts stay POSIX for this |
| macOS | :material-check: | CI runner | `tmux-256color` terminfo often missing; handled |
| WSL2 | :material-check-outline: | manual | Clipboard via `clip.exe` |
| FreeBSD / OpenBSD / NetBSD | :material-check-outline: | manual | Detected as `bsd`; no CI runner available |
| Solaris / illumos | :material-help: | — | Detection has a branch for it, untested |
| Cygwin / MSYS2 | :material-check-outline: | manual | Clipboard via `/dev/clipboard` |
| **Native Windows** | :material-close: | — | **tmux has no native Windows port.** Use WSL2. |

!!! info "Why native Windows cannot work"
    tmux needs PTYs and Unix domain sockets, neither of which native Windows
    provides. This is a property of tmux itself; no configuration can change
    it. WSL2, MSYS2 and Cygwin are all supported.

---

## tmux versions

| Version | Status | Notes |
| --- | :---: | --- |
| 3.3 – current | :material-check: | Minimum supported. Checked at startup. |
| 3.2 | :material-close: | Missing `allow-passthrough`; OSC 52 from inside panes breaks |
| ≤ 3.1 | :material-close: | Missing `terminal-features`, `copy-command`, popups |

Features and the version that introduced them:

| Feature | Since | Used for |
| --- | --- | --- |
| `terminal-features` | 3.2 | True colour and undercurl declarations |
| `copy-command` | 3.2 | One clipboard binding for all platforms |
| `display-popup` | 3.2 | Scratch terminal, all popup recipes |
| `pane-border-lines` | 3.2 | Border styles |
| `allow-passthrough` | 3.3 | OSC 52 from programs inside panes |

The version gate runs once and prints a clear message rather than failing
obscurely. See [Installation → Older tmux](../getting-started/installation.md#older-tmux).

---

## Terminals

Detection is automatic. This table is about what you *get*, not what you must
configure.

| Terminal | True colour | OSC 52 clipboard | Notes |
| --- | :---: | :---: | --- |
| Ghostty | :material-check: | :material-check: | |
| kitty | :material-check: | :material-check: | |
| WezTerm | :material-check: | :material-check: | |
| Alacritty | :material-check: | :material-check: | |
| foot | :material-check: | :material-check: | |
| iTerm2 | :material-check: | :material-check: | Enable in Preferences → General → Selection |
| Windows Terminal | :material-check: | :material-check: | |
| GNOME Terminal / VTE | :material-check: | :material-close: | No OSC 52; local clipboard still works |
| Konsole | :material-check: | :material-help: | |
| xterm | :material-check-outline: | :material-check: | OSC 52 needs `allowWindowOps: true` |
| **Apple Terminal.app** | :material-close: | :material-close: | Corrected explicitly; use iTerm2 or Ghostty |
| Linux console (`TERM=linux`) | :material-close: | :material-close: | Falls back to 16 colours |
| `TERM=dumb` / unset | :material-close: | :material-close: | Falls back to 8 colours; still loads |

CI loads the config under 13 different `$TERM` values. That does not emulate
those terminals — it proves the config never errors and always produces a
usable colour setting.

---

## Clipboard

| Environment | Local clipboard | Over SSH |
| --- | --- | --- |
| macOS | `pbcopy` | OSC 52 (not Terminal.app) |
| Wayland | `wl-copy` | OSC 52 |
| X11 | `xclip` or `xsel` | OSC 52 |
| WSL2 | `clip.exe` | OSC 52 |
| Cygwin/MSYS2 | `/dev/clipboard` | OSC 52 |
| Headless / container | *(none)* | OSC 52 |

An absent local tool is a supported state, not a failure: copying still works
through OSC 52 and tmux's own buffers. See
[Capabilities → Clipboard routing](capabilities.md#clipboard-routing).

---

## Locales

| Locale | Status | Result |
| --- | :---: | --- |
| UTF-8 | :material-check: | Unicode separators (`│`, `•`) |
| Non-UTF-8 (C/POSIX) | :material-check: | **Automatic ASCII fallback** (`\|`, `-`) |
| No `locale` command | :material-check: | Falls back to reading `$LANG` / `$LC_ALL` |

Without this handling tmux replaces every non-ASCII character with `_`, which
is what a Unicode status bar degrades into on a minimal container or an
unconfigured SSH host. Both paths are covered by `tests/run`.

---

## Shells

The configuration does not care which shell you use — it is tmux configuration,
not shell configuration. The *scripts* are POSIX `sh` so they run under dash
and busybox as well as bash.

| Shell | Status |
| --- | :---: |
| bash, zsh, fish, dash, ksh | :material-check: |
| busybox `ash` (Alpine) | :material-check: |
| Windows PowerShell / cmd | :material-close: (no tmux at all) |

---

## Editors

| Editor | Status | Notes |
| --- | :---: | --- |
| Neovim | :material-check: | A hard requirement — see [Neovim](../integration/neovim.md); CI enforces input safety |
| Vim | :material-check: | Same guarantees |
| Helix, Emacs, micro | :material-check-outline: | No Ctrl key is taken globally, so nothing is intercepted |

---

## Plugins

All plugins are vendored and pinned, so compatibility is a property of the
snapshot in this repository rather than of upstream at any given moment. See
`vendor-manifest/plugins.toml` for the exact revision shipped.

| Plugin | Extra requirement |
| --- | --- |
| tmux-resurrect, tmux-continuum | none |
| vim-tmux-navigator | the Neovim-side plugin |
| tmux-open | `xdg-open` / `open` |
| tmux-sessionist | none |
| tmux-logging | none |
| extrakto | `fzf` |
| tmux-fpp | `fpp` |

Adapters check for a missing binary and tell you, rather than leaving a
binding that silently does nothing.

---

## Reporting a gap

If something here is wrong for your setup, that is worth an issue. Include:

```bash
./scripts/info --fresh
./scripts/doctor
```
