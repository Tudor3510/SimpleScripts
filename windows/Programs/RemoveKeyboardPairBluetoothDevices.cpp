#include <windows.h>

#include <shellapi.h>
#pragma comment(lib, "Shell32.lib")

#include <Bthsdpdef.h>
#include <BluetoothAPIs.h>
#pragma comment(lib, "Bthprops.lib")

#include <iostream>

const unsigned long long MAGIC_KEYBOARD_ADDRESS = 0x9C583CF269B9;
const char* BLUETOOTH_URI = "ms-settings:bluetooth";
const short TIME_TO_SLEEP = 2;              //in seconds
const short S_TO_MS = 1000;

int main()
{
    BLUETOOTH_ADDRESS_STRUCT bt_add_keyboard = {MAGIC_KEYBOARD_ADDRESS};

    DWORD result = BluetoothRemoveDevice(&bt_add_keyboard);

    if (result == ERROR_SUCCESS)
        std::cout << "Keyboard was removed";
    else
        std::cout << "Keyboard was not removed. Error code: " << result;

    std::cout << "\n";

    ShellExecuteA(NULL, "open", BLUETOOTH_URI, NULL, NULL, SW_SHOWNORMAL);

    Sleep(TIME_TO_SLEEP * S_TO_MS);

    return 0;
}