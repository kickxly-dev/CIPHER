# PowerShell script to create standalone Cipher executable
Write-Host "Building Standalone Cipher Application..." -ForegroundColor Cyan

# Create directories
New-Item -ItemType Directory -Force -Path "standalone" | Out-Null
New-Item -ItemType Directory -Force -Path "standalone\Cipher" | Out-Null
New-Item -ItemType Directory -Force -Path "standalone\Cipher\config" | Out-Null

# Check for compilers
$compiler = $null
$compilerArgs = @()

# Try Visual Studio first
if (Get-Command "cl.exe" -ErrorAction SilentlyContinue) {
    Write-Host "Found Visual Studio compiler" -ForegroundColor Green
    $compiler = "cl.exe"
    $compilerArgs = @(
        "/std:c++17", "/O2", "/MT", "/DNDEBUG", "/DWIN32", "/D_WIN32_WINNT=0x0A00",
        "/EHsc", "/GS-", "/Gy", "/fp:fast",
        "/Isrc", "/Isrc\utils",
        "src\main.cpp",
        "/Fe:standalone\Cipher\Cipher.exe",
        "/link", "/SUBSYSTEM:WINDOWS", "/OPT:REF", "/OPT:ICF",
        "user32.lib", "gdi32.lib", "shell32.lib", "advapi32.lib", "comdlg32.lib",
        "ole32.lib", "oleaut32.lib", "pdh.lib", "powrprof.lib", "shlwapi.lib",
        "psapi.lib", "winmm.lib", "comctl32.lib", "uuid.lib", "kernel32.lib"
    )
}
# Try MinGW
elseif (Get-Command "g++.exe" -ErrorAction SilentlyContinue) {
    Write-Host "Found MinGW compiler" -ForegroundColor Green
    $compiler = "g++.exe"
    $compilerArgs = @(
        "-std=c++17", "-O3", "-s", "-DNDEBUG", "-DWIN32", "-D_WIN32_WINNT=0x0A00",
        "-Isrc", "-Isrc/utils", "src/main.cpp",
        "-o", "standalone/Cipher/Cipher.exe",
        "-static", "-static-libgcc", "-static-libstdc++",
        "-Wl,--subsystem,windows",
        "-luser32", "-lgdi32", "-lshell32", "-ladvapi32", "-lcomdlg32",
        "-lole32", "-loleaut32", "-lpdh", "-lpowrprof", "-lshlwapi",
        "-lpsapi", "-lwinmm", "-lcomctl32", "-luuid"
    )
}
# Try Clang
elseif (Get-Command "clang++.exe" -ErrorAction SilentlyContinue) {
    Write-Host "Found Clang compiler" -ForegroundColor Green
    $compiler = "clang++.exe"
    $compilerArgs = @(
        "-std=c++17", "-O3", "-DNDEBUG", "-DWIN32", "-D_WIN32_WINNT=0x0A00",
        "-Isrc", "-Isrc/utils", "src/main.cpp",
        "-o", "standalone/Cipher/Cipher.exe",
        "-static", "-Wl,--subsystem,windows",
        "-luser32", "-lgdi32", "-lshell32", "-ladvapi32", "-lcomdlg32",
        "-lole32", "-loleaut32", "-lpdh", "-lpowrprof", "-lshlwapi",
        "-lpsapi", "-lwinmm", "-lcomctl32", "-luuid"
    )
}

if ($compiler) {
    Write-Host "Compiling with $compiler..." -ForegroundColor Yellow
    
    # Compile
    & $compiler $compilerArgs
    
    if (Test-Path "standalone\Cipher\Cipher.exe") {
        $fileSize = (Get-Item "standalone\Cipher\Cipher.exe").Length
        $fileSizeMB = [math]::Round($fileSize / 1MB, 2)
        
        Write-Host "✓ Compilation successful!" -ForegroundColor Green
        Write-Host "  Executable size: $fileSize bytes ($fileSizeMB MB)" -ForegroundColor Gray
        
        # Copy config files
        Copy-Item "config\*.json" "standalone\Cipher\config\" -Force
        
        # Create launch script
        @"
@echo off
echo Starting Cipher...
start "" "%~dp0Cipher.exe"
"@ | Out-File "standalone\Cipher\Launch.bat" -Encoding ASCII
        
        # Create README
        @"
# Cipher v1.0 - Standalone Application

## Quick Start:
1. Double-click Cipher.exe
2. Or run Launch.bat

## Controls:
- Drag panels to move them
- Press ESC to exit
- All data auto-saves

## Features:
- System Monitor (CPU, RAM, Temps)
- Quick Toggles (Volume, WiFi, etc.)
- App Launcher with shortcuts
- Clipboard History Manager
- Auto-saving Notes Panel

## Requirements:
- Windows 10/11
- No installation needed
- Runs from any folder

Enjoy your futuristic desktop experience!
"@ | Out-File "standalone\Cipher\README.txt" -Encoding UTF8
        
        # Create ZIP package
        Write-Host "Creating distribution package..." -ForegroundColor Yellow
        Compress-Archive -Path "standalone\Cipher" -DestinationPath "Cipher_v1.0_Standalone.zip" -Force
        
        Write-Host ""
        Write-Host "✓ Standalone package ready!" -ForegroundColor Green
        Write-Host "  Location: Cipher_v1.0_Standalone.zip" -ForegroundColor Gray
        Write-Host "  Size: $((Get-Item 'Cipher_v1.0_Standalone.zip').Length / 1KB) KB" -ForegroundColor Gray
        Write-Host ""
        Write-Host "Distribution ready:" -ForegroundColor Cyan
        Write-Host "• Users download Cipher_v1.0_Standalone.zip" -ForegroundColor White
        Write-Host "• Extract anywhere" -ForegroundColor White
        Write-Host "• Run Cipher.exe - no installation needed!" -ForegroundColor White
        
    } else {
        Write-Host "✗ Compilation failed!" -ForegroundColor Red
        Write-Host "Check the error messages above." -ForegroundColor Yellow
    }
} else {
    Write-Host "✗ No C++ compiler found!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please install one of:" -ForegroundColor Yellow
    Write-Host "• Visual Studio Community (recommended)" -ForegroundColor White
    Write-Host "• MinGW-w64" -ForegroundColor White
    Write-Host "• LLVM/Clang" -ForegroundColor White
}

Write-Host ""
Write-Host "Press any key to continue..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
