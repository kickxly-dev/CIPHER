@echo off
echo Building Cipher Application (Simple Version)...

REM Create build directory
if not exist "build" mkdir build

REM Try to compile with any available C++ compiler
echo Attempting to compile...

REM Method 1: Try cl.exe (Visual Studio)
where cl >nul 2>&1
if %errorlevel% == 0 (
    echo Using Microsoft Visual C++ compiler...
    cl /std:c++17 /EHsc /O2 /DWIN32 /D_WIN32_WINNT=0x0A00 /Isrc /Isrc\utils src\main.cpp /Fe:build\Cipher.exe /link user32.lib gdi32.lib shell32.lib advapi32.lib comdlg32.lib ole32.lib oleaut32.lib pdh.lib powrprof.lib shlwapi.lib psapi.lib winmm.lib comctl32.lib uuid.lib
    goto :check_result
)

REM Method 2: Try g++ (MinGW)
where g++ >nul 2>&1
if %errorlevel% == 0 (
    echo Using MinGW g++ compiler...
    g++ -std=c++17 -O2 -DWIN32 -D_WIN32_WINNT=0x0A00 -Isrc -Isrc/utils src/main.cpp -o build/Cipher.exe -static-libgcc -static-libstdc++ -luser32 -lgdi32 -lshell32 -ladvapi32 -lcomdlg32 -lole32 -loleaut32 -lpdh -lpowrprof -lshlwapi -lpsapi -lwinmm -lcomctl32 -luuid
    goto :check_result
)

REM Method 3: Try clang++ (LLVM)
where clang++ >nul 2>&1
if %errorlevel% == 0 (
    echo Using Clang++ compiler...
    clang++ -std=c++17 -O2 -DWIN32 -D_WIN32_WINNT=0x0A00 -Isrc -Isrc/utils src/main.cpp -o build/Cipher.exe -luser32 -lgdi32 -lshell32 -ladvapi32 -lcomdlg32 -lole32 -loleaut32 -lpdh -lpowrprof -lshlwapi -lpsapi -lwinmm -lcomctl32 -luuid
    goto :check_result
)

echo ✗ No C++ compiler found!
echo.
echo Please install one of the following:
echo 1. Visual Studio Community: https://visualstudio.microsoft.com/vs/community/
echo 2. MinGW-w64: https://www.mingw-w64.org/downloads/
echo 3. LLVM/Clang: https://releases.llvm.org/download.html
echo.
echo Or use Windows Subsystem for Linux (WSL) with g++
goto :end

:check_result
if exist "build\Cipher.exe" (
    echo.
    echo ✓ Build successful! Executable created at: build\Cipher.exe
    echo File size: 
    dir build\Cipher.exe | find "Cipher.exe"
    echo.
    echo Creating config directory and copying default files...
    if not exist "build\config" mkdir build\config
    copy config\*.json build\config\ >nul 2>&1
    echo ✓ Configuration files copied
    echo.
    echo Ready to run! Execute:
    echo   cd build
    echo   Cipher.exe
    echo.
    echo Controls:
    echo   - Drag panels to move them
    echo   - Press ESC to exit
    echo   - All data auto-saves
) else (
    echo ✗ Build failed! Check compiler output above for errors.
)

:end
pause
