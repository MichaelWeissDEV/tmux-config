# Installation

## Platform support

tmux is a Unix program. It uses PTYs and Unix domain sockets, neither of which
native Windows provides — so there is no native Windows build, and no
configuration can create one. On Windows you run tmux inside a Unix
environment, and this config supports all of the usual ones.

| Platform | Supported | Clipboard tool used | Notes |
| --- | :---: | --- | --- |
| **macOS** | :material-check: | `pbcopy` | Install tmux via Homebrew or MacPorts |
| **Linux (Wayland)** | :material-check: | `wl-copy` | Needs `wl-clipboard` installed |
| **Linux (X11)** | :material-check: | `xclip` or `xsel` | Either works; `xclip` is preferred |
| **WSL2** | :material-check: | `clip.exe` | Recommended route on Windows |
| **MSYS2 / Git Bash** | :material-check: | `/dev/clipboard` | Works, but WSL2 is smoother |
| **Cygwin** | :material-check: | `/dev/clipboard` | |
| **Native Windows** | :material-close: | — | **Not possible.** tmux has no native Windows port. |
| **Headless / SSH / Docker** | :material-check: | OSC 52 only | No local clipboard tool needed |

Detection is automatic — see [how it works](../configuration/index.md#copy-mode-clipboard).
The detected platform is shown in the status bar if you set
`@cfg_status_style` to `detailed`.

---

## Installing tmux

=== "macOS"

    ```bash
    brew install tmux
    ```

=== "Debian / Ubuntu"

    ```bash
    sudo apt update && sudo apt install tmux
    ```

    !!! note "Check the version"
        Debian stable and Ubuntu LTS sometimes ship tmux 3.2 or older, which
        this config rejects. Check with `tmux -V` and see
        [Older tmux](#older-tmux) if needed.

=== "Fedora / RHEL"

    ```bash
    sudo dnf install tmux
    ```

=== "Arch"

    ```bash
    sudo pacman -S tmux
    ```

=== "WSL2 (Windows)"

    Install a distro first, from an **Administrator** PowerShell:

    ```powershell
    wsl --install -d Ubuntu
    ```

    Then, **inside** the WSL shell:

    ```bash
    sudo apt update && sudo apt install tmux
    ```

    Everything from here on happens inside WSL, not in PowerShell.

=== "MSYS2"

    ```bash
    pacman -S tmux
    ```

Also install a clipboard helper if you are on Linux:

```bash
sudo apt install wl-clipboard   # Wayland
sudo apt install xclip          # X11
```

---

## Installing the config

```bash
git clone https://github.com/MichaelWeissDEV/tmux-config.git ~/.config/tmux
cd ~/.config/tmux
./install.sh
```

The installer:

1. Checks that tmux exists and is 3.3 or newer, and stops with a useful message
   if not.
2. Detects your platform and reports it.
3. **Backs up** any existing `~/.config/tmux` to `~/.config/tmux.bak-<timestamp>`
   and any existing `~/.tmux.conf` to `~/.tmux.conf.bak-<timestamp>`. Nothing is
   deleted.
4. Symlinks the repository into place.
5. Writes a small `~/.tmux.conf` shim, so tmux versions older than 3.1 (which
   do not look in `~/.config`) still find the config.
6. Starts a throwaway tmux server and confirms the config actually applied —
   it checks a sentinel option, not just an empty error stream, because a
   misplaced config loads silently doing nothing.

### Options

| Flag | Effect |
| --- | --- |
| *(none)* | Symlink the repo to `~/.config/tmux`. Recommended — edits to the repo take effect immediately. |
| `--copy` | Copy the files instead of symlinking. Use when the repo lives on a volume that will not always be mounted. |
| `--with-tpm` | Also clone the plugin manager. See [Plugins](../plugins/available.md). |
| `--dry-run` | Print every action without doing any of it. |
| `--uninstall` | Restore the most recent backup. |

### Manual installation

If you would rather not run the script:

```bash
git clone https://github.com/MichaelWeissDEV/tmux-config.git ~/.config/tmux
echo 'source-file ~/.config/tmux/tmux.conf' > ~/.tmux.conf
```

!!! warning "The path is not arbitrary"
    The config must end up at `~/.config/tmux/`. tmux cannot resolve paths
    relative to the file being sourced, so that location is written out in
    full inside the config.

    If you install it elsewhere by hand, the modules will not load — and
    because they are sourced with `source-file -q`, **tmux will report no
    error whatsoever**. Check with:

    ```bash
    tmux show -gv @thm_accent   # a colour means it worked; "invalid option" means it did not
    ```

    `install.sh` handles a non-default `XDG_CONFIG_HOME` automatically by
    rewriting the paths. See [Architecture → Paths](../architecture.md#paths).

---

## First run

```bash
tmux
```

You should see a status bar with your session name on the left and a clock on
the right.

Try these:

| Press | What happens |
| --- | --- |
| ++ctrl+b++ then ++question++ | List every keybinding |
| ++ctrl+b++ then ++bar++ | Split the pane side by side |
| ++ctrl+b++ then ++minus++ | Split the pane stacked |
| ++ctrl+b++ then ++c++ | New window |
| ++ctrl+b++ then ++r++ | Reload the config after an edit |
| ++ctrl+b++ then ++d++ | Detach (`tmux attach` to come back) |

The full list is on the [Keybindings](../keybindings/quick.md) page.

---

## Updating

```bash
cd ~/.config/tmux && git pull
```

Then press ++ctrl+b++ ++r++ inside tmux, or run `tmux kill-server` for a clean
restart.

Your `local.conf` and `config/themes/custom.conf` are gitignored, so a pull
never touches them. If you edited `config/00-options.conf` directly, git may
report a conflict there — that is the one file you are expected to edit, and
resolving it is normally a one-line merge.

!!! tip "Avoiding option conflicts entirely"
    Put your changes in `local.conf` instead of `00-options.conf`. It is loaded
    last, so `set -g @cfg_theme "nord"` there overrides the default without
    ever touching a tracked file. See [Local overrides](../configuration/index.md#local-overrides).

---

## Older tmux

This config requires **tmux 3.3+**, checked once at startup. The features it
depends on:

| Feature | Introduced | Used for |
| --- | --- | --- |
| `terminal-features` | 3.2 | True colour and undercurl declarations |
| `copy-command` | 3.2 | One clipboard binding for all platforms |
| `display-popup` | 3.2 | The floating scratch terminal |
| `pane-border-lines` | 3.2 | Border styles |
| `allow-passthrough` | 3.3 | OSC 52 from programs inside panes |

If your distro ships something older, the usual routes are a backport
repository, Homebrew on Linux, or building from source:

```bash
sudo apt install libevent-dev libncurses-dev build-essential bison pkg-config
git clone --depth 1 -b 3.5a https://github.com/tmux/tmux.git
cd tmux && sh autogen.sh && ./configure && make && sudo make install
```

---

## Uninstalling

```bash
~/.config/tmux/install.sh --uninstall
```

This restores the most recent backup. To remove everything by hand:

```bash
rm -rf ~/.config/tmux
rm -f ~/.tmux.conf
```
