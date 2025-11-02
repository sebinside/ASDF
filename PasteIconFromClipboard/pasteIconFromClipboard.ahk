#Requires AutoHotkey v2.0
#SingleInstance force

A_IconTip := "ASDF: Paste Icon From Clipboard"
if (FileExist("../asdf.ico"))
    TraySetIcon("../asdf.ico")

streamDeckWinTitle := "ahk_exe StreamDeck.exe"
sideBarSize := applyDPIScaling(281)

#HotIf WinActive(streamDeckWinTitle)
^+v:: {
    CoordMode("Mouse", "Screen")
    CoordMode("Pixel", "Screen")

    WinGetPos(&windowX, &windowY, &windowWidth, &windowHeight, streamDeckWinTitle)
    darkLinePosition := getDarkLine(windowX, windowY, windowWidth, windowHeight)

    if (!isIconSelected(windowX, windowWidth, darkLinePosition)) {
        return
    }

    if (!isClipboardImage()) {
        return
    }

    mouseClickOnPasteFromClipboardButton(windowX, windowY, windowWidth, windowHeight, darkLinePosition)
}
#HotIf

isIconSelected(windowX, windowWidth, darkLinePosition) {
    selectedIconLineDelta := applyDPIScaling(51)
    selectedIconLineColor := 0x414141

    lineX := windowX + (windowWidth - sideBarSize) / 2
    lineY := darkLinePosition[2] + selectedIconLineDelta

    return PixelGetColor(lineX, lineY) = selectedIconLineColor
}

isClipboardImage() {
    CF_BITMAP := 2
    CF_DIB := 8
    CF_DIBV5 := 17
    CF_HDROP := 15

    isImage := DllCall("IsClipboardFormatAvailable", "UInt", CF_BITMAP)
    || DllCall("IsClipboardFormatAvailable", "UInt", CF_DIB)
    || DllCall("IsClipboardFormatAvailable", "UInt", CF_DIBV5)

    if (isImage) {
        return true
    }

    if (DllCall("IsClipboardFormatAvailable", "UInt", CF_HDROP, "Int")) {
        exts := Map(".png", true, ".jpg", true, ".jpeg", true, ".bmp", true, ".gif", true, ".tif", true, ".tiff", true)

        clipboardFiles := getClipboardTextFiles()
        if (clipboardFiles.Length != 1) {
            return false
        }

        SplitPath(clipboardFiles[1], , , &ext)
        if (exts.Has("." . StrLower(ext))) {
            return true
        }
    }

    return false
}

getClipboardTextFiles() {
    files := []
    txt := A_Clipboard
    if (txt = "")
        return files

    for rawLine in StrSplit(txt, "`n", "`r") {
        line := Trim(rawLine, ' "')
        if (!line)
            continue

        for piece in StrSplit(line, "`t;") {
            path := Trim(piece, ' "')
            if (!path)
                continue

            attrs := FileExist(path)
            if (attrs && !InStr(attrs, "D"))
                files.Push(path)
        }
    }
    return files
}

getDarkLine(windowX, windowY, windowWidth, windowHeight) {
    searchDeltaX := applyDPIScaling(30)
    searchDeltaY := applyDPIScaling(50)
    darkLineHeight := applyDPIScaling(2)
    darkLineColor := 0x222222

    PixelSearch(&darkLineX, &darkLineY, windowX + searchDeltaX, windowY + searchDeltaY, windowX + searchDeltaX, windowY +
        windowHeight - searchDeltaY, darkLineColor)

    return [darkLineX, darkLineY + darkLineHeight]
}

mouseClickOnPasteFromClipboardButton(windowX, windowY, windowWidth, windowHeight, darkLinePosition) {
    BlockInput("MouseMove")
    MouseGetPos(&mouseX, &mouseY)

    deltaSettingsButtonX := applyDPIScaling(180)
    deltaSettingsButtonY := applyDPIScaling(80)
    deltaPasteButtonY := applyDPIScaling(60)
    positionSettingsButtonX := windowX + (windowWidth - sideBarSize) / 2 - deltaSettingsButtonX
    positionSettingsButtonY := darkLinePosition[2] + deltaSettingsButtonY

    MouseClick(, positionSettingsButtonX, positionSettingsButtonY)
    Sleep(250)
    MouseClick(, positionSettingsButtonX, positionSettingsButtonY + deltaPasteButtonY)

    MouseMove(mouseX, mouseY, 0)
    BlockInput("MouseMoveOff")
}

applyDPIScaling(value) {
    if (A_ScreenDPI == 96) {
        return value
    } else {
        return Ceil(value * A_ScreenDPI / 100)
    }
}
