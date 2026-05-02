param(
    [string]$RepoRoot,
    [switch]$CreateSkipPull,
    [switch]$CreateEnableAutoPull
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if (-not $RepoRoot) {
    $RepoRoot = (git rev-parse --show-toplevel 2>$null)
    if (-not $RepoRoot) { throw 'Git repository root not found.' }
    $RepoRoot = $RepoRoot.Trim()
}

$desktop = [Environment]::GetFolderPath('Desktop')
$wsh = New-Object -ComObject WScript.Shell

$cmdPath = Join-Path $RepoRoot 'setup-laptop.cmd'
if (-not (Test-Path $cmdPath)) {
    throw "setup-laptop.cmd not found at $cmdPath"
}

function New-Link($name, $arguments) {
    $linkPath = Join-Path $desktop ($name + '.lnk')
    $shortcut = $wsh.CreateShortcut($linkPath)
    $shortcut.TargetPath = 'powershell.exe'
    $argStr = "-NoProfile -ExecutionPolicy Bypass -File " + '"' + $cmdPath + '"'
    if ($arguments -and $arguments.Trim()) { $argStr += ' ' + $arguments }
    $shortcut.Arguments = $argStr
    $shortcut.WorkingDirectory = $RepoRoot
    $shortcut.IconLocation = "$env:SystemRoot\System32\shell32.dll, 1"
    $shortcut.Save()
    Write-Host "Created shortcut: $linkPath"
}

# Primary shortcut (no args)
New-Link -name 'SHT Platform Setup' -arguments ''

if ($CreateSkipPull) { New-Link -name 'SHT Platform Setup (SkipPull)' -arguments '-SkipPull' }
if ($CreateEnableAutoPull) { New-Link -name 'SHT Platform Setup (EnableAutoPullOnBoot)' -arguments '-EnableAutoPullOnBoot' }

Write-Host 'Shortcut creation complete.' -ForegroundColor Green
