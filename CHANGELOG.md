# Changelog

All notable changes to this project are documented here.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/).

Because this is a configuration rather than a library, "breaking" means: after
updating, something you relied on behaves differently without you changing a
setting. Renamed options and changed defaults count. New opt-in features do not.

## [Unreleased]

### Changed — BREAKING: tmux defaults reclaimed

Several bindings had quietly taken a tmux default and given it an unrelated
job. Each of those keys is now back to what tmux does, and the feature has
moved to a key tmux leaves free. If you had built muscle memory on the old
bindings, this is the list to read.

| Key | Was (tmux-config) | Now |
| --- | --- | --- |
| <kbd>prefix</kbd> <kbd>r</kbd> | reload the config | tmux `refresh-client` — **reload moved to <kbd>prefix</kbd> <kbd>R</kbd>** |
| <kbd>prefix</kbd> <kbd>/</kbd> | search the scrollback | tmux describe-key — **search moved to <kbd>prefix</kbd> <kbd>Ctrl</kbd>+<kbd>f</kbd>** |
| <kbd>prefix</kbd> <kbd>-</kbd> | split stacked | tmux `delete-buffer` — **split moved to <kbd>prefix</kbd> <kbd>_</kbd>** |
| <kbd>prefix</kbd> <kbd>=</kbd> | even-horizontal layout | tmux `choose-buffer` — use tmux's <kbd>prefix</kbd> <kbd>M-1</kbd> |
| <kbd>prefix</kbd> <kbd>+</kbd> | even-vertical layout | unbound — use tmux's <kbd>prefix</kbd> <kbd>M-2</kbd> |
| <kbd>prefix</kbd> <kbd>&lt;</kbd> / <kbd>&gt;</kbd> | move window left/right | tmux's window and pane menus — **moved to <kbd>M-&lt;</kbd> / <kbd>M-&gt;</kbd>** |
| <kbd>prefix</kbd> <kbd>p</kbd> | paste buffer | tmux `previous-window` — paste is tmux's <kbd>prefix</kbd> <kbd>]</kbd> |
| <kbd>prefix</kbd> <kbd>P</kbd> | choose buffer | unbound — use tmux's <kbd>prefix</kbd> <kbd>=</kbd> |
| <kbd>prefix</kbd> <kbd>H</kbd> <kbd>J</kbd> <kbd>K</kbd> <kbd>L</kbd> | resize pane | **moved to <kbd>prefix</kbd> <kbd>M-h/j/k/l</kbd>**; <kbd>H</kbd> is now the Key Explorer |
| copy-mode <kbd>H</kbd> / <kbd>L</kbd> | start / end of line | tmux `top-line` / `bottom-line`, which is what vi means |
| <kbd>prefix</kbd> <kbd>\\</kbd> | full-height split | **moved to <kbd>prefix</kbd> <kbd>M-&#124;</kbd>** |
| <kbd>prefix</kbd> <kbd>_</kbd> | full-width split | now the plain stacked split; full-width is <kbd>prefix</kbd> <kbd>M-_</kbd> |

Redundant bindings that only repeated a tmux default were removed:
<kbd>prefix</kbd> <kbd>z</kbd>, <kbd>d</kbd>, <kbd>$</kbd>, <kbd>S</kbd>, and
copy-mode <kbd>V</kbd>, <kbd>C-v</kbd>, <kbd>C-u</kbd>, <kbd>C-d</kbd>. All of
them still work — they are tmux's own. Dropping <kbd>prefix</kbd> <kbd>S</kbd>
also resolves the long-standing clash with `tmux-sessionist`.

Four tmux defaults are still deliberately displaced, each now registered with a
written justification and visible in the Key Explorer: <kbd>prefix</kbd>
<kbd>l</kbd> (completes the vi pane row; `last-window` moved to
<kbd>prefix</kbd> <kbd>Tab</kbd>) and copy mode's <kbd>v</kbd>,
<kbd>Enter</kbd> and mouse-drag-end.

### Added

- **Key Explorer** on <kbd>prefix</kbd> <kbd>H</kbd> — a searchable reference
  for every binding, in a native tmux popup. POSIX shell and awk only: no
  Python, no Node, no Nerd Font, and `fzf` is an optional convenience rather
  than a dependency. Three views: a curated Quick list, Active (read from the
  running server, so plugin and `local.conf` keys appear), and All.
- **Key registry** under `keys/`. The upstream half is captured from tmux
  itself by `scripts/gen-upstream-keys`, never transcribed by hand; the custom
  half records provenance, category, tags and — for a displaced default — what
  it displaced and why.
- `scripts/check-key-conflicts`, which fails the build when a binding takes a
  tmux default without declaring it, when an "enhancement" actually changed the
  command's purpose, or when an override is unjustified.
- `scripts/check` now compares the registry against a live tmux server in both
  directions, so a binding cannot exist without being registered.
- `local-options.conf` — a second override file sourced **before** the modules,
  so setting `@cfg_theme` or `@cfg_prefix` there actually reaches the
  parse-time `%if` that reads it. `local.conf` still loads last for raw tmux
  commands.
- `@cfg_key_explorer_fzf` to opt into fzf-backed search.
- CI job that builds tmux 3.3a, 3.4, 3.5a and 3.6 from source and captures each
  keymap, so the "no conflict in any supported version" guarantee is checked
  rather than asserted.

### Fixed

- `./install.sh --copy` installed a **broken** config: it copied only
  `tmux.conf` and `config/`, omitting `capabilities/` and `terminals/`, which
  `tmux.conf` sources. Copy installs silently lost capability detection and
  theming. It now copies everything the config needs.

### Added

- Capability layer (`capabilities/`) with tri-state `auto` / `on` / `off` for
  true colour, status-bar glyphs and extended keys. Detection runs once in a
  single shell (`scripts/detect`) and every consumer reads the result at parse
  time.
- Automatic ASCII fallback for the status bar when the locale is not UTF-8,
  which previously produced a bar full of `_`.
- Colour degradation across 16m / 256 / 16 / 8 colour terminals.
- `terminals/corrections.conf` for terminals known to misreport their
  capabilities (Terminal.app, the Linux console, nested tmux, st).
- Diagnostics: `scripts/info`, `scripts/doctor`, `scripts/check`.
- Test suite (`tests/run`) covering 13 `TERM` values, UTF-8 and non-UTF-8
  locales, and SSH detection.
- CI on Ubuntu and macOS plus Debian, Fedora, Arch and Alpine containers, with
  a strict documentation build.
- Vendored plugin system: `vendor-manifest/plugins.toml`, `scripts/update-vendor`,
  and an adapter per plugin in `plugins/`.
- Documentation: Philosophy, Capabilities, Neovim and Diagnostics pages.

### Changed

- **Options renamed from `@tmx_*` to `@cfg_*`.** Update any `local.conf` that
  sets them.
- **TPM removed.** Plugins are vendored with `git subtree` and enabled through
  `@cfg_plugin_*`. `install.sh --with-tpm` now prints a notice and does nothing.
- `@cfg_vim_navigator` renamed to `@cfg_plugin_navigator` for consistency with
  the other plugin switches.
- Terminal and colour handling moved out of `config/10-general.conf` into
  `capabilities/`.
- Clipboard selection no longer probes the system itself; it reads
  `@cap_clipboard_tool` from the shared detection pass.

### Fixed

- `install.sh --uninstall` left the original `~/.tmux.conf` stranded in a
  `.bak-` file when no `~/.config/tmux` had existed before installing.
- `@cfg_prefix` values other than `C-a` bound `send-prefix` to the wrong key.
- The platform indicator was unset when `@cfg_system_clipboard` was `off`,
  while the documentation told readers to inspect it.
- `install.sh` reported success when installed to a non-default
  `XDG_CONFIG_HOME`, even though no module had loaded — `source-file -q` hides
  missing files. Both the installer and `doctor` now verify a sentinel option.
- The keybindings generator produced locale-dependent output, which made the
  CI sync check fail intermittently.
- `.gitignore` matched `plugins/`, which would have excluded the plugin
  adapters from the repository.
