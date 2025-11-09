#Requires AutoHotkey v2.0

applyDPIScaling(value) {
    if (A_ScreenDPI == 96) {
        return value
    } else {
        return value * A_ScreenDPI / 100
    }
}

; TODO: Move more stuff here later