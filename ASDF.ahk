#Requires AutoHotkey v2.0
#SingleInstance force

A_IconTip := "ASDF"
if (FileExist("asdf.ico"))
    TraySetIcon("asdf.ico")

; Add a file named "DEBUG" in the root folder to enable auto-reload on Ctrl+Alt+Shift+L
^!+l:: {
    if(FileExist("DEBUG")) {
        Reload
    }
}

; Include all other ASDF scripts
#Include "PasteIconFromClipboard\pasteIconFromClipboard.ahk"