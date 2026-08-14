#!/usr/bin/env sh
# ==============================================================================
#  gen-keybindings.sh — generate docs/keybindings.md from the live config
# ==============================================================================
#
#  Hand-written keybinding tables drift from the config within a week, and the
#  keybinding page is the one readers actually use. So we generate it from
#  `tmux list-keys -N`, which reports what is ACTUALLY bound, including the
#  `-N` descriptions written in config/20-keys.conf.
#
#  Usage:  ./scripts/gen-keybindings.sh > docs/keybindings.md
#
#  Run this after changing any binding, and commit the result.
# ==============================================================================

set -eu

# Pin collation. `sort` orders punctuation differently under C vs a UTF-8
# locale, which would make this file's output depend on the machine that ran
# it — and the CI check compares the result byte for byte.
LC_ALL=C
export LC_ALL

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SOCKET="keygen-$$"
TMPCONF="$(mktemp -d)"

# The config hardcodes ~/.config/tmux (see docs/architecture.md#paths), so to
# document THIS repo — installed or not — we materialise a copy with the paths
# rewritten to point here. That keeps the generated docs honest about the
# working tree rather than about whatever happens to be installed.
cp -R "$ROOT/config" "$TMPCONF/config"
for d in capabilities terminals plugins scripts; do
  [ -d "$ROOT/$d" ] && cp -R "$ROOT/$d" "$TMPCONF/$d"
done
sed "s|~/.config/tmux|$TMPCONF|g; s|\$HOME/.config/tmux|$TMPCONF|g" \
  "$ROOT/tmux.conf" > "$TMPCONF/tmux.conf"
for f in "$TMPCONF"/config/*.conf; do
  sed -i.bak "s|~/.config/tmux|$TMPCONF|g; s|\$HOME/.config/tmux|$TMPCONF|g" "$f"
  rm -f "$f.bak"
done

tmux -f "$TMPCONF/tmux.conf" -L "$SOCKET" new-session -d 2>/dev/null
trap 'tmux -L "$SOCKET" kill-server 2>/dev/null || true; rm -rf "$TMPCONF"' EXIT

PREFIX="$(tmux -L "$SOCKET" show -gv prefix 2>/dev/null)"

emit_table() {
  table="$1"; heading="$2"; intro="$3"
  # `list-keys -N` prints: <key> <description>, only for bindings that have one.
  # tmux prints "<prefix> <key><padding><description>". Strip the leading
  # prefix token so the Key column holds just the key you actually press.
  body="$(tmux -L "$SOCKET" list-keys -N -T "$table" 2>/dev/null \
          | sed 's/^[[:space:]]*//' \
          | awk -v pfx="$PREFIX" 'NF > 1 {
              if ($1 == pfx && NF > 2) { $1 = ""; sub(/^[[:space:]]+/, "") }
              key = $1
              $1 = ""
              sub(/^[[:space:]]+/, "")
              gsub(/\|/, "\\|")
              if (key == "" || $0 == "") next
              printf "| `%s` | %s |\n", key, $0
            }' | sort -k2)"
  [ -z "$body" ] && return 0
  printf '\n## %s\n\n%s\n\n| Key | Action |\n| --- | --- |\n%s\n' \
    "$heading" "$intro" "$body"
}

cat <<'HEADER'
# Keybindings

!!! info "This page is generated"
    Do not edit it by hand. It is produced from the live config by
    `scripts/gen-keybindings.sh`, so it always matches what is actually bound.
    Regenerate with:

    ```bash
    ./scripts/gen-keybindings.sh > docs/keybindings.md
    ```

Throughout this page, **`prefix`** means the prefix key — <kbd>Ctrl</kbd>+<kbd>b</kbd>
by default. Change it with `@cfg_prefix` in
[`config/00-options.conf`](configuration.md#prefix).

You can always see the live list inside tmux with <kbd>prefix</kbd> <kbd>?</kbd>.
HEADER

emit_table "prefix" "With prefix" \
  "Press the prefix key first, release, then the key below."

emit_table "root" "Without prefix" \
  "These are bound globally. tmux intercepts them before the program running in your pane sees them — see [the tradeoff note](configuration.md#alt-number-window-switching)."

emit_table "copy-mode-vi" "Copy mode (vi)" \
  "Active **only** inside copy mode. These have no effect on Neovim or your shell. Enter copy mode with <kbd>prefix</kbd> <kbd>[</kbd>, leave it with <kbd>q</kbd>."

printf '\n---\n\n*Generated from `tmux %s`.*\n' "$(tmux -V | sed 's/tmux //')"
