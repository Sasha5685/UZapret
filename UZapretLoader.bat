@echo off
net session >nul 2>&1 || (echo Run as administrator! & pause & exit /b)

set "DOCS=%USERPROFILE%\Documents\UZapret"
set "DESKTOP=%USERPROFILE%\Desktop"

:: 1. Удаляем старую папку в документах если она есть
if exist "%DOCS%" (
    echo Removing old UZapret folder from Documents...
    rmdir /s /q "%DOCS%" 2>nul
    if exist "%DOCS%" (
        takeown /f "%DOCS%" /r /d y >nul 2>&1
        icacls "%DOCS%" /grant "%USERNAME%":F /t >nul 2>&1
        rmdir /s /q "%DOCS%" 2>nul
    )
    echo Old folder removed.
)

:: 2. Создаем новую папку в документах
echo Creating new UZapret folder in Documents...
mkdir "%DOCS%" 2>nul

:: 3. Добавляем исключения в Defender
echo Adding Windows Defender exclusions...
powershell -Command "Add-MpPreference -ExclusionPath '%DOCS%'"
powershell -Command "Add-MpPreference -ExclusionProcess 'UZapret.exe'"

:: 4. Скачиваем exe в папку Документы
echo Downloading UZapret.exe...
powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/Sasha5685/UZapret/main/UZapret.exe' -OutFile '%DOCS%\UZapret.exe'"

:: 5. Создаем ярлык на рабочем столе
echo Creating desktop shortcut...
powershell -Command "$WScriptShell = New-Object -ComObject WScript.Shell; $Shortcut = $WScriptShell.CreateShortcut('%DESKTOP%\UZapret.lnk'); $Shortcut.TargetPath = '%DOCS%\UZapret.exe'; $Shortcut.WorkingDirectory = '%DOCS%'; $Shortcut.IconLocation = '%DOCS%\UZapret.exe'; $Shortcut.Save()"

echo.
echo ========================================
echo Installation complete!
echo ========================================
echo.
echo Program installed in: %DOCS%
echo Shortcut created on desktop: %DESKTOP%\UZapret.lnk
echo.
echo The folder in Documents has been recreated with the program.
echo.
pause
