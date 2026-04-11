param(
  # Cursor resolves extensions from ~/.cursor/extensions (not AppData\Roaming\Cursor\extensions).
  [string]$CursorExtensionsPath = (Join-Path $env:USERPROFILE ".cursor\extensions")
)

$ErrorActionPreference = "Stop"

function Get-ExtensionLocationUriFields {
  param([string]$WindowsFolderPath)
  $full = [System.IO.Path]::GetFullPath($WindowsFolderPath)
  $u = [System.Uri]::new($full)
  $external = $u.AbsoluteUri
  $forward = ($full -replace '\\', '/')
  if ($forward -match '^([A-Za-z]):(/.*)$') {
    $pathProp = '/' + $Matches[1].ToLower() + ':' + $Matches[2]
  } else {
    $pathProp = $forward
  }
  return @{ external = $external; path = $pathProp }
}

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
  $raw = (Get-Content -Raw $extensionsJsonPath).Trim()
  if ([string]::IsNullOrWhiteSpace($raw) -or $raw -eq '[]') {
    $extensions = @()
  } else {
    $parsed = $raw | ConvertFrom-Json
    $extensions = if ($parsed -is [System.Array]) { @($parsed) } else { @($parsed) }
  }
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

  $windowsPath = [System.IO.Path]::GetFullPath((Join-Path $CursorExtensionsPath $Folder))
  $uris = Get-ExtensionLocationUriFields -WindowsFolderPath $windowsPath

  $newEntry = [PSCustomObject]@{
    identifier = [PSCustomObject]@{ id = $Id }
    version = "0.0.1"
    location = [PSCustomObject]@{
      '$mid' = 1
      fsPath = $windowsPath
      _sep = 1
      external = $uris.external
      path = $uris.path
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
