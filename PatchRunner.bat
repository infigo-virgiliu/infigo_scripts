@echo off
setlocal enabledelayedexpansion

REM ==========================================
REM Configuration Section - Edit these paths for your PC
REM ==========================================
set "PROJECT_ROOT=D:\Projects\catfish"
set "SETTINGS_BASE=%~dp0SettingsTxt"
set "CATFISH_ROOT=D:\Projects\Catfish"

REM ==========================================
REM Derived paths (automatically calculated)
REM ==========================================
set "PATCHRUNNER_PATH=%PROJECT_ROOT%\Catfish\Catfish.PatchRunner"
set "PATCHRUNNER_BIN=%PATCHRUNNER_PATH%\bin\Release"
set "SETTINGS_MANAGEMENT=%SETTINGS_BASE%\CatfishManagement\Settings.txt"
set "SETTINGS_UPDATE=%SETTINGS_BASE%\Update\Settings.txt"
set "PLUGINS_PATH=%PROJECT_ROOT%\Catfish\Presentation\Nop.Web\Plugins"
set "CSV_PATH=%PROJECT_ROOT%\Catfish\Catfish.PatchUpdates\TextResource\English.csv"
set "BUILD_SCRIPT=%CATFISH_ROOT%\Build-Catfish.bat"
set "MEGAEDIT_BUILD=%PROJECT_ROOT%\Catfish\Libraries\Catfish.MegaEditBuild\bin\Release"
set "MEGAEDIT_VERSION=2.3.0.0"
set "CATFISH_WEB=%PROJECT_ROOT%\Catfish\Presentation\Nop.Web"

REM ==========================================
REM Main Menu Loop
REM ==========================================
:menu
cls
echo ==========================================
echo             Catfish Menu
echo ==========================================
echo     Patch Runner
echo [1]   - CatfishManagement
echo [2]   - Update
echo [3]   - Hard Code Clean
echo [4]   - Remove English.csv duplicates
echo [5]   - MegaEdit Build (ME2k)
echo [6]   - Exit
echo ==========================================
set /p choice=Enter your choice:

if "%choice%"=="1" goto management
if "%choice%"=="2" goto update
if "%choice%"=="3" goto hardcodeclean
if "%choice%"=="4" goto removeduplicates
if "%choice%"=="5" goto megaeditbuild
if "%choice%"=="6" goto exit

echo Invalid choice. Please try again.
pause
goto menu

REM ==========================================
REM CatfishManagement Function
REM ==========================================
:management
cls
echo Running CatfishManagement...

REM Check if PatchRunner bin directory exists
if not exist "%PATCHRUNNER_BIN%" (
    echo Error: %PATCHRUNNER_BIN% does not exist. Try to build your project first.
    pause
    goto menu
)

REM Remove existing Settings.txt if it exists
if exist "%PATCHRUNNER_BIN%\Settings.txt" (
    del "%PATCHRUNNER_BIN%\Settings.txt"
)

REM Copy Settings.txt for CatfishManagement
if exist "%SETTINGS_MANAGEMENT%" (
    copy "%SETTINGS_MANAGEMENT%" "%PATCHRUNNER_BIN%"
    powershell write-host -fore Cyan "Copied Settings.txt file for CatfishManagement."
) else (
    echo Error: Settings file not found at %SETTINGS_MANAGEMENT%
    pause
    goto menu
)

REM Run CatfishManagement
cd /d "%PATCHRUNNER_BIN%"
start /B /wait Catfish.PatchRunner.exe task catfishmanagement
echo CatfishManagement completed.
pause
goto menu

REM ==========================================
REM Update Function
REM ==========================================
:update
cls
echo Running Update...

REM Check if PatchRunner bin directory exists
if not exist "%PATCHRUNNER_BIN%" (
    echo Error: %PATCHRUNNER_BIN% does not exist. Try to build your project first.
    pause
    goto menu
)

REM Remove existing Settings.txt if it exists
if exist "%PATCHRUNNER_BIN%\Settings.txt" (
    del "%PATCHRUNNER_BIN%\Settings.txt"
)

REM Copy Settings.txt for Update
if exist "%SETTINGS_UPDATE%" (
    copy "%SETTINGS_UPDATE%" "%PATCHRUNNER_BIN%"
    powershell write-host -fore Cyan "Copied Settings.txt file for Update."
) else (
    echo Error: Settings file not found at %SETTINGS_UPDATE%
    pause
    goto menu
)

REM Run Update
cd /d "%PATCHRUNNER_BIN%"
start /B /wait Catfish.PatchRunner.exe update -translations
echo Update completed.
pause
goto menu

REM ==========================================
REM Hard Code Clean Function
REM ==========================================
:hardcodeclean
cls
echo Hard Code Clean Options:
echo [1] Full hard delete
echo [2] Soft delete (plugins only)
set /p cleanchoice=Enter your choice (1 or 2):

if "%cleanchoice%"=="1" goto fullharddelete
if "%cleanchoice%"=="2" goto softdelete

echo Invalid choice. Please try again.
pause
goto hardcodeclean

:fullharddelete
cls
echo Running Full hard delete...
if exist "%BUILD_SCRIPT%" (
    cd /d "%CATFISH_ROOT%"
    call "%BUILD_SCRIPT%" hardcoreclean
    echo Full hard delete completed.
) else (
    echo Error: Build script not found at %BUILD_SCRIPT%
)
pause
goto menu

:softdelete
cls
echo Running Soft delete (deleting plugins only)...
if exist "%PLUGINS_PATH%" (
    powershell -Command "Remove-Item '%PLUGINS_PATH%\*' -Recurse -Force -ErrorAction SilentlyContinue"
    echo All plugins in the folder have been deleted.
) else (
    echo The plugins folder does not exist: %PLUGINS_PATH%
)
pause
goto menu

REM ==========================================
REM Remove Duplicates Function
REM ==========================================
:removeduplicates
cls
echo Removing English.csv duplicates...

REM Check if CSV file exists
if not exist "%CSV_PATH%" (
    echo Error: CSV file not found at %CSV_PATH%
    pause
    goto menu
)

REM Check if PatchRunner bin directory exists
if not exist "%PATCHRUNNER_BIN%" (
    echo Error: %PATCHRUNNER_BIN% does not exist. Try to build your project first.
    pause
    goto menu
)

REM Copy Settings.txt if it doesn't exist
if not exist "%PATCHRUNNER_BIN%\Settings.txt" (
    if exist "%SETTINGS_MANAGEMENT%" (
        copy "%SETTINGS_MANAGEMENT%" "%PATCHRUNNER_BIN%"
        echo Settings.txt copied to %PATCHRUNNER_BIN%
    )
)

REM Run PowerShell logic for removing duplicates
powershell -Command "& {$csvPath = '%CSV_PATH%'; if (Test-Path $csvPath) { $csvContent = Get-Content $csvPath; $duplicates = $csvContent | Group-Object { ($_ -split ',')[0].Trim().Trim([char]34) } | Where-Object { $_.Count -gt 1 }; if ($duplicates) { Write-Host 'Duplicate lines found in the CSV file:' -ForegroundColor Blue; $duplicates | ForEach-Object { Write-Host ('`t' + ($_.Group -join '`n`t')) -ForegroundColor Red }; $uniqueLines = $csvContent | Group-Object { ($_ -split ',')[0].Trim().Trim([char]34) } | ForEach-Object { $_.Group | Select-Object -First 1 }; $uniqueLines | Set-Content $csvPath; Write-Host 'Duplicates have been removed from the CSV file. Please build and rerun the patchrunner' -ForegroundColor Green } else { Write-Host 'No duplicate lines found in the CSV file.' -ForegroundColor Green } } else { Write-Host 'CSV file not found at:' $csvPath -ForegroundColor Red } }"

echo Duplicate removal completed.
pause
goto menu

REM ==========================================
REM MegaEdit Build Function
REM ==========================================
:megaeditbuild
cls
echo ==========================================
echo         MegaEdit Build (ME2k)
echo ==========================================
echo.

REM Check if MegaEditBuild exe exists
if not exist "%MEGAEDIT_BUILD%\Catfish.MegaEditBuild.exe" (
    echo Error: Catfish.MegaEditBuild.exe not found at %MEGAEDIT_BUILD%
    echo Please build the Catfish.MegaEditBuild project first.
    pause
    goto menu
)

REM Check if Catfish.Web path exists
if not exist "%CATFISH_WEB%" (
    echo Error: Catfish.Web folder not found at %CATFISH_WEB%
    pause
    goto menu
)

echo Building ME2k resources with version %MEGAEDIT_VERSION%...
echo Source: %CATFISH_WEB%
echo Output: %CATFISH_WEB%\Catfish.Web\Scripts\ME2k\dist\
echo.

cd /d "%MEGAEDIT_BUILD%"
Catfish.MegaEditBuild.exe "%CATFISH_WEB%" "%MEGAEDIT_VERSION%"

if %ERRORLEVEL% EQU 0 (
    powershell write-host -fore Green "MegaEdit build completed successfully!"
    echo.
    echo Output files:
    dir "%CATFISH_WEB%\Catfish.Web\Scripts\ME2k\dist\" /B
) else (
    powershell write-host -fore Red "MegaEdit build failed with error code %ERRORLEVEL%"
)

echo.
pause
goto menu

REM ==========================================
REM Exit Function
REM ==========================================
:exit
echo Goodbye!
exit /b 0
