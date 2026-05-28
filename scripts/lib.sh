#!/usr/bin/env bash
# Shared helpers for Blueprint install scripts.
# Sourced by install.sh and the per-OS scripts; not meant to run standalone.

# Repo root, resolved from this file's location so callers can run from anywhere.
BLUEPRINT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DOTFILES_DIR="$BLUEPRINT_ROOT/dotfiles"

# --- Logging ---
log()  { printf '\033[0;34m::\033[0m %s\n' "$*"; }
ok()   { printf '\033[0;32m✓\033[0m %s\n' "$*"; }
warn() { printf '\033[0;33m!\033[0m %s\n' "$*"; }
err()  { printf '\033[0;31m✗\033[0m %s\n' "$*" >&2; }

# Read a package list file, ignoring blank lines and # comments.
# Usage: read_packages packages/brew.txt
read_packages() {
  local file="$1"
  [[ -f "$file" ]] || { err "package list not found: $file"; return 1; }
  grep -vE '^\s*(#|$)' "$file"
}

# Symlink a dotfile from the repo into $HOME, backing up any existing real file.
# Usage: symlink dotfiles/.zshrc .zshrc
symlink() {
  local src="$DOTFILES_DIR/$1"
  local dest="$HOME/$2"

  if [[ ! -e "$src" ]]; then
    warn "source missing, skipping: $src"
    return 0
  fi

  mkdir -p "$(dirname "$dest")"

  # Already the correct link — nothing to do.
  if [[ -L "$dest" && "$(readlink "$dest")" == "$src" ]]; then
    ok "linked already: $dest"
    return 0
  fi

  # Real file/dir in the way: back it up before replacing.
  if [[ -e "$dest" && ! -L "$dest" ]]; then
    mv "$dest" "$dest.backup"
    warn "backed up existing $dest -> $dest.backup"
  elif [[ -L "$dest" ]]; then
    rm "$dest"
  fi

  ln -s "$src" "$dest"
  ok "linked $dest -> $src"
}
