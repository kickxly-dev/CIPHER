@echo off
echo Building Cipher Application...

REM Create build directory
if not exist "build" mkdir build

REM Compile with g++ (requires MinGW-w64)
echo Compiling source files...

g++ -std=c++17 -O2 -DWIN32 -D_WIN32_WINNT=0x0A00 ^
    -Isrc ^
    -Isrc/utils ^
    src/main.cpp ^
    -o build/Cipher.exe ^
    -static-libgcc -static-libstdc++ ^
    -luser32 -lgdi32 -lshell32 -ladvapi32 -lcomdlg32 -lole32 -loleaut32 ^
    -lpdh -lpowrprof -lshlwapi -lpsapi -lwinmm -lcomctl32 -luuid

if exist "build\Cipher.exe" (
    echo.
    echo ✓ Build successful! Executable created at: build\Cipher.exe
    echo.
    echo Creating config directory and default files...
    if not exist "build\config" mkdir build\config
    
    echo {"version": "1.0.0", "theme": "dark", "panels_visible": "true"} > build\config\settings.json
    echo {"shortcuts": []} > build\config\shortcuts.json
    echo {"history": []} > build\config\clipboard.json
    echo {"content": "Welcome to Cipher!"} > build\config\notes.json
    
    echo ✓ Configuration files created
    echo.
    echo To run the application:
    echo   cd build
    echo   Cipher.exe
    echo.
    echo Press ESC to exit the application when running.
) else (
    echo.
    echo ✗ Build failed! 
    echo Make sure you have MinGW-w64 installed.
    echo Download from: https://www.mingw-w64.org/downloads/
    echo Or install via MSYS2: pacman -S mingw-w64-x86_64-gcc
)

pause
