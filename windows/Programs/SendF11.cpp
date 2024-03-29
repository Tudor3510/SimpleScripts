#include <windows.h>

#pragma comment(lib, "user32.lib")

const static int TIME_BEFORE_KEY = 4000;
const static int TIME_KEY_IS_PRESSED = 700;

bool send_F11()
{
    // Sleep for 3 seconds before sending the key press
    Sleep(TIME_BEFORE_KEY);

    // Send the F11 key press
    INPUT input;
    input.type = INPUT_KEYBOARD;
    input.ki.wScan = 0;
    input.ki.time = 0;
    input.ki.dwExtraInfo = 0;

    // Press F11
    input.ki.wVk = VK_F11;
    input.ki.dwFlags = 0; // 0 for key press
    int result = SendInput(1, &input, sizeof(INPUT));

    if (result == 0)
        return false;

    Sleep(TIME_KEY_IS_PRESSED);

    // Release F11
    input.ki.dwFlags = KEYEVENTF_KEYUP;
    result = SendInput(1, &input, sizeof(INPUT));

    if (result == 0)
        return false;

    return true;
}

int main()
{
    send_F11();

    return 0;
}


int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow)
{
    send_F11();
    
    return 0;
}