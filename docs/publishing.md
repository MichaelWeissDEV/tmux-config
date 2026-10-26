# Publishing

Maintainer notes for getting this repository onto GitHub and Read the Docs.
Nothing here is needed to *use* the config.

---

## 1. Push to GitHub

The repository is already initialised with an initial commit on `main`.

```bash
gh repo create tmux-config --public --source=. --remote=origin --push
```

Or manually:

```bash
git remote add origin https://github.com/MichaelWeissDEV/tmux-config.git
git push -u origin main
```

CI runs on the first push: `scripts/check` and `tests/run` on Ubuntu and macOS,
then again in Debian, Fedora, Arch and Alpine containers, plus a strict
documentation build.

---

## 2. Read the Docs

1. Sign in at [readthedocs.org](https://readthedocs.org) with GitHub.
2. **Import a Project** → pick `tmux-config`.
3. Nothing to configure: `.readthedocs.yaml` in the repository root already
   pins Ubuntu 24.04, Python 3.12, Sphinx and `fail_on_warning: true`.
4. Build.

```{warning} If the slug is taken
Read the Docs project names are global. If `tmux-config` is unavailable you
will get something like `tmux-config-mw`, and the published URL changes.
Update the badge and links in `README.md` and
the links in `docs/index.md` to match.
```
### Why the build cannot silently rot

`fail_on_warning: true` makes Sphinx warnings fail the Read the Docs build.
CI and local builds use the same dependencies and `make -C docs dirhtml`,
which also treats warnings as errors.

The keybindings page and the options reference are **generated**. CI regenerates
them and diffs against what is committed, so a config change without a
regeneration fails the build instead of publishing documentation that describes
something no longer there.

---

## 3. Vendoring the plugins

Plugins are declared in `vendor-manifest/plugins.toml` but are not fetched until
a maintainer vendors them:

```bash
./scripts/update-vendor --list                  # what is declared and present
./scripts/update-vendor --add tmux-resurrect    # fetch and subtree it in
```

Each `--add` clones the upstream repository into `vendor/`, records the synced
commit and date back into the manifest, and copies the upstream licence into
`vendor-manifest/licenses/`.

Commit the subtree and the manifest change together — that pairing is what makes
a release traceable to exact plugin versions.

Updating later:

```bash
./scripts/update-vendor --pull tmux-resurrect
./scripts/update-vendor --pull-all
```

```{note} Users never run this
End users get plugin updates by pulling this repository, which ships a
snapshot that was tested together with the config. That is the whole point
of vendoring over a plugin manager.
```
---

## 4. Releasing

1. Move `CHANGELOG.md` entries from `[Unreleased]` into a new version heading.
2. Anything that renames an option or changes a default belongs under
   **Changed** — that is the section people read after `git pull` when
   something moved.
3. Tag it:

```bash
git tag -a v1.0.0 -m "v1.0.0"
git push origin v1.0.0
```

Read the Docs can then publish versioned docs alongside `latest`.

---

## 5. Before announcing

```bash
./scripts/check      # static checks
./tests/run          # behaviour tests
make -C docs dirhtml
```

And once, on a clean machine, the thing users will actually do:

```bash
git clone https://github.com/MichaelWeissDEV/tmux-config.git ~/.config/tmux
cd ~/.config/tmux && ./install.sh && tmux
```
