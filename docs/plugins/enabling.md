# Enabling plugins

Plugins are **off by default** and nothing in this config depends on one.
Theming, clipboard, copy mode, capability detection, the status bar and the
[Key Explorer](../keybindings/key-explorer.md) are all plain tmux.

## Turning one on

Two switches: the master one, then the plugin.

```tmux
# in local-options.conf
set -g @cfg_plugins           "on"
set -g @cfg_plugin_resurrect  "on"
```

Reload with <kbd>prefix</kbd> <kbd>R</kbd>. With `@cfg_plugins` off, no adapter
is even sourced, so the cost of an unused plugin is exactly zero.

Enabling a plugin never silently enables another. `tmux-continuum` needs
`tmux-resurrect`, and if you turn on the first without the second you get a
message, not a second plugin quietly switching itself on.

## No plugin manager, no downloads

Plugins ship **inside this repository** under `vendor/`, added with
`git subtree` and pinned in `vendor-manifest/plugins.toml`. There is no TPM and
nothing is fetched at startup. Consequences, all deliberate:

- tmux never downloads anything — clone once, works offline
- a plugin version is reproducible and traceable to a release
- an upstream force-push cannot change what your terminal does tomorrow
- no runtime dependency on a plugin manager

You update plugins by updating this repository, which brings a snapshot that was
tested together with the config.

## Seeing a plugin's keys

Press <kbd>prefix</kbd> <kbd>H</kbd> and switch to the **Active** view with
<kbd>a</kbd>. Plugin bindings appear under *Local and plugin keys* — and they
appear only while the plugin is on, because that view reads the running server
rather than a file.

This is also how you spot a plugin taking a key you already use. The test suite
reports the same thing at build time; `tmux-sessionist`, for example, overrides
tmux's own <kbd>prefix</kbd> <kbd>C</kbd> and <kbd>prefix</kbd> <kbd>t</kbd>.
That is upstream behaviour, not a defect — but it should not be a surprise.

## Adding a plugin that is not vendored

```bash
./scripts/update-vendor --list        # what is present
```

Adding a new one means vendoring it with `git subtree` and writing a small
adapter in `plugins/`. Adapters exist so this project controls the integration:
each checks its option, checks the vendored copy is present, sets conservative
defaults, and only then loads the entrypoint. Never source `vendor/` directly.

## Turning one off

Set its option back to `off` and reload. The bindings disappear — verified by
the test suite, which asserts a plugin's keys are gone once it is disabled.
