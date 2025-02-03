################### System Functions ###################

function ChangeDirectoryAndList {
    param([string]$path)

    Set-Location -LiteralPath $path
    Get-ChildItem
}
Set-Alias -Name cdl -Value ChangeDirectoryAndList


function ForceShutdown {
    param(
        [switch]$h
    )

    if ($h) {
        Get-Help ForceShutdown
    } else {
        Stop-Computer -Force
    }
}
Set-Alias -Name off -Value ForceShutdown

# fresh -> sources PS, clears the screen, brings you back to where you were before 
function Refresh-Profile {
    $currentDirectory = Get-Location
    Clear-Host
    . $PROFILE
    Set-Location $currentDirectory
}
Set-Alias fresh Refresh-Profile


################### open PS profile files in VS Code ###################

function pro {
    # Build the path to System.ps1 in the same folder as your profile
    $systemFile = Join-Path (Split-Path $PROFILE) "System.ps1"

    # Now open that file in VS Code
    code $systemFile
}

function prods {
    # Build the path to Directory_Shortcuts.ps1 in the same folder as your profile
    $systemFile = Join-Path (Split-Path $PROFILE) "Directory_Shortcuts.ps1"

    # Now open that file in VS Code
    code $systemFile
}

function proa {
    # Build the path to aliases.ps1 in the same folder as your profile
    $systemFile = Join-Path (Split-Path $PROFILE) "aliases.ps1"

    # Now open that file in VS Code
    code $systemFile
}

################### Git Commands ###################

function allg {
    git add .
    git status
    $commitMessage = Read-Host "Enter commit message"
    git commit -m "$commitMessage"
    git push -u origin main
}


