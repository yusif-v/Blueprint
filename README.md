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
├── bootstrap.sh        # curl | bash entrypoint (clones repo, runs install.sh)
├── bootstrap.ps1       # irm | iex entrypoint for Windows
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

### One-line install

**macOS / Linux / WSL:**

```bash
curl -fsSL https://raw.githubusercontent.com/yusif-v/Blueprint/main/bootstrap.sh | bash
```

**Windows** (PowerShell, elevated or with Developer Mode on):

```powershell
irm https://raw.githubusercontent.com/yusif-v/Blueprint/main/bootstrap.ps1 | iex
```

The bootstrap installs `git` if needed, clones Blueprint to a permanent location
(`~/.local/share/blueprint`, or `%LOCALAPPDATA%\Blueprint` on Windows — override
with `BLUEPRINT_HOME`), then runs the installer. The clone must persist because
dotfiles are symlinked into it. When piped, prompts re-attach to your terminal if
one is available; otherwise it runs non-interactively with sane defaults.

### From a clone

If you'd rather clone first:

```bash
git clone https://github.com/yusif-v/Blueprint.git
cd Blueprint
./install.sh                 # macOS / Linux / WSL
# or, on Windows:
.\scripts\windows.ps1
```

On macOS/Linux the installer also sets **zsh** as your login shell (installing it
first on Linux if needed). Restart your terminal afterward for the change to take
effect. Set `BLUEPRINT_NONINTERACTIVE=1` to skip all prompts and accept defaults.
