function go {
    param(
        [Parameter(Mandatory=$true)]
        [string]$keyword
    )

    # A lookup table of keyword -> path
    $paths = @{
        # Repos / GutHub
        'repos' = "C:\Users\$env:USERNAME\repos"
        'elixir' = "C:\Users\$env:USERNAME\repos\elixir"
        'df' = "C:\Users\$env:USERNAME\repos\windows_dotfiles"
        # System
        'desktop' = "C:\Users\$env:USERNAME\Desktop"
        'docs'    = "C:\Users\$env:USERNAME\Documents"
        
    }

    if ($paths.ContainsKey($keyword)) {
        # Switch to that directory
        Set-Location $paths[$keyword]
        # List all items in that location
        Get-ChildItem
    }
    else {
        Write-Host "Unknown location shortcut '$keyword'."
    }
}
