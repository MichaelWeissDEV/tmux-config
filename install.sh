#!/usr/bin/env sh
# ==============================================================================
#  install.sh — install this tmux config to ~/.config/tmux
# ==============================================================================
#
#  Usage:
#      ./install.sh              symlink the repo into place (recommended)
#      ./install.sh --copy       copy files instead of symlinking
#      ./install.sh --with-tpm   also clone the plugin manager
#      ./install.sh --uninstall  restore the most recent backup
#      ./install.sh --dry-run    show what would happen, change nothing
#
#  Any existing config is backed up to ~/.config/tmux.bak-<timestamp> and
#  ~/.tmux.conf.bak-<timestamp>. Nothing is ever deleted without a backup.
#
#  POSIX sh — no bashisms — so it runs on macOS, Linux, WSL and MSYS2 alike.
# ==============================================================================

set -eu

SRC="$(cd "$(dirname "$0")" && pwd)"
DEST="${XDG_CONFIG_HOME:-$HOME/.config}/tmux"
STAMP="$(date +%Y%m%d-%H%M%S)"

MODE="symlink"
WITH_TPM=0
DRY=0
UNINSTALL=0

for arg in "$@"; do
  case "$arg" in
    --copy)      MODE="copy" ;;
    --with-tpm)  WITH_TPM=1 ;;   # kept so old instructions do not hard-fail
    --dry-run)   DRY=1 ;;
    --uninstall) UNINSTALL=1 ;;
    -h|--help)   sed -n '3,20p' "$0" | sed 's/^#  \{0,1\}//'; exit 0 ;;
    *) printf 'Unknown option: %s\n' "$arg" >&2; exit 1 ;;
  esac
done

say()  { printf '  %s\n' "$*"; }
run()  { if [ "$DRY" -eq 1 ]; then printf '  [dry-run] %s\n' "$*"; else eval "$@"; fi; }

# ------------------------------------------------------------------------------
#  Uninstall
# ------------------------------------------------------------------------------
if [ "$UNINSTALL" -eq 1 ]; then
  RESTORED=0

  # A user who only had ~/.tmux.conf (no ~/.config/tmux) gets no directory
  # backup at install time — only a file backup. Both must be checked, or
  # uninstall strands their original config in a .bak- file.
  DIR_BACKUP="$(find "$(dirname "$DEST")" -maxdepth 1 -name 'tmux.bak-*' 2>/dev/null | sort | tail -n1)"
  FILE_BACKUP="$(find "$HOME" -maxdepth 1 -name '.tmux.conf.bak-*' 2>/dev/null | sort | tail -n1)"

  # Remove what we installed first, so a restore cannot be blocked by it.
  if [ -L "$DEST" ] || [ -e "$DEST" ]; then
    say "Removing installed config at $DEST"
    run "rm -rf '$DEST'"
  fi

  # Our shim is a one-line source-file; only remove it if that is what it is.
  if [ -f "$HOME/.tmux.conf" ] && grep -q "source-file .*tmux.conf" "$HOME/.tmux.conf" 2>/dev/null \
     && [ "$(wc -l < "$HOME/.tmux.conf")" -le 2 ]; then
    say "Removing the ~/.tmux.conf shim"
    run "rm -f '$HOME/.tmux.conf'"
  fi

  if [ -n "$DIR_BACKUP" ]; then
    say "Restoring $DIR_BACKUP -> $DEST"
    run "mv '$DIR_BACKUP' '$DEST'"
    RESTORED=1
  fi

  if [ -n "$FILE_BACKUP" ]; then
    say "Restoring $FILE_BACKUP -> ~/.tmux.conf"
    run "mv '$FILE_BACKUP' '$HOME/.tmux.conf'"
    RESTORED=1
  fi

  if [ "$RESTORED" -eq 0 ]; then
    say "No backup found — nothing to restore."
    say "  Looked for: $(dirname "$DEST")/tmux.bak-* and ~/.tmux.conf.bak-*"
    exit 1
  fi

  say "Done. Apply with: tmux kill-server"
  exit 0
fi

# ------------------------------------------------------------------------------
#  Preflight
# ------------------------------------------------------------------------------
printf '\ntmux-config installer\n\n'

if ! command -v tmux >/dev/null 2>&1; then
  say "tmux is not installed or not on PATH."
  say "  macOS:        brew install tmux"
  say "  Debian/Ubuntu: sudo apt install tmux"
  say "  Fedora:       sudo dnf install tmux"
  say "  Arch:         sudo pacman -S tmux"
  say "  Windows:      tmux does not run natively — use WSL2. See docs/getting-started/installation.md"
  exit 1
fi

VERSION="$(tmux -V | sed 's/[^0-9.]//g')"
if [ "$(printf '%s\n3.3\n' "$VERSION" | sort -V | head -n1)" != "3.3" ]; then
  say "Found tmux $VERSION, but this config needs 3.3 or newer."
  say "See docs/getting-started/installation.md#older-tmux for options."
  exit 1
fi
say "tmux $VERSION detected — OK"

case "$(uname -s)" in
  Darwin) PLATFORM="macOS" ;;
  Linux)  if [ -n "${WSL_DISTRO_NAME:-}" ] || grep -qi microsoft /proc/version 2>/dev/null
          then PLATFORM="WSL"; else PLATFORM="Linux"; fi ;;
  CYGWIN*|MINGW*|MSYS*) PLATFORM="MSYS/Cygwin" ;;
  *) PLATFORM="$(uname -s)" ;;
esac
say "Platform: $PLATFORM"

# ------------------------------------------------------------------------------
#  Non-standard config directory
# ------------------------------------------------------------------------------
#  The config sources its modules from a literal `~/.config/tmux/...` path,
#  because tmux cannot expand formats or resolve relative paths inside
#  `source-file` (see docs/architecture.md#paths).
#
#  So if XDG_CONFIG_HOME points somewhere else, a symlink install would load
#  tmux.conf and then silently find no modules — `source-file -q` suppresses
#  the errors. We rewrite the paths into the installed copy instead.
REWRITE=0
if [ "$DEST" != "$HOME/.config/tmux" ]; then
  say "XDG_CONFIG_HOME is set — installing to $DEST"
  say "  Rewriting internal paths, and switching to copy mode so the"
  say "  originals in the repo stay untouched."
  MODE="copy"
  REWRITE=1
fi

# ------------------------------------------------------------------------------
#  Back up whatever is already there
# ------------------------------------------------------------------------------
if [ -e "$DEST" ] || [ -L "$DEST" ]; then
  say "Backing up $DEST -> $DEST.bak-$STAMP"
  run "mv '$DEST' '$DEST.bak-$STAMP'"
fi

if [ -e "$HOME/.tmux.conf" ] && [ ! -L "$HOME/.tmux.conf" ]; then
  say "Backing up ~/.tmux.conf -> ~/.tmux.conf.bak-$STAMP"
  run "mv '$HOME/.tmux.conf' '$HOME/.tmux.conf.bak-$STAMP'"
fi

# ------------------------------------------------------------------------------
#  Install
# ------------------------------------------------------------------------------
run "mkdir -p '$(dirname "$DEST")'"

if [ "$MODE" = "symlink" ]; then
  say "Linking $SRC -> $DEST"
  run "ln -s '$SRC' '$DEST'"
else
  say "Copying $SRC -> $DEST"
  run "mkdir -p '$DEST'"
  # Everything tmux.conf sources, plus what those files reach for at runtime.
  # This list is not "the interesting directories" — it is the set without
  # which the config does not load. capabilities/ and terminals/ are sourced
  # directly; scripts/ backs the Key Explorer popup; keys/ is its data.
  run "cp -R '$SRC/tmux.conf' '$SRC/local.conf.example' '$SRC/local-options.conf.example' '$DEST/'"
  for d in config capabilities terminals plugins scripts keys vendor; do
    [ -e "$SRC/$d" ] || continue
    run "cp -R '$SRC/$d' '$DEST/'"
  done
fi

if [ "$REWRITE" -eq 1 ] && [ "$DRY" -eq 0 ]; then
  for f in "$DEST/tmux.conf" "$DEST"/config/*.conf; do
    [ -f "$f" ] || continue
    sed "s|~/.config/tmux|$DEST|g; s|\$HOME/.config/tmux|$DEST|g" "$f" > "$f.new"
    mv "$f.new" "$f"
  done
  say "Paths rewritten to $DEST"
fi

# Compatibility shim: tmux < 3.1 only looks at ~/.tmux.conf.
# Harmless on newer versions, which prefer ~/.config/tmux/tmux.conf anyway.
if [ ! -e "$HOME/.tmux.conf" ]; then
  say "Adding ~/.tmux.conf shim for older tmux"
  run "printf 'source-file %s/tmux.conf\\n' '$DEST' > '$HOME/.tmux.conf'"
fi

# ------------------------------------------------------------------------------
#  Vendored plugins
# ------------------------------------------------------------------------------
#  There is no plugin manager to install. Plugins live inside the repository
#  under vendor/ and are enabled with @cfg_plugin_* options. Nothing is
#  downloaded at tmux startup.
if [ "$WITH_TPM" -eq 1 ]; then
  say "Note: --with-tpm is obsolete."
  say "  Plugins are vendored in this repository — no plugin manager needed."
  say "  Enable one with @cfg_plugin_* in config/00-options.conf."
  say "  See docs/plugins/available.md."
fi

# ------------------------------------------------------------------------------
#  Verify the config actually loads
# ------------------------------------------------------------------------------
#  An empty stderr is NOT proof of a good install: every module is sourced with
#  `source-file -q`, which stays silent when a file is missing. A config that
#  found none of its modules therefore "loads cleanly" while doing nothing.
#
#  So we also assert that a sentinel option is set. `@thm_accent` is defined by
#  a theme file, which is only reached through options -> theme loader -> theme.
#  If it has a value, the whole chain ran.
if [ "$DRY" -eq 0 ]; then
  say "Verifying the config loads..."
  ERR="$(tmux -f "$DEST/tmux.conf" -L install-check new-session -d 2>&1 || true)"
  SENTINEL="$(tmux -L install-check show -gv @thm_accent 2>/dev/null || true)"
  tmux -L install-check kill-server 2>/dev/null || true

  if [ -n "$ERR" ]; then
    printf '\n  Config loaded with messages:\n%s\n\n' "$ERR"
    say "See docs/reference/troubleshooting.md"
  fi

  case "$SENTINEL" in
    "#"*)
      say "Config loads correctly (modules and theme applied)."
      ;;
    *)
      printf '\n'
      say "PROBLEM: tmux.conf loaded but its modules did not."
      say "  Expected @thm_accent to be a colour, got: '${SENTINEL:-<unset>}'"
      say "  This usually means the config is not at the path it expects."
      say "  Installed at: $DEST"
      say "  See docs/reference/troubleshooting.md and docs/architecture.md#paths"
      exit 1
      ;;
  esac
fi

printf '\nDone.\n\n'
say "Next steps:"
say "  1. Start tmux:            tmux"
say "  2. Edit your settings:    $DEST/config/00-options.conf"
say "  3. Reload after changes:  prefix + R   (prefix is Ctrl-b by default)"
say "  4. See all keybindings:   prefix + ?"
printf '\n'
