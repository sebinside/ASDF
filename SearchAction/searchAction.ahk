#Requires AutoHotkey v2.0
#SingleInstance force
#Include ..\lib.ahk

A_IconTip := "ASDF: Search Action"
if (FileExist("../asdf.ico"))
    TraySetIcon("../asdf.ico")

streamDeckWinTitle := "ahk_exe StreamDeck.exe"

#HotIf WinActive(streamDeckWinTitle)
^f:: {
    CoordMode("Mouse", "Screen")
    CoordMode("Pixel", "Screen")

    WinGetPos(&windowX, &windowY, &windowWidth, &windowHeight, streamDeckWinTitle)
    mouseClickOnSearchTextField(windowX, windowY, windowWidth, windowHeight)
}
#HotIf

mouseClickOnSearchTextField(windowX, windowY, windowWidth, windowHeight) {
    BlockInput("MouseMove")
    MouseGetPos(&mouseX, &mouseY)

    positionBoxX := windowX + windowWidth - applyDPIScaling(200)
    positionBoxY := windowY + applyDPIScaling(50)
    MouseClick(, positionBoxX, positionBoxY)

    MouseMove(mouseX, mouseY, 0)
    BlockInput("MouseMoveOff")
}

; TODO: Add readme