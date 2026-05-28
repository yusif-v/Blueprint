#!/usr/bin/env bash
# Linux setup. On WSL, installs Linuxbrew for parity with macOS (the .zshrc
# is Homebrew-coupled). On bare-metal Linux, falls back to the native package
# manager. Then symlinks dotfiles either way.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib.sh"

DOTLINKS=(
  ".zshrc                          .zshrc"
  ".vimrc                          .vimrc"
  ".tmux.conf                      .tmux.conf"
  ".p10k.zsh                       .p10k.zsh"
  ".config/alacritty/alacritty.toml .config/alacritty/alacritty.toml"
  ".config/nvim                    .config/nvim"
)

LINUXBREW="/home/linuxbrew/.linuxbrew/bin/brew"

is_wsl() {
  [[ -n "${WSL_DISTRO_NAME:-}" ]] && return 0
  grep -qiE 'microsoft|wsl' /proc/version 2>/dev/null
}

detect_pm() {
  if command -v apt-get &>/dev/null; then echo apt
  elif command -v pacman &>/dev/null; then echo pacman
  elif command -v dnf &>/dev/null; then echo dnf
  else echo ""; fi
}

# --- Linuxbrew (WSL path) ---
ensure_brew() {
  if command -v brew &>/dev/null; then
    ok "Homebrew already installed"
  elif [[ -x "$LINUXBREW" ]]; then
    ok "Homebrew found at $LINUXBREW"
  else
    log "Installing Linuxbrew build prerequisites..."
    if command -v apt-get &>/dev/null; then
      sudo apt-get update
      sudo apt-get install -y build-essential procps curl file git
    fi
    log "Installing Homebrew..."
    NONINTERACTIVE=1 /bin/bash -c \
      "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  # Put brew on PATH for this run and persist it for future shells.
  eval "$("$LINUXBREW" shellenv)"
  local shellenv_line="eval \"\$($LINUXBREW shellenv)\""
  if ! grep -qF "$shellenv_line" "$HOME/.zprofile" 2>/dev/null; then
    echo "$shellenv_line" >>"$HOME/.zprofile"
    ok "Added brew shellenv to ~/.zprofile"
  fi
}

install_via_brew() {
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

install_via_pm() {
  local pm="$1" pkg
  case "$pm" in
    apt) sudo apt-get update ;;
  esac
  while read -r pkg; do
    case "$pm" in
      apt)    sudo apt-get install -y "$pkg" &>/dev/null && ok "$pkg" || warn "$pkg not available via apt" ;;
      pacman) sudo pacman -S --needed --noconfirm "$pkg" &>/dev/null && ok "$pkg" || warn "$pkg not available via pacman" ;;
      dnf)    sudo dnf install -y "$pkg" &>/dev/null && ok "$pkg" || warn "$pkg not available via dnf" ;;
    esac
  done < <(read_packages "$BLUEPRINT_ROOT/packages/brew.txt")
}

# zsh is the login shell this config targets; install it via the system PM
# (a real /etc/shells-registered binary is more reliable for login than brew's).
ensure_zsh() {
  command -v zsh &>/dev/null && { ok "zsh already installed"; return 0; }
  log "Installing zsh..."
  if   command -v apt-get &>/dev/null; then sudo apt-get install -y zsh
  elif command -v pacman  &>/dev/null; then sudo pacman -S --needed --noconfirm zsh
  elif command -v dnf     &>/dev/null; then sudo dnf install -y zsh
  elif command -v brew    &>/dev/null; then brew install zsh
  else warn "No package manager to install zsh"; fi
}

link_dotfiles() {
  local entry src dest
  for entry in "${DOTLINKS[@]}"; do
    read -r src dest <<<"$entry"
    symlink "$src" "$dest"
  done
}

main() {
  if is_wsl; then
    log "Detected WSL — using Linuxbrew for macOS parity."
    ensure_brew
    install_via_brew
  else
    local pm
    pm="$(detect_pm)"
    if [[ -z "$pm" ]]; then
      err "No supported package manager found (apt/pacman/dnf)."
      err "Install packages manually, then re-run to link dotfiles."
    else
      log "Detected package manager: $pm"
      install_via_pm "$pm"
      warn "Some tools (atuin, eza, yazi, zoxide, zinit, powerlevel10k) may need manual install on your distro."
    fi
  fi

  ensure_zsh
  link_dotfiles
  set_default_shell
  ok "Linux setup complete."
}

main "$@"
