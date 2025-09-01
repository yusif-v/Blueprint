#!/bin/bash

if [[ "$(uname)" == "Darwin" ]]; then
  OS="MacOS"
elif [[ "$(uname)" == "Linux" ]]; then
  OS="Linux"
else
  echo "Unsupported OS"
  exit 1
fi

echo "Detected OS: $OS"

packages=(
  "atuin"
  "bat"
  "eza"
  "git"
  "neovim"
  "powerlevel10k"
  "python"
  "ripgrep"
  "tmux"
  "vim"
  "wget"
  "yazi"
  "zinit"
  "zoxide"
)

configs=(
  ".config/alacritty/alacritty.toml"
  ".config/nvim"
  ".p10k.zsh"
  ".tmux.conf"
  ".vimrc"
  ".zshrc"
)

if [[ "$OS" == MacOS ]]; then
  if ! command -v brew &>/dev/null; then
    echo "Installing Homebrew..."
    if ! /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; then
      echo "Homebrew installation failed!"
      exit 1
    fi
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi

  for pkg in "${packages[@]}"; do
    if brew list --formula $pkg &>/dev/null; then
      echo "$pkg is already installed"
    else
      echo "$pkg is missing"
      brew install $pkg &>/dev/null || echo "$pkg installation failed"
    fi
  done

  bash font.sh

  mkdir -p $HOME/.config
  mkdir -p $HOME/.config/alacritty/

  for conf in "${configs[@]}"; do
    if [[ -e "$conf" ]]; then
      echo "Copying $conf to $HOME/$conf"
      cp -r "$conf" "$HOME/$conf" || echo "Failed to copy $conf"
    else
      echo "$conf does not exist, skipping"
    fi
  done
fi
