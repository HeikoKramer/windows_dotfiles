# This function provides a quick shortcut for navigating to predefined directories.
# You supply a keyword (e.g. "repos"), and the function looks up the path,
# moves you there, then lists the folder contents.
function go {
    param(
        [Parameter(Mandatory=$true)]
        [string]$keyword
    )

    # A lookup table of keyword -> path
    $paths = @{
        # Repos / GitHub
        'repos' = "C:\Users\$env:USERNAME\repos"
        'elixir' = "C:\Users\$env:USERNAME\repos\elixir"
        'epro' = "C:\Users\$env:USERNAME\repos\elixir\projects\"
        'cards' = "C:\Users\$env:USERNAME\repos\elixir\projects\cards"
        'idcon' = "C:\Users\$env:USERNAME\repos\elixir\projects\identicon"
        'dot' = "C:\Users\$env:USERNAME\repos\windows_dotfiles"
        
        # System
        'desktop' = "C:\Users\$env:USERNAME\Desktop"
        'docs'    = "C:\Users\$env:USERNAME\Documents"
        'down'    = "C:\Users\$env:USERNAME\Downloads"
        
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
