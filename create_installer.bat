@echo off
echo Creating Cipher Installer Package...

REM Create installer directory structure
if not exist "installer" mkdir installer
if not exist "installer\Cipher_v1.0" mkdir installer\Cipher_v1.0
if not exist "installer\Cipher_v1.0\config" mkdir installer\Cipher_v1.0\config

REM Check if we have a compiled EXE
if not exist "release\Cipher\Cipher.exe" (
    echo No compiled EXE found. Running release build first...
    call compile_release.bat
)

if exist "release\Cipher\Cipher.exe" (
    echo Copying files to installer package...
    
    REM Copy main executable
    copy release\Cipher\Cipher.exe installer\Cipher_v1.0\ >nul
    
    REM Copy config files
    copy config\*.json installer\Cipher_v1.0\config\ >nul
    
    REM Create installation script
    echo @echo off > installer\Cipher_v1.0\INSTALL.bat
    echo echo Installing Cipher Application... >> installer\Cipher_v1.0\INSTALL.bat
    echo echo. >> installer\Cipher_v1.0\INSTALL.bat
    echo echo Creating desktop shortcut... >> installer\Cipher_v1.0\INSTALL.bat
    echo set "desktop=%%USERPROFILE%%\Desktop" >> installer\Cipher_v1.0\INSTALL.bat
    echo set "target=%%~dp0Cipher.exe" >> installer\Cipher_v1.0\INSTALL.bat
    echo powershell "$s=(New-Object -COM WScript.Shell).CreateShortcut('%%desktop%%\Cipher.lnk'); $s.TargetPath='%%target%%'; $s.WorkingDirectory='%%~dp0'; $s.Description='Cipher - Futuristic Desktop App'; $s.Save()" >> installer\Cipher_v1.0\INSTALL.bat
    echo echo ✓ Desktop shortcut created >> installer\Cipher_v1.0\INSTALL.bat
    echo echo. >> installer\Cipher_v1.0\INSTALL.bat
    echo echo Installation complete! >> installer\Cipher_v1.0\INSTALL.bat
    echo echo Double-click the Cipher shortcut on your desktop to run. >> installer\Cipher_v1.0\INSTALL.bat
    echo pause >> installer\Cipher_v1.0\INSTALL.bat
    
    REM Create uninstaller
    echo @echo off > installer\Cipher_v1.0\UNINSTALL.bat
    echo echo Uninstalling Cipher Application... >> installer\Cipher_v1.0\UNINSTALL.bat
    echo del "%%USERPROFILE%%\Desktop\Cipher.lnk" 2^>nul >> installer\Cipher_v1.0\UNINSTALL.bat
    echo echo ✓ Desktop shortcut removed >> installer\Cipher_v1.0\UNINSTALL.bat
    echo echo You can safely delete this folder now. >> installer\Cipher_v1.0\UNINSTALL.bat
    echo pause >> installer\Cipher_v1.0\UNINSTALL.bat
    
    REM Create user manual
    echo # Cipher v1.0 - User Manual > installer\Cipher_v1.0\USER_MANUAL.txt
    echo. >> installer\Cipher_v1.0\USER_MANUAL.txt
    echo ## Installation: >> installer\Cipher_v1.0\USER_MANUAL.txt
    echo 1. Run INSTALL.bat to create desktop shortcut >> installer\Cipher_v1.0\USER_MANUAL.txt
    echo 2. Or double-click Cipher.exe directly >> installer\Cipher_v1.0\USER_MANUAL.txt
    echo. >> installer\Cipher_v1.0\USER_MANUAL.txt
    echo ## Features: >> installer\Cipher_v1.0\USER_MANUAL.txt
    echo • System Monitor - Real-time CPU, RAM, temperatures >> installer\Cipher_v1.0\USER_MANUAL.txt
    echo • Quick Toggles - Volume, WiFi, Bluetooth, Brightness >> installer\Cipher_v1.0\USER_MANUAL.txt
    echo • App Launcher - Organized shortcuts by category >> installer\Cipher_v1.0\USER_MANUAL.txt
    echo • Clipboard Manager - History with search and copy >> installer\Cipher_v1.0\USER_MANUAL.txt
    echo • Notes Panel - Auto-saving notepad >> installer\Cipher_v1.0\USER_MANUAL.txt
    echo. >> installer\Cipher_v1.0\USER_MANUAL.txt
    echo ## Controls: >> installer\Cipher_v1.0\USER_MANUAL.txt
    echo • Drag any panel to move it around >> installer\Cipher_v1.0\USER_MANUAL.txt
    echo • Press ESC key to exit application >> installer\Cipher_v1.0\USER_MANUAL.txt
    echo • All settings and data auto-save >> installer\Cipher_v1.0\USER_MANUAL.txt
    echo. >> installer\Cipher_v1.0\USER_MANUAL.txt
    echo ## System Requirements: >> installer\Cipher_v1.0\USER_MANUAL.txt
    echo • Windows 10 or later >> installer\Cipher_v1.0\USER_MANUAL.txt
    echo • 50MB free disk space >> installer\Cipher_v1.0\USER_MANUAL.txt
    echo • No additional software required >> installer\Cipher_v1.0\USER_MANUAL.txt
    
    REM Create ZIP package using PowerShell
    echo Creating ZIP package for distribution...
    powershell "Compress-Archive -Path 'installer\Cipher_v1.0' -DestinationPath 'installer\Cipher_v1.0_Portable.zip' -Force"
    
    echo.
    echo ✓ Installation package created successfully!
    echo.
    echo Distribution files:
    echo • installer\Cipher_v1.0\ (folder)
    echo • installer\Cipher_v1.0_Portable.zip (download package)
    echo.
    echo Users can now:
    echo 1. Download Cipher_v1.0_Portable.zip
    echo 2. Extract anywhere
    echo 3. Run INSTALL.bat or Cipher.exe directly
    echo 4. No compiler or installation required!
    
) else (
    echo ✗ Could not find compiled executable!
    echo Please ensure the build was successful first.
)

pause
