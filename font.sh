#!/bin/bash

DEFAULT_FONT="font-jetbrains-mono-nerd-font"
AVAILABLE_FONTS=$(brew search '/font-.*-nerd-font/' | awk '{ print $1 }')

while true; do
  echo "Do you want to see available fonts? (y/n)"
  read -r SHOW_FONTS
  if [[ "$SHOW_FONTS" =~ ^[Yy]$ ]]; then
    echo "Fetching available Nerd Fonts..."
    echo "$AVAILABLE_FONTS"
  fi

  echo "Enter the font you want (Default is $DEFAULT_FONT):"
  read -r FONT_CHOICE

  if [[ -z "$FONT_CHOICE" ]]; then
    FONT=$DEFAULT_FONT
    echo "No font specified. Installing the default font: $FONT"
    break
  else
    FONT=$FONT_CHOICE
    echo "Validating font: $FONT"
    if echo "$AVAILABLE_FONTS" | grep -Fx "$FONT" &>/dev/null; then
      echo "Font '$FONT' is valid."
      break
    else
      echo "Error: $FONT is not a valid Nerd Font. Please try again."
    fi
  fi
done

if brew list --cask "$FONT" &>/dev/null; then
  echo "$FONT is already installed"
else
  echo "Installing $FONT..."
  if brew install --cask "$FONT"; then
    echo "$FONT installed successfully"
  else
    echo "Failed to install $FONT. Check Homebrew setup or font availability."
    exit 1
  fi
fi
