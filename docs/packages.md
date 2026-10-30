# Arch package and automatic updates

```bash
curl -fsSL https://raw.githubusercontent.com/MichaelWeissDEV/dotfiles/main/install.sh | bash -s -- tmux
```

This installs `arch-dotfiles-tmux`, tmux and the common activation tool. Existing
settings, `local-options.conf` and `local.conf` are preserved. Edit your user copy
under `~/.config/tmux`, not package-owned files under `/usr`.

Update with `sudo pacman -Syu`. The installed timer imports defaults, or use
`adot sync`. Own edits remain; merge `.pacnew` files and reload with `prefix R`.
Develop in a separate checkout and push to `main`; the registry checks revisions
every five minutes and publishes after passing tests. GitHub can delay schedules.

## tmux 3.8 compatibility

tmux 3.8 uses `prefix g`, `prefix @` and `prefix Tab` for native features. They
are left untouched. Scratch terminal: `prefix G`; join a pane: `prefix J`;
last window: `prefix B`. `prefix H` remains the Key Explorer. Pristine upstream
keymaps are checked so new defaults are not mistaken for unexplained user keys.

Remove with `arch-dotfiles-config deactivate tmux`, then
`sudo pacman -Rns arch-dotfiles-tmux`. Remove a dependent overall metapackage
first. User copies and backups remain.

[Installer and migration guide](https://arch-dotfiles.readthedocs.io/en/latest/arch-package/) ·
[Safety tests](https://arch-dotfiles.readthedocs.io/en/latest/verification/).
Standalone setups: [Installation](getting-started/installation.md).
