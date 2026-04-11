---
name: cursor-theme-installer
description: >-
  Creates and installs custom Cursor color themes as local extensions so they
  appear in File -> Preferences -> Themes -> Color Themes. Use when the user
  asks to add, create, install, or restore a color theme in Cursor. Also use
  when working with saved themes from the cursor-settings pack (Neon Balanced
  Dark, Neon Pink Balanced Dark, Matrix Agent Dark).
---

# Cursor Theme Installer

## Saved Themes (self-contained)

This skill is self-contained: portable theme assets are in `themes/`, and the installer is in `scripts/install-themes.ps1`.

| Theme label | Extension ID | Pack folder |
|---|---|---|
| Neon Balanced Dark | `testa.neon-balanced-theme` | `themes/testa.neon-balanced-theme-0.0.1` |
| Neon Pink Balanced Dark V3 | `testa.neon-pink-balanced-theme-v3` | `themes/testa.neon-pink-balanced-theme-v3-0.0.1` |
| Matrix Agent Dark | `testa.matrix-agent-theme` | `themes/testa.matrix-agent-theme-0.0.1` |

For these themes, prefer running the bundled installer (see [Re-add saved theme](#re-add-saved-theme)).

---

## Install Workflow (new or custom theme)

### 1. Create extension folder

Cursor loads user extensions from **`%USERPROFILE%\.cursor\extensions`** (not `%APPDATA%\Cursor\extensions`).

```
%USERPROFILE%\.cursor\extensions\<publisher>.<theme-id>-<version>\
```

### 2. Create `package.json`

Required fields:

```json
{
  "name": "<theme-id>",
  "displayName": "<Theme Label>",
  "publisher": "<publisher>",
  "version": "0.0.1",
  "engines": { "vscode": "^1.80.0" },
  "categories": ["Themes"],
  "contributes": {
    "themes": [{
      "label": "<Theme Label>",
      "uiTheme": "vs-dark",
      "path": "./themes/<theme-file>.json"
    }]
  },
  "__metadata": {
    "installedTimestamp": <unix-ms>,
    "targetPlatform": "undefined",
    "size": 10000
  }
}
```

### 3. Create theme file at `themes/<theme-file>.json`

Minimum structure:

```json
{
  "$schema": "vscode://schemas/color-theme",
  "name": "<Theme Label>",
  "type": "dark",
  "semanticHighlighting": true,
  "colors": { ... },
  "tokenColors": [ ... ]
}
```

### 4. Create `.vsixmanifest` in extension root

Copy structure from any existing theme manifest, replacing `Id`, `DisplayName`, `Description`.

### 5. Register in `%USERPROFILE%\.cursor\extensions\extensions.json`

Add entry (match the exact shape of existing entries). Use the real resolved path under `.cursor\extensions` for `fsPath`, `external`, and `path`:

```json
{
  "identifier": { "id": "<publisher>.<theme-id>" },
  "version": "0.0.1",
  "location": {
    "$mid": 1,
    "fsPath": "C:\\Users\\<user>\\.cursor\\extensions\\<folder>",
    "_sep": 1,
    "external": "file:///c%3A/Users/<user>/.cursor/extensions/<folder>",
    "path": "/c:/Users/<user>/.cursor/extensions/<folder>",
    "scheme": "file"
  },
  "relativeLocation": "<folder>",
  "metadata": { "installedTimestamp": <unix-ms>, "pinned": true, "source": "vsix" }
}
```

### 6. Validate & reload

- Check JSON validity of `package.json`, theme file, and `extensions.json`.
- Run `Developer: Reload Window` in Cursor.
- Verify theme appears in `File -> Preferences -> Themes -> Color Themes`.

---

## Re-add Saved Theme

For themes already bundled in this skill, run from the skill folder:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\install-themes.ps1
```

To add only one theme, extend `scripts/install-themes.ps1` with its folder and extension entry and run again.
