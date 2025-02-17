@echo off
cd /d "D:\Projects\catfish\Catfish\Catfish.PatchRunner"

:menu
echo ==========================================
echo             Catfish Menu
echo ==========================================
echo [1] CatfishManagement
echo [2] Update
echo ==========================================
set /p choice=Enter your choice: 

if "%choice%"=="1" goto management
if "%choice%"=="2" goto update

echo Invalid choice. Please try again.
pause
goto menu

:management
if exist .\bin\Release\Settings.txt (
	del .\bin\Release\Settings.txt
    )

    
        copy D:\SettingsTxt\CatfishManagement\Settings.txt D:\Projects\catfish\Catfish\Catfish.PatchRunner\bin\Release
        powershell write-host -fore Cyan Copied Settings.txt file.
    

    cd /d ".\bin\Release"
    cls
    start /B /wait Catfish.PatchRunner.exe task catfishmanagement
    pause
) else (
    cls
    powershell write-host -fore Red Error: bin/Release folder does not exist. Try to build your project first.
    pause
)


:update
if exist .\bin\Release\Settings.txt (
	del .\bin\Release\Settings.txt
    )

        copy D:\SettingsTxt\Update\Settings.txt D:\Projects\catfish\Catfish\Catfish.PatchRunner\bin\Release
        powershell write-host -fore Cyan Copied Settings.txt file.
    

    cd /d ".\bin\Release"
    cls
    start /B /wait Catfish.PatchRunner.exe update
    pause
) else (
    cls
    powershell write-host -fore Red Error: bin/Release folder does not exist. Try to build your project first.
    pause
)
