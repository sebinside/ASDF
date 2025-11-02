## Paste icon from clipboard shortcut

### Feature Description

Since Stream Deck software 6.9, it is possible to paste an icon from the clipboard. 
However, there is no shortcut to do so. 
This feature adds the shortcut `Ctrl+Shift+V` to paste an icon from the clipboard.

### Usage

Install [AutoHotkey v2](https://www.autohotkey.com/) and run the script in this folder.
This adds the shortcut `Ctrl+Shift+V` to paste an icon from the clipboard in the Stream Deck software.
It checks first if an icon is selected and if the clipboard contains an image or path to an image file.

> [!NOTE]  
> This feature extends the Stream Deck software GUI. Thus, it may not work with other/newer versions which can always introduce changes to GUI layout and position. Furthermore, DPI scaling, albeit implemented, may be imprecise, due to Windows being Windows. Adjust the values used in the script as needed.
