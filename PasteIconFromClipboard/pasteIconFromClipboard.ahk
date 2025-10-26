#Requires AutoHotkey v2.0
#SingleInstance force
streamDeckWinTitle := "ahk_exe StreamDeck.exe"
sideBarSize := 281

#HotIf WinActive(streamDeckWinTitle)
^+v:: {
    CoordMode("Mouse", "Screen")
    CoordMode("Pixel", "Screen")

    WinGetPos(&windowX, &windowY, &windowWidth, &windowHeight, streamDeckWinTitle)
    darkLinePosition := getDarkLine(windowX, windowY, windowWidth, windowHeight)

    if (!isIconSelected(windowX, windowWidth, darkLinePosition)) {
        return
    }

    mouseClickOnPasteFromClipboardButton(windowX, windowY, windowWidth, windowHeight, darkLinePosition)
}
#HotIf

isIconSelected(windowX, windowWidth, darkLinePosition) {
    selectedIconLineDelta := 51
    selectedIconLineColor := 0x414141

    lineX := windowX + (windowWidth - sideBarSize) / 2
    lineY := darkLinePosition[2] + selectedIconLineDelta

    return PixelGetColor(lineX, lineY) = selectedIconLineColor
}

getDarkLine(windowX, windowY, windowWidth, windowHeight) {
    searchDeltaX := 30
    searchDeltaY := 50
    darkLineColor := 0x222222

    PixelSearch(&darkLineX, &darkLineY, windowX + searchDeltaX, windowY + searchDeltaY, windowX + searchDeltaX, windowY +
        windowHeight - searchDeltaY, darkLineColor)

    return [darkLineX, darkLineY]
}

mouseClickOnPasteFromClipboardButton(windowX, windowY, windowWidth, windowHeight, darkLinePosition) {
    deltaSettingsButtonX := 180
    deltaSettingsButtonY := 80
    deltaPasteButtonY := 60
    positionSettingsButtonX := windowX + (windowWidth - sideBarSize) / 2 - deltaSettingsButtonX
    positionSettingsButtonY := darkLinePosition[2] + deltaSettingsButtonY

    MouseClick(, positionSettingsButtonX, positionSettingsButtonY)
    Sleep(250)

    ; TODO: Reicht noch nicht aus
    isImage := DllCall("IsClipboardFormatAvailable", "uint", 2)    ; CF_BITMAP
    || DllCall("IsClipboardFormatAvailable", "uint", 8)    ; CF_DIB

    MsgBox isImage ? "Zwischenablage enthält ein Bild." : "Kein Bild in der Zwischenablage."

    return

    menuOverlayColor := 0x3C3C3C
    menuOverlayDelta := 110

    ; TODO: Zwischenablage prüfen anstatt größe und das auch früher
    if (PixelGetColor(positionSettingsButtonX, positionSettingsButtonY + menuOverlayDelta) = menuOverlayColor) {
        MouseClick(, positionSettingsButtonX, positionSettingsButtonY + deltaPasteButtonY)
    } else {
        MouseClick(, positionSettingsButtonX + 20, positionSettingsButtonY)
    }
}
