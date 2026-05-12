#Requires -Version 5.1
[CmdletBinding()]
param(
    [ValidateSet('CurrentUser', 'AllUsers')]
    [string] $Scope = 'CurrentUser',

    [switch] $IncludeBackground = $true,
    [switch] $IncludeDrives = $true,
    [switch] $Uninstall,
    [switch] $WhatIf,
    [string] $CodexExe
)

$ErrorActionPreference = 'Stop'

function Get-CodexDesktopExe {
    param([string] $ExplicitPath)

    if ($ExplicitPath) {
        $resolved = Resolve-Path -LiteralPath $ExplicitPath -ErrorAction Stop
        if (-not (Test-Path -LiteralPath $resolved -PathType Leaf)) {
            throw "Codex executable is not a file: $ExplicitPath"
        }
        return $resolved.Path
    }

    $package = Get-AppxPackage -Name OpenAI.Codex -ErrorAction SilentlyContinue |
        Sort-Object Version -Descending |
        Select-Object -First 1

    if ($package) {
        $candidate = Join-Path $package.InstallLocation 'app\Codex.exe'
        if (Test-Path -LiteralPath $candidate -PathType Leaf) {
            return $candidate
        }
    }

    $localCandidate = Join-Path $env:LOCALAPPDATA 'OpenAI\Codex\app\Codex.exe'
    if (Test-Path -LiteralPath $localCandidate -PathType Leaf) {
        return $localCandidate
    }

    throw @'
Could not find Codex Desktop.

Install Codex from the Microsoft Store, or pass the Desktop executable path:
  .\Install-OpenWithCodex.ps1 -CodexExe "C:\Path\To\Codex.exe"
'@
}

function Get-RegistryRoot {
    param([string] $InstallScope)

    if ($InstallScope -eq 'AllUsers') {
        $isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).
            IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
        if (-not $isAdmin) {
            throw 'AllUsers scope requires an elevated PowerShell session. Use -Scope CurrentUser to install without admin rights.'
        }
        return 'HKLM:\Software\Classes'
    }

    return 'HKCU:\Software\Classes'
}

function Get-MenuEntries {
    param([string] $Root)

    $entries = @(
        @{
            Key = Join-Path $Root 'Directory\shell\OpenProjectInCodex'
            Arg = '%1'
        }
    )

    if ($IncludeBackground) {
        $entries += @{
            Key = Join-Path $Root 'Directory\Background\shell\OpenProjectInCodex'
            Arg = '%V'
        }
    }

    if ($IncludeDrives) {
        $entries += @{
            Key = Join-Path $Root 'Drive\shell\OpenProjectInCodex'
            Arg = '%1'
        }
    }

    return $entries
}

function Remove-OldOpenWithCodexEntries {
    param([string] $Root)

    $legacyKeys = @(
        Join-Path $Root 'Directory\shell\OpenCodexProject'
        Join-Path $Root 'Directory\Background\shell\OpenCodexProject'
        Join-Path $Root 'Drive\shell\OpenCodexProject'
    )

    foreach ($key in $legacyKeys) {
        if (Test-Path -LiteralPath $key) {
            Remove-Item -LiteralPath $key -Recurse -Force
        }
    }
}

function Install-MenuEntry {
    param(
        [string] $Key,
        [string] $ArgumentToken,
        [string] $ExePath
    )

    New-Item -Path $Key -Force | Out-Null
    Set-Item -LiteralPath $Key -Value 'Open project in Codex'
    New-ItemProperty -Path $Key -Name 'MUIVerb' -Value 'Open project in Codex' -PropertyType String -Force | Out-Null
    New-ItemProperty -Path $Key -Name 'Icon' -Value ('"{0}",0' -f $ExePath) -PropertyType String -Force | Out-Null
    New-ItemProperty -Path $Key -Name 'Position' -Value 'Top' -PropertyType String -Force | Out-Null

    $commandKey = Join-Path $Key 'command'
    New-Item -Path $commandKey -Force | Out-Null
    $command = '"{0}" --open-project "{1}"' -f $ExePath, $ArgumentToken
    Set-Item -LiteralPath $commandKey -Value $command
}

$root = Get-RegistryRoot -InstallScope $Scope
$entries = Get-MenuEntries -Root $root

if ($Uninstall) {
    if (-not $WhatIf) {
        foreach ($entry in $entries) {
            if (Test-Path -LiteralPath $entry.Key) {
                Remove-Item -LiteralPath $entry.Key -Recurse -Force
            }
        }
        Remove-OldOpenWithCodexEntries -Root $root
    }
    if ($WhatIf) {
        Write-Host "WhatIf complete. Would remove Open project in Codex context menu entries from $Scope."
    }
    else {
        Write-Host "Removed Open project in Codex context menu entries from $Scope."
    }
    return
}

$codexDesktopExe = Get-CodexDesktopExe -ExplicitPath $CodexExe

if (-not $WhatIf) {
    Remove-OldOpenWithCodexEntries -Root $root
    foreach ($entry in $entries) {
        Install-MenuEntry -Key $entry.Key -ArgumentToken $entry.Arg -ExePath $codexDesktopExe
    }
}

if ($WhatIf) {
    Write-Host "WhatIf complete. Would install Open project in Codex context menu entries for $Scope."
}
else {
    Write-Host "Installed Open project in Codex context menu entries for $Scope."
}
Write-Host "Codex Desktop: $codexDesktopExe"
Write-Host 'If Explorer does not refresh immediately, restart Explorer or check "Show more options" on Windows 11.'
