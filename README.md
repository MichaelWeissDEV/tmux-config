<div align="center">

# tmux-config

**A readable, portable, fast tmux configuration.**

One file to configure · six themes · no plugins required
macOS · Linux · WSL2 · MSYS2/Cygwin

[![CI](https://github.com/MichaelWeissDEV/tmux-config/actions/workflows/ci.yml/badge.svg)](https://github.com/MichaelWeissDEV/tmux-config/actions/workflows/ci.yml)
[![Docs](https://readthedocs.org/projects/tmux-config/badge/?version=latest)](https://tmux-config.readthedocs.io/en/latest/)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![tmux 3.3+](https://img.shields.io/badge/tmux-3.3%2B-1BB91F?logo=tmux&logoColor=white)](https://github.com/tmux/tmux)

[**Documentation**](https://tmux-config.readthedocs.io) ·
[Installation](https://tmux-config.readthedocs.io/en/latest/getting-started/installation/) ·
[Configuration](https://tmux-config.readthedocs.io/en/latest/configuration/) ·
[Keybindings](https://tmux-config.readthedocs.io/en/latest/keybindings/quick/)

</div>

---

## Quick start

```bash
git clone https://github.com/MichaelWeissDEV/tmux-config.git ~/.config/tmux
cd ~/.config/tmux && ./install.sh
tmux
```

The installer backs up anything already there, checks your tmux version, and
verifies the config loads before it finishes.

---

## The idea

Everything you would normally want to change is a named option with a
documented default. You set them in **one file**, which `git pull` never
touches:

```tmux
# local-options.conf
set -g @cfg_theme  "catppuccin-mocha"   # 6 themes, or write your own
set -g @cfg_prefix "C-b"                # C-a if you prefer
set -g @cfg_mouse  "on"
```

Change a value, press <kbd>Ctrl</kbd>+<kbd>b</kbd> <kbd>R</kbd>, done. You do
not need to know which tmux option, which key table, or which of the seven
`pane-*-style` settings implements it.

Modules read those options and apply them. Themes define ten colour variables
and no layout, so a new theme is a twenty-line file.

## Why it is built this way

- **Fast** — conditionals resolve at parse time, not by forking shells. The
  status bar runs no subprocesses. Plugins are off by default.
- **Degrades instead of breaking** — true colour, Unicode glyphs and the
  clipboard route are detected. No UTF-8 locale? ASCII separators,
  automatically, instead of a status bar full of `_`.
- **Portable** — macOS, Linux (Wayland/X11), BSD, WSL and Cygwin, plus OSC 52
  so copying works over SSH.
- **Plugins vendored, not fetched** — pinned in the repo via `git subtree`. No
  plugin manager, nothing downloaded at startup, works offline.
- **Neovim-safe by rule** — no Ctrl-based key is intercepted globally, and CI
  fails the build if that ever changes.
- **tmux stays tmux** — a default binding may be improved, never given an
  unrelated job. The whole config displaces four of them, each registered with
  a written justification. `scripts/check-key-conflicts` fails the build on a
  silent repurposing, and `scripts/check` compares the key registry against a
  live tmux server in both directions.
- **Honest about tradeoffs** — where a default takes something from you (like
  <kbd>Alt</kbd>+number being stolen from apps in your panes), that is written
  down next to the setting.
- **Documented** — including the tmux behaviours that make configs mysterious,
  such as [the `%if` parse-time trap](https://tmux-config.readthedocs.io/en/latest/architecture/#the-if-trap).

The keymap pages and the options reference are **generated** — the keys from a
registry whose upstream half is captured from tmux itself, never transcribed by
hand — so they cannot drift. CI fails on a stale one.

## The Key Explorer

<kbd>Ctrl</kbd>+<kbd>b</kbd> <kbd>H</kbd> opens a searchable list of every
binding, in a native tmux popup:

```text
tmux-config keys   Quick

Search: _

PANES
  Prefix |           Split side by side
  Prefix _           Split stacked
  Prefix h           Select the pane to the left
  Prefix z           Zoom the active pane
--------------------------------------------------------------------
/ search   n/N next/prev   Enter details   a active view   q close
```

Type `/` and then `split`, `zoom`, `detach` or `copy` to find the key you
half-remember. Switch to the **Active** view to see what is bound *right now*,
including keys from an enabled plugin and your own `local.conf` overrides —
it reads the running server, not a file.

POSIX shell and awk. No Python, no Node, no Nerd Font; `fzf` is an optional
convenience, and the test suite proves the Explorer never needs it.

## Ready-made additions

`local.conf.example` ships a set of recipes already written and commented out —
copy it to `local.conf` and uncomment what you want:

- popups for lazygit, `man`, notes, htop
- an fzf session switcher and a project opener
- git branch in the status bar (with the performance cost stated)
- a free SSH warning indicator
- per-host and per-capability configuration

See [Recipes](https://tmux-config.readthedocs.io/en/latest/customization/recipes/).

## Requirements

tmux **3.3+**, and a UTF-8 locale. No Nerd Font, no Python, no plugin manager.

> [!IMPORTANT]
> tmux does not run on native Windows — not in PowerShell, not in `cmd.exe`.
> It needs WSL2, MSYS2, or Cygwin. All three are supported; the requirement
> comes from tmux itself and no configuration can remove it.

## Layout

```
tmux.conf              loader
config/                core: options, keys, copy mode, clipboard, theme, status
capabilities/          detect.conf, terminal.conf, symbols.conf
terminals/             targeted fixes for known-broken terminals
plugins/               one adapter per plugin
vendor/                vendored plugins (git subtree) — no plugin manager
vendor-manifest/       upstream, pinned revision, licence per plugin
keys/                  the key registry: upstream (captured from tmux),
                       custom, and the generated merge
local-options.conf     yours, gitignored, loaded BEFORE the modules
local.conf             yours, gitignored, loaded last
scripts/               info · doctor · check · check-key-conflicts
                       key-explorer · update-vendor · doc generators
tests/run              behaviour tests across TERM/locale/SSH environments
```

## Development

```bash
./scripts/info      # what the config resolved to on this machine
./scripts/doctor    # diagnose the environment, with fixes
./scripts/check     # static checks (also run in CI)
./scripts/check-key-conflicts   # no tmux default is repurposed
./tests/run         # behaviour tests across TERM/locale/SSH environments

./scripts/gen-keys && ./scripts/gen-docs              # after changing bindings
./scripts/gen-options.py > docs/reference/options.md  # after changing options
./scripts/gen-upstream-keys                           # capture this tmux's keymap

pip install -r requirements-docs.txt && mkdocs serve  # preview the docs
```

`check` verifies that no Ctrl key is globally intercepted, that no key is bound
twice, that every option used is defined, that the generated docs are in sync,
and that the key registry matches what a real tmux server binds — in both
directions, so a binding cannot exist without being written down. CI runs it on
Ubuntu, macOS, Debian, Fedora, Arch and Alpine, and separately builds tmux
3.3a, 3.4, 3.5a and 3.6 to capture each version's keymap.

---

<details>
<summary><b>Kurzfassung auf Deutsch</b></summary>

<br>

Eine tmux-Konfiguration, die **lesbar, portabel und schnell** ist — und so
dokumentiert, dass du jeden Teil ändern kannst, ohne vorher das tmux-Handbuch
zu lesen.

**Die Idee:** Alles, was man üblicherweise anpassen möchte, steht in *einer*
Datei (`local-options.conf`) als benannte Option mit dokumentiertem
Standardwert. Wert ändern, <kbd>Ctrl</kbd>+<kbd>b</kbd> <kbd>R</kbd> drücken,
fertig.

**tmux bleibt tmux.** Standardbindings werden erhalten. Eine Standardbelegung
darf verbessert, aber nie zweckentfremdet werden — insgesamt weicht die Config
von genau vier tmux-Defaults ab, jede begründet und maschinell geprüft.

**Key Explorer:** <kbd>Ctrl</kbd>+<kbd>b</kbd> <kbd>H</kbd> öffnet eine
durchsuchbare Liste aller Tastenbelegungen in einem nativen tmux-Popup — ohne
Python, ohne Nerd Font, ohne `fzf`.

**Installation:**

```bash
git clone https://github.com/MichaelWeissDEV/tmux-config.git ~/.config/tmux
cd ~/.config/tmux && ./install.sh
```

Das Skript legt Backups von vorhandenen Konfigurationen an, prüft die
tmux-Version und testet am Ende, ob die Konfiguration fehlerfrei lädt.

**Wichtig zu Windows:** tmux läuft **nicht** nativ unter Windows — weder in
PowerShell noch in `cmd.exe`. Es braucht WSL2, MSYS2 oder Cygwin. Alle drei
werden unterstützt; die Einschränkung kommt von tmux selbst.

**Voraussetzungen:** tmux 3.3+ und eine UTF-8-Locale. Keine Nerd Font, kein
Python, kein Plugin-Manager nötig.

Die vollständige Dokumentation ist auf Englisch:
[tmux-config.readthedocs.io](https://tmux-config.readthedocs.io)

</details>

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). `./scripts/check` and `./tests/run`
must pass; both run in CI across six platforms.

## Author

**Michael Weiss** — author and maintainer.

## License

MIT — see [LICENSE](LICENSE).
