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

:: 5. Создаем ярлык на рабочем столе (способ 1 - VBScript)
echo Creating desktop shortcut...
(
echo Set oWS = WScript.CreateObject("WScript.Shell"^)
echo sLinkFile = "%DESKTOP%\UZapret.lnk"
echo Set oLink = oWS.CreateShortcut(sLinkFile^)
echo oLink.TargetPath = "%DOCS%\UZapret.exe"
echo oLink.WorkingDirectory = "%DOCS%"
echo oLink.IconLocation = "%DOCS%\UZapret.exe"
echo oLink.Save
) > "%temp%\create_shortcut.vbs"

cscript //nologo "%temp%\create_shortcut.vbs"
del "%temp%\create_shortcut.vbs"

:: Проверяем создался ли ярлык
if exist "%DESKTOP%\UZapret.lnk" (
    echo Shortcut created successfully!
    goto :success
)

:: 6. Если не получилось, создаем bat файл (способ 2)
echo Failed to create lnk shortcut. Creating bat file instead...
(
echo @echo off
echo start "" "%DOCS%\UZapret.exe"
) > "%DESKTOP%\UZapret.bat"

:: 7. Или создаем URL файл (способ 3)
echo Also creating URL shortcut...
(
echo [InternetShortcut]
echo URL=file:///%DOCS%\UZapret.exe
echo IconIndex=0
echo IconFile=%DOCS%\UZapret.exe
) > "%DESKTOP%\UZapret.url"


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
