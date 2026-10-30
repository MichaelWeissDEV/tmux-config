# tmux-config

Portable, modulare tmux-Konfiguration mit Themes, Key Explorer und optionalen,
vendorten Plugins. Die normalen tmux-Funktionen bleiben erreichbar.

**[Vollständige Dokumentation](https://tmux-config.readthedocs.io/en/latest/)** ·
[Arch-Paket](https://tmux-config.readthedocs.io/en/latest/packages/) ·
[Keybindings](https://tmux-config.readthedocs.io/en/latest/keybindings/quick/) ·
[Optionen](https://tmux-config.readthedocs.io/en/latest/reference/options/)

```bash
curl -fsSL https://raw.githubusercontent.com/MichaelWeissDEV/dotfiles/main/install.sh | bash -s -- tmux
```

Paket: `arch-dotfiles-tmux`. Lokale Anpassungen: `~/.config/tmux/local-options.conf`
und `local.conf`. `prefix H` öffnet den Key Explorer, `prefix R` lädt neu.
Für tmux 3.8 liegen Zusatzfunktionen jetzt auf `prefix G` (Scratch-Terminal),
`prefix J` (Pane holen) und `prefix B` (letztes Fenster), damit `g`, `@` und `Tab`
ihre neuen tmux-Standardfunktionen behalten.

Hier unabhängig entwickeln und auf `main` pushen; nach erfolgreichem Registry-Build
mit `sudo pacman -Syu` aktualisieren. [PACKAGING.md](PACKAGING.md).

[![CI](https://github.com/MichaelWeissDEV/tmux-config/actions/workflows/ci.yml/badge.svg)](https://github.com/MichaelWeissDEV/tmux-config/actions/workflows/ci.yml)
[![Package safety](https://github.com/MichaelWeissDEV/tmux-config/actions/workflows/package.yml/badge.svg)](https://github.com/MichaelWeissDEV/tmux-config/actions/workflows/package.yml)

[MIT-Lizenz](LICENSE); vendorte Plugins behalten ihre jeweiligen Lizenzen.
