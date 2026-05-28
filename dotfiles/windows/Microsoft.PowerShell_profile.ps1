# Blueprint PowerShell profile — mirrors .zshrc where a Windows equivalent exists.
# Symlinked to $PROFILE by scripts/windows.ps1. Each block is guarded so a
# missing tool never breaks the shell.

$env:EDITOR = "nvim"

# --- Zoxide (smarter cd) ---
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Invoke-Expression (& { (zoxide init powershell | Out-String) })
    Set-Alias -Name cd -Value z -Option AllScope
}

# --- Atuin (shell history) ---
if (Get-Command atuin -ErrorAction SilentlyContinue) {
    Invoke-Expression (& { (atuin init powershell | Out-String) })
}

# --- Eza (ls replacement) ---
if (Get-Command eza -ErrorAction SilentlyContinue) {
    function ls   { eza --icons=always @args }
    function tree { eza --tree @args }
}

# --- Bat (cat replacement) ---
if (Get-Command bat -ErrorAction SilentlyContinue) {
    function cat { bat -pp @args }
}

# --- Ripgrep ---
if (Get-Command rg -ErrorAction SilentlyContinue) {
    function grep { rg @args }
}

# --- Python ---
if (Get-Command python -ErrorAction SilentlyContinue) {
    function server { python -m http.server @args }
}

# --- oh-my-posh prompt (Windows analogue of powerlevel10k) ---
if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
    oh-my-posh init pwsh | Invoke-Expression
}
