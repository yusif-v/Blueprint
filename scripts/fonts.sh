#!/usr/bin/env bash
# Nerd Font installer (macOS/Linuxbrew). Sourced or run after lib.sh is loaded.
set -euo pipefail

DEFAULT_FONT="font-jetbrains-mono-nerd-font"

install_fonts() {
  local available font choice
  available=$(brew search '/font-.*-nerd-font/' | awk '{ print $1 }')

  if [[ -n "${BLUEPRINT_NONINTERACTIVE:-}" || ! -t 0 ]]; then
    font="$DEFAULT_FONT"
    echo "Non-interactive: installing default font $font"
  else
    while true; do
      read -r -p "Do you want to see available fonts? (y/n) " show
      [[ "$show" =~ ^[Yy]$ ]] && echo "$available"

      read -r -p "Enter the font you want (default: $DEFAULT_FONT): " choice
      if [[ -z "$choice" ]]; then
        font="$DEFAULT_FONT"
        break
      fi
      if echo "$available" | grep -Fxq "$choice"; then
        font="$choice"
        break
      fi
      echo "Error: $choice is not a valid Nerd Font. Try again."
    done
  fi

  if brew list --cask "$font" &>/dev/null; then
    echo "$font is already installed"
  else
    echo "Installing $font..."
    brew install --cask "$font"
  fi
}

# Allow running standalone: ./scripts/fonts.sh
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  install_fonts
fi
