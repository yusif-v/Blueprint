# Blueprint

## Version 0.1.0

---

## Introduction
Blueprint is a personal setup script that configures a fresh terminal environment to match my preferred workflow. It automates the installation of essential tools and the symlinking of my dotfiles, providing a consistent and ready-to-use development environment across different machines.

---

## Features
This script automates the installation of the following:

- **Terminal Tools**:
  - `atuin`: A modern shell history manager.
  - `bat`: A `cat` clone with syntax highlighting and Git integration.
  - `eza`: A modern replacement for `ls`.
  - `ripgrep`: A fast, powerful search tool.
  - `tmux`: A terminal multiplexer.
  - `yazi`: A fast terminal file manager.
  - `zoxide`: A smarter `cd` command.

- **Developer Tools**:
  - `git`: A version control system.
  - `neovim` & `vim`: Powerful text editors.
  - `python`: A versatile programming language.
  - `wget`: A utility to retrieve files from the web.

- **Shell Customization**:
  - `powerlevel10k`: A customizable theme for Zsh.
  - `zinit`: A fast and powerful Zsh plugin manager.

---

## Requirements

- **MacOS**:
  - `Alacritty` (as the terminal emulator for which the config is provided).

---

## Usage

To run the script and apply the configuration, simply execute the following command in your terminal:

```bash
./setup.sh
