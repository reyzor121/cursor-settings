param(
  [string]$CursorExtensionsPath = "$env:APPDATA\Cursor\extensions"
)

$ErrorActionPreference = "Stop"

$sourceRoot = Join-Path $PSScriptRoot "themes"
$themeFolders = @(
  "testa.neon-balanced-theme-0.0.1",
  "testa.neon-pink-balanced-theme-v3-0.0.1",
  "testa.matrix-agent-theme-0.0.1"
)

if (!(Test-Path $CursorExtensionsPath)) {
  New-Item -ItemType Directory -Path $CursorExtensionsPath | Out-Null
}

foreach ($folder in $themeFolders) {
  $src = Join-Path $sourceRoot $folder
  $dst = Join-Path $CursorExtensionsPath $folder
  if (!(Test-Path $src)) {
    throw "Missing source theme folder: $src"
  }
  Copy-Item -Recurse -Force $src $dst
  Write-Host "Copied $folder"
}

$extensionsJsonPath = Join-Path $CursorExtensionsPath "extensions.json"
if (Test-Path $extensionsJsonPath) {
  $extensions = Get-Content -Raw $extensionsJsonPath | ConvertFrom-Json
} else {
  $extensions = @()
}

function Ensure-ThemeEntry {
  param(
    [array]$Entries,
    [string]$Id,
    [string]$Folder,
    [long]$InstalledTimestamp
  )

  $existing = $Entries | Where-Object { $_.identifier.id -eq $Id }
  if ($existing) { return $Entries }

  $windowsPath = Join-Path $CursorExtensionsPath $Folder
  $uriPath = "/c:/Users/$env:USERNAME/.cursor/extensions/$Folder"
  $external = "file:///c%3A/Users/$env:USERNAME/.cursor/extensions/$Folder"

  $newEntry = [PSCustomObject]@{
    identifier = [PSCustomObject]@{ id = $Id }
    version = "0.0.1"
    location = [PSCustomObject]@{
      '$mid' = 1
      fsPath = $windowsPath
      _sep = 1
      external = $external
      path = $uriPath
      scheme = "file"
    }
    relativeLocation = $Folder
    metadata = [PSCustomObject]@{
      installedTimestamp = $InstalledTimestamp
      pinned = $true
      source = "vsix"
    }
  }

  return @($Entries + $newEntry)
}

$extensions = Ensure-ThemeEntry -Entries $extensions -Id "testa.neon-balanced-theme" -Folder "testa.neon-balanced-theme-0.0.1" -InstalledTimestamp 1774509086715
$extensions = Ensure-ThemeEntry -Entries $extensions -Id "testa.neon-pink-balanced-theme-v3" -Folder "testa.neon-pink-balanced-theme-v3-0.0.1" -InstalledTimestamp 1774510668836
$extensions = Ensure-ThemeEntry -Entries $extensions -Id "testa.matrix-agent-theme" -Folder "testa.matrix-agent-theme-0.0.1" -InstalledTimestamp 1774512200000

$extensions | ConvertTo-Json -Depth 10 -Compress | Set-Content -Encoding UTF8 $extensionsJsonPath

Write-Host "Cursor themes installed. Restart Cursor and choose theme in Color Themes."
