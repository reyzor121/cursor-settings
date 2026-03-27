# Cursor Settings Themes Pack

This folder is a portable package for installing your custom Cursor themes on another computer.

## Included themes

- `Neon Balanced Dark`
- `Neon Pink Balanced Dark` (extension label: `Neon Pink Balanced Dark V3`)
- `Matrix Agent Dark`

## Folder structure

- `themes/` - full extension folders ready to copy
- `install-themes.ps1` - automatic installer for Windows Cursor
- `themes-memory.mdc` - persistent AI memory/rule with IDs and re-add flow

## Install on another computer (Windows)

1. Close Cursor.
2. Copy this whole `cursor-settings` folder to the new machine.
3. Open PowerShell in this folder.
4. Run:
   - `powershell -ExecutionPolicy Bypass -File .\install-themes.ps1`
5. Start Cursor and open:
   - `File -> Preferences -> Themes -> Color Themes`
6. Select one of the three themes.

## Manual install (if script is blocked)

1. Copy each folder from `themes/` to `%APPDATA%\Cursor\extensions\`.
2. Merge/add entries in `%APPDATA%\Cursor\extensions\extensions.json`.
3. Restart Cursor and choose the theme.
