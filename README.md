# PatchRunner.bat

A batch script menu for common Catfish development tasks.

## Configuration

Edit these variables at the top of the script to match your environment:

| Variable | Description | Default |
|----------|-------------|---------|
| `PROJECT_ROOT` | Root folder of the Catfish repository | `D:\Projects\catfish` |
| `SETTINGS_BASE` | Folder containing Settings.txt files | `%~dp0SettingsTxt` (same folder as script) |
| `CATFISH_ROOT` | Catfish solution root | `D:\Projects\Catfish` |
| `MEGAEDIT_VERSION` | Version prefix for ME2k bundles | `2.3.0.0` |

### Settings Folder Structure

The `SettingsTxt` folder should contain:
```
SettingsTxt/
├── CatfishManagement/
│   └── Settings.txt
└── Update/
    └── Settings.txt
```

## Menu Options

### [1] CatfishManagement
Runs the PatchRunner with `task catfishmanagement` command. Copies the CatfishManagement Settings.txt before execution.

### [2] Update
Runs the PatchRunner with `update` command. Copies the Update Settings.txt before execution.

### [3] Hard Code Clean
Sub-menu with two options:
- **Full hard delete** - Runs `Build-Catfish.bat hardcoreclean` to clean entire build
- **Soft delete** - Deletes only the Plugins folder contents

### [4] Remove English.csv duplicates
Scans `English.csv` for duplicate localization keys and removes them, keeping only the first occurrence.

### [5] MegaEdit Build (ME2k)
Rebuilds the ME2k JavaScript/CSS bundles without rebuilding the entire .NET project. Outputs:
- `2.3.0.0-ME2k.Resource.js` - Main editor JS (~3MB)
- `2.3.0.0-ME2k.Resource.ADMIN.js` - Admin JS
- `2.3.0.0-ME2k.Resource.ADMIN.css` - Admin CSS
- `2.3.0.0-ME2k.Resource.Script.js` - Scripting JS

### [6] Exit
Closes the menu.

## Prerequisites

- **PatchRunner**: Build `Catfish.PatchRunner` project in Release mode
- **MegaEdit Build**: Build `Catfish.MegaEditBuild` project in Release mode
- **Settings files**: Create appropriate Settings.txt files in `SettingsTxt` subfolders

## Installation

Copy `PatchRunner.bat` to a convenient location (e.g., Start Menu) and create a shortcut if desired.

```cmd
copy PatchRunner.bat "C:\ProgramData\Microsoft\Windows\Start Menu\infigo_scripts\"
```
