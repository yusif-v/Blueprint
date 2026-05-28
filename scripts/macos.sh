#!/usr/bin/env bash
# macOS setup: Homebrew, packages, fonts, and dotfile symlinks.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib.sh"

# Dotfiles to symlink: "<path-in-dotfiles>  <path-in-home>"
DOTLINKS=(
  ".zshrc                          .zshrc"
  ".vimrc                          .vimrc"
  ".tmux.conf                      .tmux.conf"
  ".p10k.zsh                       .p10k.zsh"
  ".config/alacritty/alacritty.toml .config/alacritty/alacritty.toml"
  ".config/nvim                    .config/nvim"
)

install_homebrew() {
  if command -v brew &>/dev/null; then
    ok "Homebrew already installed"
    return
  fi
  log "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>"$HOME/.zprofile"
  eval "$(/opt/homebrew/bin/brew shellenv)"
}

install_packages() {
  local pkg
  while read -r pkg; do
    if brew list --formula "$pkg" &>/dev/null; then
      ok "$pkg already installed"
    else
      log "Installing $pkg..."
      brew install "$pkg" &>/dev/null || err "$pkg installation failed"
    fi
  done < <(read_packages "$BLUEPRINT_ROOT/packages/brew.txt")
}

link_dotfiles() {
  local entry src dest
  for entry in "${DOTLINKS[@]}"; do
    read -r src dest <<<"$entry"
    symlink "$src" "$dest"
  done
}

main() {
  install_homebrew
  install_packages
  source "$SCRIPT_DIR/fonts.sh" && install_fonts
  link_dotfiles
  set_default_shell
  ok "macOS setup complete."
}

main "$@"
