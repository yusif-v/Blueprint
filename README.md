# Blueprint

## Version 0.3.0

---

## Introduction

Blueprint is a personal setup project that configures a fresh terminal environment to match my preferred workflow.
It installs essential tools and Nerd Fonts, then **symlinks** my dotfiles into `$HOME` so edits stay in sync with the repo, providing a consistent and ready-to-use development environment across macOS, Linux, and Windows.

---

## Structure

```
Blueprint/
├── install.sh          # entrypoint: detects OS and dispatches
├── dotfiles/           # mirrors $HOME; everything here gets symlinked
│   ├── .zshrc
│   ├── .vimrc
│   ├── .tmux.conf
│   ├── .p10k.zsh
│   ├── .config/
│   │   ├── alacritty/alacritty.toml
│   │   └── nvim/
│   └── windows/
│       └── Microsoft.PowerShell_profile.ps1   # symlinked to $PROFILE
├── scripts/
│   ├── lib.sh          # shared helpers: logging, backup, symlink
│   ├── macos.sh        # Homebrew formulae + casks
│   ├── linux.sh        # apt / pacman / dnf detection + install
│   ├── windows.ps1     # winget tools + dotfile symlinks
│   └── fonts.sh        # Nerd Font installer
└── packages/
    ├── brew.txt        # one formula per line
    └── winget.txt      # command|winget-id per line
```

Dotfiles are deployed as **symlinks**. Any existing real file in `$HOME` is backed up to `<file>.backup` before linking. Adding a tool is a one-line edit to `packages/brew.txt` or `packages/winget.txt` — no script changes needed.

---

## Features

- **Terminal tools**: `atuin`, `bat`, `eza`, `ripgrep`, `tmux`, `yazi`, `zoxide`
- **Developer tools**: `git`, `neovim` & `vim`, `python`, `wget`
- **Shell**: `powerlevel10k` theme, `zinit` plugin manager
- **Fonts**: Nerd Fonts (default `font-jetbrains-mono-nerd-font`), with optional interactive selection

---

## Requirements

- **macOS**: `Alacritty` (the terminal emulator the config targets). Homebrew is installed automatically if missing.
- **Linux**: a supported package manager (`apt`, `pacman`, or `dnf`). Some tools may need manual install depending on your distro.
- **WSL**: auto-detected and treated specially — Blueprint installs **Linuxbrew** so the Homebrew-based `.zshrc` works unchanged (all tools available, just like macOS). The brew environment is appended to `~/.zprofile`.
- **Windows**: `winget` (ships with modern Windows). Symlinks require Developer Mode or an elevated PowerShell. Installs CLI tools (zoxide, atuin, bat, eza, ripgrep, yazi) plus `oh-my-posh`, and symlinks a PowerShell profile to `$PROFILE` that wires them up — the Windows analogue of the zsh setup.

---

## Usage

**macOS / Linux** — from the repo root:

```bash
./install.sh
```

**Windows** — from PowerShell (elevated or with Developer Mode on):

```powershell
.\scripts\windows.ps1
```
