#!/usr/bin/env bash
# Blueprint one-line bootstrap (macOS / Linux / WSL):
#   curl -fsSL https://raw.githubusercontent.com/yusif-v/Blueprint/main/bootstrap.sh | bash
#
# Ensures git, clones Blueprint to a permanent location, then runs install.sh.
# The clone must persist: dotfiles are symlinked into it.
set -euo pipefail

REPO_URL="https://github.com/yusif-v/Blueprint.git"
BLUEPRINT_HOME="${BLUEPRINT_HOME:-$HOME/.local/share/blueprint}"

info() { printf '\033[0;34m::\033[0m %s\n' "$*"; }
err()  { printf '\033[0;31m✗\033[0m %s\n' "$*" >&2; }

ensure_git() {
  command -v git &>/dev/null && return 0
  info "git not found; installing..."
  if [[ "$(uname -s)" == "Darwin" ]]; then
    xcode-select --install || true
    err "Install the Xcode Command Line Tools when prompted, then re-run this command."
    exit 1
  elif command -v apt-get &>/dev/null; then sudo apt-get update && sudo apt-get install -y git
  elif command -v dnf     &>/dev/null; then sudo dnf install -y git
  elif command -v pacman  &>/dev/null; then sudo pacman -S --needed --noconfirm git
  else err "Could not install git automatically; install it and re-run."; exit 1; fi
}

fetch_repo() {
  if [[ -d "$BLUEPRINT_HOME/.git" ]]; then
    # Refuse to pull from / execute an unexpected repo at this path.
    local existing
    existing="$(git -C "$BLUEPRINT_HOME" remote get-url origin 2>/dev/null || true)"
    if [[ "$existing" != "$REPO_URL" ]]; then
      err "Unexpected git repo at $BLUEPRINT_HOME (origin: ${existing:-none})."
      err "Expected $REPO_URL. Remove it or set BLUEPRINT_HOME to another path."
      exit 1
    fi
    info "Updating existing Blueprint at $BLUEPRINT_HOME"
    git -C "$BLUEPRINT_HOME" pull --ff-only
  else
    info "Cloning Blueprint to $BLUEPRINT_HOME"
    mkdir -p "$(dirname "$BLUEPRINT_HOME")"
    git clone "$REPO_URL" "$BLUEPRINT_HOME"
  fi
}

main() {
  ensure_git
  fetch_repo
  info "Running installer..."
  # When piped (curl | bash), our stdin is the script, so interactive prompts
  # would break. Re-attach the terminal if one exists; otherwise go headless.
  if [[ -e /dev/tty ]]; then
    bash "$BLUEPRINT_HOME/install.sh" </dev/tty
  else
    BLUEPRINT_NONINTERACTIVE=1 bash "$BLUEPRINT_HOME/install.sh"
  fi
}

main "$@"
