cd /d "D:\Projects\catfish\Catfish\Catfish.PatchRunner"

if exist bin\ (

    if not exist .\bin\Release\Settings.txt (
        copy D:\Settings.txt D:\Projects\catfish\Catfish\Catfish.PatchRunner\bin\Release
        powershell write-host -fore Cyan Copied Settings.txt file.
    )

    cd /d ".\bin\Release"
    cls
    start /B /wait Catfish.PatchRunner.exe update
    pause
) else (
    cls
    powershell write-host -fore Red Error: bin/Release folder does not exist. Try to build your project firstly
    pause
)
