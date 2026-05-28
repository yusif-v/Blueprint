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

# --- Symlink one item, backing up any existing real file ---
function Link-Item {
    param([string]$Src, [string]$Dest)

    if (-not (Test-Path $Src)) {
        Write-Host "Source missing, skipping: $Src"
        return
    }

    $destDir = Split-Path -Parent $Dest
    if ($destDir -and -not (Test-Path $destDir)) {
        New-Item -ItemType Directory -Path $destDir -Force | Out-Null
    }

    if (Test-Path $Dest) {
        $item = Get-Item $Dest -Force
        if ($item.LinkType -eq "SymbolicLink") {
            Remove-Item $Dest -Force
        } else {
            Move-Item $Dest "$Dest.backup" -Force
            Write-Host "Backed up existing $Dest -> $Dest.backup"
        }
    }

    New-Item -ItemType SymbolicLink -Path $Dest -Target $Src | Out-Null
    Write-Host "Linked $Dest -> $Src"
}

# Maps repo path (under dotfiles/) to destination under $HOME.
$DotLinks = @{
    ".vimrc"                          = ".vimrc"
    ".config\nvim"                    = ".config\nvim"
    ".config\alacritty\alacritty.toml" = ".config\alacritty\alacritty.toml"
}

function Link-Dotfiles {
    foreach ($entry in $DotLinks.GetEnumerator()) {
        Link-Item (Join-Path $Dotfiles $entry.Key) (Join-Path $HOME $entry.Value)
    }
}

# Symlink the PowerShell profile to $PROFILE (lives under Documents, not $HOME).
function Link-Profile {
    $src = Join-Path $Dotfiles "windows\Microsoft.PowerShell_profile.ps1"
    Link-Item $src $PROFILE
}

Install-Tools
Link-Dotfiles
Link-Profile
Write-Host "Windows setup complete. Restart PowerShell to load the new profile."
