# Security Policy

## Scope

This project is a tmux configuration. It runs with your user's privileges and
executes shell commands at tmux startup, so the realistic risks are:

- **Command injection through the environment.** `scripts/detect` reads
  `$TERM`, `$COLORTERM`, `$SSH_*` and locale variables. Values are single-quoted
  with embedded quotes escaped and applied through a file that tmux parses, so
  a hostile `$TERM` cannot execute commands. There is a test for this.
- **Vendored third-party code.** Plugins under `vendor/` are code you run.
  They are pinned to a specific commit in `vendor-manifest/plugins.toml`,
  reviewed before each update, and never fetched at runtime.
- **Anything in `local.conf`.** That file is yours and is not reviewed by this
  project.

The configuration performs no network access at any point. Cloning the
repository is the only download involved.

## Reporting a vulnerability

Open a private security advisory through GitHub's "Report a vulnerability"
button on the repository's Security tab. Please do not open a public issue for
anything exploitable.

Useful to include:

- what an attacker controls (an environment variable, a pane's output, a
  filename, …)
- the tmux version and platform
- output of `./scripts/info --fresh`

## Supported versions

The latest release on the default branch. This project has no long-term support
branches.

## Hardening notes

- Plugins are all disabled by default; the default configuration runs no
  third-party code at all.
- `@cfg_plugin_resurrect` restores a deliberately short list of processes.
  Restoring arbitrary commands at boot re-runs whatever happened to be in a
  pane, which is why the list is not user-expanded by default.
- `allow-passthrough` is enabled so programs inside panes can reach the
  clipboard via OSC 52. It also lets those programs emit escape sequences to
  your terminal. Set it to `off` in `local.conf` if you run untrusted output
  in panes.
