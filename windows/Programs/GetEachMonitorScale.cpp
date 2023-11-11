#include <windows.h>
#include <iostream>
#include <vector>
#include <cstdlib>


#pragma comment(lib, "gdi32.lib")
#pragma comment(lib, "user32.lib")

struct Monitor
{
    HDC monitorHdc;
    std::string monitorName;
};

void GetAllMonitorHDCs(std::vector<Monitor>& monitorArray)
{
    // Enumerate all of the monitors on the system.
    DISPLAY_DEVICEA displayDevice;
    displayDevice.cb = sizeof(displayDevice);

    // For each monitor, create a DC and add it to the array.
    int i = 0;
    while (EnumDisplayDevicesA(NULL, i, &displayDevice, 0))
    {
        if (!(displayDevice.StateFlags & DISPLAY_DEVICE_ACTIVE))
        {
            i++;
            continue;
        }

        // Create a DC for the monitor.
        HDC hdc = CreateDCA("DISPLAY", displayDevice.DeviceName, NULL, NULL);
        if (hdc != NULL)
            monitorArray.push_back({hdc, std::string(displayDevice.DeviceName)});

        i++;
    }
}


int main()
{
    std::vector<Monitor> monitors;

    GetAllMonitorHDCs(monitors);

    for (Monitor& monitor : monitors)
    {
        int LogicalScreenHeight = GetDeviceCaps(monitor.monitorHdc, VERTRES);
        int PhysicalScreenHeight = GetDeviceCaps(monitor.monitorHdc, DESKTOPVERTRES);

        if (LogicalScreenHeight == 0)
        {
            continue;
        }

        int scaling = PhysicalScreenHeight * 100 / LogicalScreenHeight;

        std::cout << "----------------------------------"
                  << "\n"
                  << monitor.monitorName << "\n"
                  << "Scale: " << scaling << "\n"
                  << "\n"
                  << "\n";
    }

    for (Monitor& monitor : monitors)
        DeleteDC(monitor.monitorHdc);

    system("pause");

    return 0;
}