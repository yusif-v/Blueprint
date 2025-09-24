$tools = @(
    @{Name="Powershell 7"; Command= "pwsh"; WingetId="Microsoft.Powershell"},
    @{Name="Git"; Command="git"; WingetId="Git.Git"; ExtraArgs="-e"},
    @{Name="Vim"; Command="vim"; WingetId="vim.vim"; ExtraArgs="-e"},
    @{Name="Neovim"; Command="nvim"; WingetId="Neovim.Neovim"; ExtraArgs="-e"},
    @{Name="Visual Studio Code"; Command="code"; WingetId="Microsoft.VisualStudioCode"; ExtraArgs="-e"}
    @{Name="OpenSSH"; Command="ssh"; WingetId="Microsoft.OpenSSH.Beta"; ExtraArgs="-e"}
)

foreach ($tool in $tools) {
    if (Get-Command $tool.Command -ErrorAction SilentlyContinue) {
        Write-Host "$($tool.Name) is already installed."
    } else {
        Write-Host "Installing $($tool.Name)..."
        $installCommand = "winget install --id $($tool.WingetId) --source winget $($tool.ExtraArgs)"
        Invoke-Expression $installCommand
    }
}
