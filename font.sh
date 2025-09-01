#!/bin/bash

DEFAULT_FONT="font-jetbrains-mono-nerd-font"

echo "Do you want to see available fonts? (y/n)"
read -r SHOW_FONTS
if [[ "$SHOW_FONTS" =~ ^[Yy]$ ]]; then
  echo "Fetching available Nerd Fonts..."
  AVAILABLE_FONTS=$(brew search '/font-.*-nerd-font/' | awk '{ print $1 }')
  echo "$AVAILABLE_FONTS"
fi

echo "Enter the font you want (Default is $DEFAULT_FONT)"
read -r FONT_CHOICE

if [ -z "$FONT_CHOICE" ]; then
  FONT=$DEFAULT_FONT
  echo "No font specified. Installing the default font: $FONT"
else
  FONT=$FONT_CHOICE
  echo "Validating font: $FONT"
  if echo "$AVAILABLE_FONTS" | grep -Fx "$FONT" &>/dev/null; then
    echo "Attempting to install: $FONT"
  else
    echo "Error: $FONT is not a valid Nerd Font. Run with 'y' to see available fonts."
    exit 1
  fi
fi

if brew list --cask "$FONT" &>/dev/null; then
  echo "$FONT is already installed"
else
  echo "Installing $FONT..."
  if brew install --cask "$FONT" &>/dev/null; then
    echo "$FONT installed successfully"
  else
    echo "Failed to install $FONT. Check Homebrew setup or font availability."
    exit 1
  fi
fi
