# Blueprint Windows setup: install tools via winget and symlink dotfiles.
# Run from an elevated PowerShell, or enable Developer Mode for symlinks.

$RepoRoot   = Split-Path -Parent $PSScriptRoot
$Dotfiles   = Join-Path $RepoRoot "dotfiles"
$WingetList = Join-Path $RepoRoot "packages\winget.txt"

# --- Install tools from packages/winget.txt (format: command|winget-id) ---
function Install-Tools {
    Get-Content $WingetList | ForEach-Object {
        $line = $_.Trim()
        if ($line -eq "" -or $line.StartsWith("#")) { return }

        $parts   = $line.Split("|")
        $command = $parts[0]
        $id      = $parts[1]

        if ($command -ne "none" -and (Get-Command $command -ErrorAction SilentlyContinue)) {
            Write-Host "$command is already installed."
        } else {
            Write-Host "Installing $id..."
            winget install --id $id --source winget -e
        }
    }
}

# --- Symlink dotfiles into the user profile ---
# Maps repo path (under dotfiles/) to destination under $HOME.
$DotLinks = @{
    ".vimrc"                          = ".vimrc"
    ".config\nvim"                    = ".config\nvim"
    ".config\alacritty\alacritty.toml" = ".config\alacritty\alacritty.toml"
}

function Link-Dotfiles {
    foreach ($entry in $DotLinks.GetEnumerator()) {
        $src  = Join-Path $Dotfiles $entry.Key
        $dest = Join-Path $HOME     $entry.Value

        if (-not (Test-Path $src)) {
            Write-Host "Source missing, skipping: $src"
            continue
        }

        $destDir = Split-Path -Parent $dest
        if (-not (Test-Path $destDir)) { New-Item -ItemType Directory -Path $destDir -Force | Out-Null }

        if (Test-Path $dest) {
            $item = Get-Item $dest -Force
            if ($item.LinkType -eq "SymbolicLink") {
                Remove-Item $dest -Force
            } else {
                Move-Item $dest "$dest.backup" -Force
                Write-Host "Backed up existing $dest -> $dest.backup"
            }
        }

        New-Item -ItemType SymbolicLink -Path $dest -Target $src | Out-Null
        Write-Host "Linked $dest -> $src"
    }
}

Install-Tools
Link-Dotfiles
Write-Host "Windows setup complete."
