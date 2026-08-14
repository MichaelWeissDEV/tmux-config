# Changelog

All notable changes to this project are documented here.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/).

Because this is a configuration rather than a library, "breaking" means: after
updating, something you relied on behaves differently without you changing a
setting. Renamed options and changed defaults count. New opt-in features do not.

## [Unreleased]

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
