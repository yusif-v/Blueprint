# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# --- Homebrew (set prefix once; absent on bare-metal Linux) ---
if command -v brew &>/dev/null; then
  BREW_PREFIX="$(brew --prefix)"
fi

# --- Powerlevel10k ---
if [[ -n "${BREW_PREFIX:-}" && -f "$BREW_PREFIX/share/powerlevel10k/powerlevel10k.zsh-theme" ]]; then
  source "$BREW_PREFIX/share/powerlevel10k/powerlevel10k.zsh-theme"
elif [[ -f "$HOME/.local/share/powerlevel10k/powerlevel10k.zsh-theme" ]]; then
  source "$HOME/.local/share/powerlevel10k/powerlevel10k.zsh-theme"
fi
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# --- ZINIT ---
if [[ -n "${BREW_PREFIX:-}" && -d "$BREW_PREFIX/opt/zinit" ]]; then
  ZINIT_HOME="$BREW_PREFIX/opt/zinit"
else
  ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
fi
if [[ -f "$ZINIT_HOME/zinit.zsh" ]]; then
  source "$ZINIT_HOME/zinit.zsh"
  zinit light zdharma-continuum/fast-syntax-highlighting
  zinit light zsh-users/zsh-completions
  zinit light zsh-users/zsh-autosuggestions
fi

# --- Completions ---
autoload -Uz compinit && compinit
command -v zinit &>/dev/null && zinit cdreplay -q

# --- Zstyle ---
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' rehash true
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path $HOME/.zsh/cache
zstyle ':completion:*' ignore-duplicates true

# --- History ---
HISTFILE=$HOME/.zhistory
HISTSIZE=5000
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_expire_dups_first
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_find_no_dups
setopt hist_ignore_dups
setopt hist_verify

export EDITOR=nvim

# --- Atuin ---
command -v atuin &>/dev/null && eval "$(atuin init zsh)"

# --- Zoxide ---
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
  alias cd="z"
fi
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# --- Bat ---
command -v bat &>/dev/null && alias cat="bat -pp"

# --- Ripgrep ---
command -v rg &>/dev/null && alias grep="rg"

# --- Eza ---
if command -v eza &>/dev/null; then
  alias ls="eza --icons=always"
  alias tree="eza --tree"
fi

# --- Ngrok ---
command -v ngrok &>/dev/null && alias tunnel='ngrok http'

# --- Python ---
command -v python3 &>/dev/null && alias python="python3"
command -v pip3 &>/dev/null && alias pip="pip3"
alias server="python3 -m http.server"

venv() {
  local script="$HOME/Automation/Scripts/venv.sh"
  if [[ -f "$script" ]]; then
    source "$script" "$@"
  else
    echo "venv helper not found at $script" >&2
    return 1
  fi
}

# --- Rust ---
if [[ -n "${BREW_PREFIX:-}" && -d "$BREW_PREFIX/opt/rust/bin" ]]; then
  export PATH="$BREW_PREFIX/opt/rust/bin:$PATH"
elif [[ -d "$HOME/.cargo/bin" ]]; then
  export PATH="$HOME/.cargo/bin:$PATH"
fi

# --- Docker ---
alias kali="docker exec -it kali-linux /bin/bash"
