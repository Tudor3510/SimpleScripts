#include <Windows.h>
#include <string>
#include <locale>
#include <iostream>
#include <codecvt>
#include <filesystem>

#if _MSC_VER
#pragma comment (lib, "User32.lib")
#pragma comment (linker, "/subsystem:\"windows\" /entry:\"mainCRTStartup\"")
#endif

const static std::wstring FULL_PATH = L"-path";
const static std::wstring FILE_NAME = L"-filename";
const static std::wstring FILE_NAME_NO_EXTENSION = L"-filename-no-extension";

void CopyStringToClipboard(const std::wstring& str)
{
    // Open the clipboard
    if (!OpenClipboard(nullptr))
    {
        // Handle clipboard opening failure
        return;
    }

    // Empty the clipboard
    EmptyClipboard();

    // Get the required memory size for the string
    int sizeInBytes = (str.size() + 1) * sizeof(wchar_t);

    // Allocate global memory for the string
    HGLOBAL hGlobal = GlobalAlloc(GMEM_MOVEABLE, sizeInBytes);
    if (hGlobal == nullptr)
    {
        CloseClipboard();
        return;
    }

    // Lock the global memory
    wchar_t* data = static_cast<wchar_t*>(GlobalLock(hGlobal));
    if (data != nullptr)
    {
        // Copy the string to the global memory
        wcscpy_s(data, sizeInBytes, str.c_str());

        // Unlock the global memory
        GlobalUnlock(hGlobal);

        // Set the global memory to the clipboard
        SetClipboardData(CF_UNICODETEXT, hGlobal);
    }

    GlobalFree(hGlobal);

    // Close the clipboard
    CloseClipboard();
}


int main(int argc, char** argv){
    if (argc < 3 || argc > 3)
    {
        std::cerr   <<  "Incorrect arguments"   <<  "\n";
        return -1;
    }
    
    // Convert char* to wstring
    std::wstring_convert<std::codecvt_utf8_utf16<wchar_t>> converter;
    std::wstring option = converter.from_bytes(argv[1]);
    std::wstring recPath = converter.from_bytes(argv[2]);

    if (option == FULL_PATH)
    {
        CopyStringToClipboard(recPath);
    }
    if (option == FILE_NAME)
    {
        std::wstring fileName = std::filesystem::path(recPath).filename();
        CopyStringToClipboard(fileName);
    }
    if (option == FILE_NAME_NO_EXTENSION)
    {
        std::wstring fileNameWithoutExtension = std::filesystem::path(recPath).stem();
        CopyStringToClipboard(fileNameWithoutExtension);
    }

    return 0;
}