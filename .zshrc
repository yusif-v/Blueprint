# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# --- Powerlevel10k ---
source $(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# --- ZINIT ---
export ZINIT_HOME="$(brew --prefix zinit)"
source "${ZINIT_HOME}/zinit.zsh"

zinit light zdharma-continuum/fast-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions

# --- Completions ---
autoload -Uz compinit && compinit
zinit cdreplay -q

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
eval "$(atuin init zsh)"

# --- Zoxide ---
eval "$(zoxide init zsh)"
alias cd="z"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# --- Bat ---
alias cat="bat -pp"

# --- Ripgrep ---
alias grep="rg"

# --- Eza ---
alias ls="eza --icons=always"
alias tree="eza --tree"

# --- Python ---
alias pip="pip3"
alias python="python3"
alias server="python3 -m http.server"

