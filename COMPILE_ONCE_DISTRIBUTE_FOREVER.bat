@echo off
echo ========================================
echo   CIPHER - COMPILE ONCE, SHARE FOREVER
echo ========================================
echo.
echo This will create a STANDALONE EXE that users can download and run
echo NO COMPILER needed by end users!
echo.

REM Check if we can find any compiler
set FOUND_COMPILER=0

where cl >nul 2>&1
if %errorlevel% == 0 (
    echo ✓ Found Visual Studio compiler
    set FOUND_COMPILER=1
    set COMPILER=MSVC
)

if %FOUND_COMPILER% == 0 (
    where g++ >nul 2>&1
    if %errorlevel% == 0 (
        echo ✓ Found MinGW compiler
        set FOUND_COMPILER=1
        set COMPILER=MINGW
    )
)

if %FOUND_COMPILER% == 0 (
    echo ✗ No compiler found on this system
    echo.
    echo SOLUTION: Run this on ANY system with:
    echo • Visual Studio (free)
    echo • MinGW-w64 (free)
    echo • Or use GitHub Actions (automatic)
    echo.
    echo The compiled EXE will work on ALL Windows systems!
    goto :end
)

echo.
echo Compiling DISTRIBUTION-READY executable...
echo Compiler: %COMPILER%
echo.

REM Create distribution folder
if not exist "DISTRIBUTION" mkdir DISTRIBUTION

if "%COMPILER%" == "MSVC" (
    cl /std:c++17 /O2 /MT /DNDEBUG /DWIN32 /D_WIN32_WINNT=0x0A00 /EHsc /Isrc /Isrc\utils src\main.cpp /Fe:DISTRIBUTION\Cipher.exe /link /SUBSYSTEM:WINDOWS user32.lib gdi32.lib shell32.lib advapi32.lib comdlg32.lib ole32.lib oleaut32.lib pdh.lib powrprof.lib shlwapi.lib psapi.lib winmm.lib comctl32.lib uuid.lib
) else (
    g++ -std=c++17 -O3 -s -DNDEBUG -DWIN32 -D_WIN32_WINNT=0x0A00 -Isrc -Isrc/utils src/main.cpp -o DISTRIBUTION/Cipher.exe -static -static-libgcc -static-libstdc++ -Wl,--subsystem,windows -luser32 -lgdi32 -lshell32 -ladvapi32 -lcomdlg32 -lole32 -loleaut32 -lpdh -lpowrprof -lshlwapi -lpsapi -lwinmm -lcomctl32 -luuid
)

if exist "DISTRIBUTION\Cipher.exe" (
    echo.
    echo ✓ SUCCESS! Standalone EXE created
    
    REM Copy config files
    if not exist "DISTRIBUTION\config" mkdir DISTRIBUTION\config
    copy config\*.json DISTRIBUTION\config\ >nul
    
    REM Create user files
    echo # Cipher v1.0 - Ready to Run! > DISTRIBUTION\README.txt
    echo. >> DISTRIBUTION\README.txt
    echo Double-click Cipher.exe to start >> DISTRIBUTION\README.txt
    echo Press ESC to exit >> DISTRIBUTION\README.txt
    echo Drag panels to move them >> DISTRIBUTION\README.txt
    echo All settings auto-save >> DISTRIBUTION\README.txt
    
    echo @echo off > DISTRIBUTION\RUN.bat
    echo start "" "Cipher.exe" >> DISTRIBUTION\RUN.bat
    
    REM Get file info
    for %%A in (DISTRIBUTION\Cipher.exe) do set SIZE=%%~zA
    set /a SIZE_MB=%SIZE% / 1048576
    
    echo.
    echo ========================================
    echo   READY FOR DISTRIBUTION!
    echo ========================================
    echo File: DISTRIBUTION\Cipher.exe
    echo Size: %SIZE% bytes (~%SIZE_MB% MB)
    echo.
    echo USERS CAN NOW:
    echo 1. Download Cipher.exe
    echo 2. Double-click to run
    echo 3. NO INSTALLATION NEEDED!
    echo.
    echo Upload to: Google Drive, Dropbox, GitHub Releases, etc.
    echo Share the download link - that's it!
    
) else (
    echo ✗ Compilation failed
    echo Check error messages above
)

:end
pause
