# Quick start

You have installed it ([installation](installation.md)) and started tmux. Five
minutes to being productive.

## It is still tmux

Everything you already know works. <kbd>prefix</kbd> is
<kbd>Ctrl</kbd>+<kbd>b</kbd>, <kbd>prefix</kbd> <kbd>?</kbd> still lists the
keys, <kbd>prefix</kbd> <kbd>c</kbd> still makes a window,
<kbd>prefix</kbd> <kbd>d</kbd> still detaches.

This config adds to tmux; it does not replace it. Four tmux defaults are
displaced in total, and each one is [written down and justified](../keybindings/complete.md).

## The one new key worth knowing

<kbd>prefix</kbd> <kbd>H</kbd> opens the [Key Explorer](../keybindings/key-explorer.md):
a searchable list of every binding, in a tmux popup. Type <kbd>/</kbd>, type
`split`, and see every split key. It is faster than this website.

## The five keys you will use immediately

| Key | Action |
| --- | --- |
| <kbd>prefix</kbd> <kbd>&#124;</kbd> | split side by side |
| <kbd>prefix</kbd> <kbd>_</kbd> | split stacked |
| <kbd>prefix</kbd> <kbd>h</kbd> <kbd>j</kbd> <kbd>k</kbd> <kbd>l</kbd> | move between panes |
| <kbd>prefix</kbd> <kbd>z</kbd> | zoom a pane full-window, and back |
| <kbd>prefix</kbd> <kbd>R</kbd> | reload the config after you edit it |

Splits open in the directory you are already in, and so do new windows.

<kbd>Alt</kbd>+<kbd>1</kbd>…<kbd>9</kbd> jump straight to a window with no
prefix at all.

## Copying text

<kbd>prefix</kbd> <kbd>[</kbd> enters copy mode. Then vi keys: <kbd>v</kbd> to
select, <kbd>y</kbd> to copy, <kbd>q</kbd> to leave. The text lands on your
system clipboard, and [it works over SSH](../integration/clipboard.md).

Or just select with the mouse — that copies too.

## Changing something

Two files, and picking the right one matters:

```bash
# an @cfg_* setting — theme, prefix, options
$EDITOR ~/.config/tmux/local-options.conf

# your own bindings and raw tmux commands
$EDITOR ~/.config/tmux/local.conf
```

Then <kbd>prefix</kbd> <kbd>R</kbd>. The full list of settings is the
[options reference](../reference/options.md); the reason there are two files is
[local overrides](../configuration/local-overrides.md).

Want a different theme?

```tmux
set -g @cfg_theme "nord"
```

## If something looks wrong

```bash
./scripts/doctor
```

It checks the things that actually break tmux — version, config syntax, key
conflicts, `TERM`, truecolor, clipboard, focus events — and every check says
what to do about it.

## Where to go next

- [Quick reference](../keybindings/quick.md) — the keys worth knowing
- [Configuration](../configuration/index.md) — what you can change
- [Neovim](../integration/neovim.md) — if you live in an editor
