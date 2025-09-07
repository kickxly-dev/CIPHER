@echo off
echo Building Cipher Application with MSVC...

REM Create build directory
if not exist "build" mkdir build

REM Try to find Visual Studio installation
set "VSWHERE=%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe"
if exist "%VSWHERE%" (
    for /f "usebackq tokens=*" %%i in (`"%VSWHERE%" -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath`) do (
        set "VS_PATH=%%i"
    )
)

if defined VS_PATH (
    echo Found Visual Studio at: %VS_PATH%
    call "%VS_PATH%\VC\Auxiliary\Build\vcvars64.bat"
    
    echo Compiling with MSVC...
    cl /std:c++17 /O2 /DWIN32 /D_WIN32_WINNT=0x0A00 ^
       /Isrc /Isrc\utils ^
       src\main.cpp ^
       /Fe:build\Cipher.exe ^
       /link user32.lib gdi32.lib shell32.lib advapi32.lib comdlg32.lib ole32.lib oleaut32.lib ^
       pdh.lib powrprof.lib shlwapi.lib psapi.lib winmm.lib comctl32.lib uuid.lib
       
    if exist "build\Cipher.exe" (
        echo.
        echo ✓ Build successful with MSVC! Executable created at: build\Cipher.exe
        goto :create_config
    )
) else (
    echo Visual Studio not found. Trying Windows SDK...
    
    REM Try Windows SDK
    set "SDK_PATH=%ProgramFiles(x86)%\Windows Kits\10\bin\10.0.22621.0\x64"
    if not exist "%SDK_PATH%" set "SDK_PATH=%ProgramFiles(x86)%\Windows Kits\10\bin\x64"
    
    if exist "%SDK_PATH%\cl.exe" (
        echo Found Windows SDK compiler
        "%SDK_PATH%\cl.exe" /std:c++17 /O2 /DWIN32 /D_WIN32_WINNT=0x0A00 ^
           /Isrc /Isrc\utils ^
           src\main.cpp ^
           /Fe:build\Cipher.exe ^
           /link user32.lib gdi32.lib shell32.lib advapi32.lib comdlg32.lib ole32.lib oleaut32.lib ^
           pdh.lib powrprof.lib shlwapi.lib psapi.lib winmm.lib comctl32.lib uuid.lib
           
        if exist "build\Cipher.exe" (
            echo.
            echo ✓ Build successful with Windows SDK! Executable created at: build\Cipher.exe
            goto :create_config
        )
    )
)

echo.
echo ✗ Build failed! No suitable compiler found.
echo.
echo Please install one of the following:
echo 1. Visual Studio Community (recommended): https://visualstudio.microsoft.com/vs/community/
echo 2. Build Tools for Visual Studio: https://visualstudio.microsoft.com/downloads/#build-tools-for-visual-studio-2022
echo 3. MinGW-w64: https://www.mingw-w64.org/downloads/
echo.
goto :end

:create_config
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

:end
pause
