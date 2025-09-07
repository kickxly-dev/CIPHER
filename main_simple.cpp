#include <windows.h>
#include <string>
#include <vector>

// Window dimensions
const int WINDOW_WIDTH = 1200;
const int WINDOW_HEIGHT = 800;

// Panel structure
struct Panel {
    RECT rect;
    std::string title;
    bool visible;
    bool dragging;
    POINT dragOffset;
};

// Global variables
HWND g_hWnd;
std::vector<Panel> g_panels;
HBRUSH g_blackBrush;
HBRUSH g_crimsonBrush;
HPEN g_crimsonPen;

// Window procedure
LRESULT CALLBACK WindowProc(HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam) {
    switch (uMsg) {
        case WM_CREATE: {
            // Create panels
            Panel systemMonitor = {{50, 50, 350, 250}, "System Monitor", true, false, {0, 0}};
            Panel quickToggles = {{400, 50, 700, 250}, "Quick Toggles", true, false, {0, 0}};
            Panel appLauncher = {{750, 50, 1050, 250}, "App Launcher", true, false, {0, 0}};
            Panel clipboard = {{50, 300, 350, 500}, "Clipboard Manager", true, false, {0, 0}};
            Panel notes = {{400, 300, 700, 500}, "Notes Panel", true, false, {0, 0}};
            
            g_panels = {systemMonitor, quickToggles, appLauncher, clipboard, notes};
            
            // Create brushes and pens
            g_blackBrush = CreateSolidBrush(RGB(20, 20, 20));
            g_crimsonBrush = CreateSolidBrush(RGB(220, 20, 60));
            g_crimsonPen = CreatePen(PS_SOLID, 2, RGB(220, 20, 60));
            
            return 0;
        }
        
        case WM_PAINT: {
            PAINTSTRUCT ps;
            HDC hdc = BeginPaint(hwnd, &ps);
            
            // Fill background
            RECT clientRect;
            GetClientRect(hwnd, &clientRect);
            FillRect(hdc, &clientRect, g_blackBrush);
            
            // Draw panels
            for (const auto& panel : g_panels) {
                if (panel.visible) {
                    // Draw panel background
                    FillRect(hdc, &panel.rect, g_blackBrush);
                    
                    // Draw crimson border
                    SelectObject(hdc, g_crimsonPen);
                    SelectObject(hdc, GetStockObject(NULL_BRUSH));
                    Rectangle(hdc, panel.rect.left, panel.rect.top, panel.rect.right, panel.rect.bottom);
                    
                    // Draw title
                    SetTextColor(hdc, RGB(220, 20, 60));
                    SetBkMode(hdc, TRANSPARENT);
                    RECT titleRect = panel.rect;
                    titleRect.bottom = titleRect.top + 30;
                    DrawTextA(hdc, panel.title.c_str(), -1, &titleRect, DT_CENTER | DT_VCENTER | DT_SINGLELINE);
                    
                    // Draw content based on panel type
                    RECT contentRect = panel.rect;
                    contentRect.top += 35;
                    contentRect.left += 10;
                    contentRect.right -= 10;
                    contentRect.bottom -= 10;
                    
                    SetTextColor(hdc, RGB(200, 200, 200));
                    
                    if (panel.title == "System Monitor") {
                        DrawTextA(hdc, "CPU: 45%\nRAM: 62%\nGPU: 38°C\nProcesses: 156", -1, &contentRect, DT_LEFT | DT_TOP);
                    }
                    else if (panel.title == "Quick Toggles") {
                        DrawTextA(hdc, "🔊 Volume: 75%\n📶 WiFi: ON\n🔵 Bluetooth: ON\n☀️ Brightness: 80%", -1, &contentRect, DT_LEFT | DT_TOP);
                    }
                    else if (panel.title == "App Launcher") {
                        DrawTextA(hdc, "📁 Browsers\n🎮 Games\n🔧 Tools\n💻 Development", -1, &contentRect, DT_LEFT | DT_TOP);
                    }
                    else if (panel.title == "Clipboard Manager") {
                        DrawTextA(hdc, "📋 Recent Clips:\n• Hello World\n• C++ Code\n• GitHub Link", -1, &contentRect, DT_LEFT | DT_TOP);
                    }
                    else if (panel.title == "Notes Panel") {
                        DrawTextA(hdc, "📝 Quick Notes:\n\nWelcome to Cipher!\nFuturistic desktop app\nDrag panels to move", -1, &contentRect, DT_LEFT | DT_TOP);
                    }
                }
            }
            
            // Draw title
            SetTextColor(hdc, RGB(220, 20, 60));
            RECT titleRect = {10, 10, WINDOW_WIDTH - 10, 40};
            DrawTextA(hdc, "CIPHER v1.0 - Futuristic Desktop Application", -1, &titleRect, DT_LEFT | DT_VCENTER | DT_SINGLELINE);
            
            // Draw instructions
            SetTextColor(hdc, RGB(150, 150, 150));
            RECT instrRect = {10, WINDOW_HEIGHT - 30, WINDOW_WIDTH - 10, WINDOW_HEIGHT - 10};
            DrawTextA(hdc, "Drag panels to move • Press ESC to exit", -1, &instrRect, DT_LEFT | DT_VCENTER | DT_SINGLELINE);
            
            EndPaint(hwnd, &ps);
            return 0;
        }
        
        case WM_LBUTTONDOWN: {
            POINT pt = {LOWORD(lParam), HIWORD(lParam)};
            
            // Check if clicking on a panel
            for (auto& panel : g_panels) {
                if (panel.visible && PtInRect(&panel.rect, pt)) {
                    panel.dragging = true;
                    panel.dragOffset.x = pt.x - panel.rect.left;
                    panel.dragOffset.y = pt.y - panel.rect.top;
                    SetCapture(hwnd);
                    break;
                }
            }
            return 0;
        }
        
        case WM_LBUTTONUP: {
            for (auto& panel : g_panels) {
                panel.dragging = false;
            }
            ReleaseCapture();
            return 0;
        }
        
        case WM_MOUSEMOVE: {
            if (wParam & MK_LBUTTON) {
                POINT pt = {LOWORD(lParam), HIWORD(lParam)};
                
                for (auto& panel : g_panels) {
                    if (panel.dragging) {
                        int width = panel.rect.right - panel.rect.left;
                        int height = panel.rect.bottom - panel.rect.top;
                        
                        panel.rect.left = pt.x - panel.dragOffset.x;
                        panel.rect.top = pt.y - panel.dragOffset.y;
                        panel.rect.right = panel.rect.left + width;
                        panel.rect.bottom = panel.rect.top + height;
                        
                        InvalidateRect(hwnd, NULL, TRUE);
                        break;
                    }
                }
            }
            return 0;
        }
        
        case WM_KEYDOWN: {
            if (wParam == VK_ESCAPE) {
                PostQuitMessage(0);
            }
            return 0;
        }
        
        case WM_DESTROY: {
            // Cleanup
            DeleteObject(g_blackBrush);
            DeleteObject(g_crimsonBrush);
            DeleteObject(g_crimsonPen);
            PostQuitMessage(0);
            return 0;
        }
    }
    
    return DefWindowProc(hwnd, uMsg, wParam, lParam);
}

// Main function
int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow) {
    // Register window class
    WNDCLASSEX wc = {};
    wc.cbSize = sizeof(WNDCLASSEX);
    wc.style = CS_HREDRAW | CS_VREDRAW;
    wc.lpfnWndProc = WindowProc;
    wc.hInstance = hInstance;
    wc.hCursor = LoadCursor(NULL, IDC_ARROW);
    wc.hbrBackground = (HBRUSH)(COLOR_WINDOW + 1);
    wc.lpszClassName = L"CipherApp";
    
    if (!RegisterClassEx(&wc)) {
        MessageBox(NULL, L"Window Registration Failed!", L"Error", MB_ICONEXCLAMATION | MB_OK);
        return 0;
    }
    
    // Create window
    g_hWnd = CreateWindowEx(
        WS_EX_LAYERED | WS_EX_TOPMOST,
        L"CipherApp",
        L"Cipher v1.0 - Futuristic Desktop Application",
        WS_OVERLAPPEDWINDOW,
        CW_USEDEFAULT, CW_USEDEFAULT,
        WINDOW_WIDTH, WINDOW_HEIGHT,
        NULL, NULL, hInstance, NULL
    );
    
    if (g_hWnd == NULL) {
        MessageBox(NULL, L"Window Creation Failed!", L"Error", MB_ICONEXCLAMATION | MB_OK);
        return 0;
    }
    
    // Set window transparency
    SetLayeredWindowAttributes(g_hWnd, 0, 240, LWA_ALPHA);
    
    ShowWindow(g_hWnd, nCmdShow);
    UpdateWindow(g_hWnd);
    
    // Message loop
    MSG msg = {};
    while (GetMessage(&msg, NULL, 0, 0)) {
        TranslateMessage(&msg);
        DispatchMessage(&msg);
    }
    
    return (int)msg.wParam;
}
