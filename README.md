# Cipher - Production-Ready Windows Desktop Application

A futuristic, modular Windows desktop application built in C++ with a sleek black and crimson theme.

## Features

### Core Panels
- **System Monitor**: Real-time CPU, RAM, GPU temperature, process count, and system uptime
- **Quick Toggles**: Control Volume, Microphone, WiFi, Bluetooth, Brightness, and Dark Mode
- **App Launcher**: Categorized application shortcuts (Browsers, Tools, Games, Development)
- **Clipboard Manager**: Persistent clipboard history with auto-save
- **Notes Panel**: Auto-saving notes with JSON persistence

### UI Features
- Futuristic black + crimson theme with glowing borders
- Draggable and resizable panels
- Smooth animations and sharp edges
- Minimalist, clean layout
- Semi-transparent layered windows

### Technical Features
- Native Win32 C++ implementation
- No external dependencies required
- JSON configuration system
- Automatic data persistence
- Memory leak prevention
- Modular, expandable architecture

## File Structure
```
CipherApp/
├── src/
│   ├── main.cpp              # Main application entry point
│   └── utils/
│       └── json_config.h     # JSON configuration utility
├── config/
│   ├── settings.json         # Application settings
│   ├── shortcuts.json        # App launcher shortcuts
│   ├── clipboard.json        # Clipboard history
│   └── notes.json           # Notes content
├── build/                    # Compiled executable
├── assets/                   # UI graphics and icons
├── build.bat                 # Build script
└── README.md                # This file
```

## Building

### Requirements
- Windows 10/11
- MinGW-w64 (GCC compiler for Windows)

### Installation
1. Install MinGW-w64:
   - Download from: https://www.mingw-w64.org/downloads/
   - Or via MSYS2: `pacman -S mingw-w64-x86_64-gcc`

2. Build the application:
   ```cmd
   build.bat
   ```

3. Run the executable:
   ```cmd
   cd build
   Cipher.exe
   ```

## Usage

### Controls
- **Drag panels**: Click and drag any panel to move it
- **Exit application**: Press ESC key
- **Auto-save**: All settings and data are automatically saved

### Configuration
All configuration files are stored in the `config/` directory:
- Panel positions and visibility
- Application shortcuts
- Clipboard history
- Notes content
- Theme settings

### Expandability
The modular architecture supports easy addition of:
- Voice command system
- Music playback controls
- Automation routines
- Custom panel types
- Plugin system

## System Requirements
- Windows 10 or later
- 50MB free disk space
- 64MB RAM
- DirectX compatible graphics

## License
Production-ready desktop application - All rights reserved.

## Version
1.0.0 - Initial release with all Phase 1 features implemented.
