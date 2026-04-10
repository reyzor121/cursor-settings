# Cursor Theme Skill Pack

This pack can be transferred as a single skill folder and used on another computer with Cursor.

## Included themes

- `Neon Balanced Dark`
- `Neon Pink Balanced Dark` (extension label: `Neon Pink Balanced Dark V3`)
- `Matrix Agent Dark`

## Skill folder (self-contained)

- `cursor-theme-installer/SKILL.md` - AI instructions and install workflow
- `cursor-theme-installer/scripts/install-themes.ps1` - installer script
- `cursor-theme-installer/themes/*` - bundled theme extensions

## Use on another computer (single folder)

1. Close Cursor.
2. Copy `cursor-theme-installer/` to:
   - `%USERPROFILE%\.cursor\skills\cursor-theme-installer\`
3. Open PowerShell in `%USERPROFILE%\.cursor\skills\cursor-theme-installer\`.
4. Run:
   - `powershell -ExecutionPolicy Bypass -File .\scripts\install-themes.ps1`
5. Start Cursor and open:
   - `File -> Preferences -> Themes -> Color Themes`
6. Select one of the three themes.

## Manual install (if script is blocked)

1. Copy each folder from `cursor-theme-installer/themes/` to `%APPDATA%\Cursor\extensions\`.
2. Merge/add entries in `%APPDATA%\Cursor\extensions\extensions.json`.
3. Restart Cursor and choose the theme.
