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

# The user's current login shell, read from passwd (falls back to $SHELL).
current_login_shell() {
  if command -v getent &>/dev/null; then
    getent passwd "$USER" | cut -d: -f7
  else
    dscl . -read "/Users/$USER" UserShell 2>/dev/null | awk '{print $2}' || echo "$SHELL"
  fi
}

# Switch the login shell to zsh if it isn't already. zsh must be installed.
set_default_shell() {
  local zsh_path
  zsh_path="$(command -v zsh || true)"
  if [[ -z "$zsh_path" ]]; then
    warn "zsh not installed; leaving login shell unchanged"
    return 0
  fi

  if [[ "$(current_login_shell)" == "$zsh_path" ]]; then
    ok "login shell already zsh ($zsh_path)"
    return 0
  fi

  # zsh must be listed in /etc/shells to be a valid login shell.
  if [[ -w /etc/shells || -n "$(command -v sudo)" ]] && ! grep -qxF "$zsh_path" /etc/shells 2>/dev/null; then
    echo "$zsh_path" | sudo tee -a /etc/shells >/dev/null
  fi

  log "Setting login shell to $zsh_path (may prompt for password)..."
  if chsh -s "$zsh_path" 2>/dev/null || sudo chsh -s "$zsh_path" "$USER"; then
    ok "Login shell set to zsh — restart your terminal to apply."
  else
    warn "Could not change shell automatically. Run: chsh -s $zsh_path"
  fi
}
