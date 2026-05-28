# Blueprint one-line bootstrap (Windows):
#   irm https://raw.githubusercontent.com/yusif-v/Blueprint/main/bootstrap.ps1 | iex
#
# Ensures git, clones Blueprint to a permanent location, then runs windows.ps1.
# The clone must persist: dotfiles are symlinked into it.
$ErrorActionPreference = "Stop"

$RepoUrl = "https://github.com/yusif-v/Blueprint.git"
$Target  = if ($env:BLUEPRINT_HOME) { $env:BLUEPRINT_HOME } else { Join-Path $env:LOCALAPPDATA "Blueprint" }

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host ":: git not found; installing..."
    winget install --id Git.Git --source winget -e
    Write-Host "git installed — restart PowerShell and re-run this command."
    return
}

if (Test-Path (Join-Path $Target ".git")) {
    Write-Host ":: Updating existing Blueprint at $Target"
    git -C $Target pull --ff-only
} else {
    Write-Host ":: Cloning Blueprint to $Target"
    git clone $RepoUrl $Target
}

Write-Host ":: Running installer..."
& (Join-Path $Target "scripts\windows.ps1")
