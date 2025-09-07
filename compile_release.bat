@echo off
echo Creating Production Release Build...

REM Create release directory
if not exist "release" mkdir release
if not exist "release\Cipher" mkdir release\Cipher
if not exist "release\Cipher\config" mkdir release\Cipher\config

REM Try to find and use Visual Studio Build Tools
set "VSWHERE=%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe"
if exist "%VSWHERE%" (
    for /f "usebackq tokens=*" %%i in (`"%VSWHERE%" -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath`) do (
        set "VS_PATH=%%i"
    )
)

if defined VS_PATH (
    echo Found Visual Studio at: %VS_PATH%
    call "%VS_PATH%\VC\Auxiliary\Build\vcvars64.bat"
    
    echo Compiling optimized release build...
    cl /std:c++17 /O2 /Ox /GL /DNDEBUG /DWIN32 /D_WIN32_WINNT=0x0A00 ^
       /MT /EHsc /GS- /Gy /fp:fast ^
       /Isrc /Isrc\utils ^
       src\main.cpp ^
       /Fe:release\Cipher\Cipher.exe ^
       /link /LTCG /OPT:REF /OPT:ICF /SUBSYSTEM:WINDOWS ^
       user32.lib gdi32.lib shell32.lib advapi32.lib comdlg32.lib ole32.lib oleaut32.lib ^
       pdh.lib powrprof.lib shlwapi.lib psapi.lib winmm.lib comctl32.lib uuid.lib kernel32.lib
       
    if exist "release\Cipher\Cipher.exe" (
        echo ✓ Release build successful!
        goto :package
    ) else (
        echo ✗ Release build failed with Visual Studio
        goto :try_mingw
    )
) else (
    echo Visual Studio not found, trying MinGW...
    goto :try_mingw
)

:try_mingw
where g++ >nul 2>&1
if %errorlevel% == 0 (
    echo Compiling with MinGW (static linking)...
    g++ -std=c++17 -O3 -DNDEBUG -DWIN32 -D_WIN32_WINNT=0x0A00 ^
        -Isrc -Isrc/utils src/main.cpp ^
        -o release/Cipher/Cipher.exe ^
        -static -static-libgcc -static-libstdc++ ^
        -Wl,--subsystem,windows ^
        -luser32 -lgdi32 -lshell32 -ladvapi32 -lcomdlg32 -lole32 -loleaut32 ^
        -lpdh -lpowrprof -lshlwapi -lpsapi -lwinmm -lcomctl32 -luuid
        
    if exist "release\Cipher\Cipher.exe" (
        echo ✓ MinGW release build successful!
        goto :package
    )
)

echo ✗ No suitable compiler found for release build!
echo Please install Visual Studio Build Tools or MinGW-w64
goto :end

:package
echo.
echo Creating portable package...

REM Copy config files
copy config\*.json release\Cipher\config\ >nul 2>&1

REM Create launcher script
echo @echo off > release\Cipher\Launch_Cipher.bat
echo echo Starting Cipher Application... >> release\Cipher\Launch_Cipher.bat
echo start "" "Cipher.exe" >> release\Cipher\Launch_Cipher.bat

REM Create README for end users
echo # Cipher - Futuristic Desktop Application > release\Cipher\README.txt
echo. >> release\Cipher\README.txt
echo ## How to Run: >> release\Cipher\README.txt
echo 1. Double-click Cipher.exe >> release\Cipher\README.txt
echo 2. Or run Launch_Cipher.bat >> release\Cipher\README.txt
echo. >> release\Cipher\README.txt
echo ## Controls: >> release\Cipher\README.txt
echo - Drag panels to move them >> release\Cipher\README.txt
echo - Press ESC to exit >> release\Cipher\README.txt
echo - All settings auto-save >> release\Cipher\README.txt
echo. >> release\Cipher\README.txt
echo ## Features: >> release\Cipher\README.txt
echo - System Monitor (CPU, RAM, Temps) >> release\Cipher\README.txt
echo - Quick Toggles (Volume, WiFi, etc.) >> release\Cipher\README.txt
echo - App Launcher with shortcuts >> release\Cipher\README.txt
echo - Clipboard History Manager >> release\Cipher\README.txt
echo - Auto-saving Notes Panel >> release\Cipher\README.txt

REM Get file size
for %%A in (release\Cipher\Cipher.exe) do set "filesize=%%~zA"
set /a "filesizeMB=%filesize% / 1048576"

echo.
echo ✓ Portable package created in: release\Cipher\
echo ✓ Executable size: %filesize% bytes (~%filesizeMB% MB)
echo.
echo Package contents:
dir release\Cipher\ /b
echo.
echo Ready for distribution! Users can:
echo 1. Download the Cipher folder
echo 2. Run Cipher.exe directly
echo 3. No installation or compiler needed!

:end
pause
