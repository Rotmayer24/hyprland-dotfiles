import Quickshell
import Quickshell.Io

import "../core"

IpcHandler {
    target: "luci"

    function openPowerMenu() {
        IslandController.openPowerMenu()
    }

    function openExpandedHome() {
        IslandController.openExpanded()
    }

    function reset() {
        IslandController.reset()
    }

    function openWallpaperSelector() {
        IslandController.openWallpaperSelector()
    }

    function openThemeSelector() {
        IslandController.openThemeSelector()
    }

    function openAppLauncher() {
        IslandController.openAppLauncher()
    }

    function openClipboard() {
        IslandController.openClipboard()
    }

    function openBluetooth() {
        IslandController.openBluetooth()
    }

    function openWifi() {
        IslandController.openWifi()
    }

    function toggleBar() {
        IslandController.toggleBar()
    }

    function showBar() {
        IslandController.showBar()
    }

    function lockScreen() {
        IslandController.lockScreen()
    }

    function lock() {
        IslandController.lock()
    }

    function unlock() {
        IslandController.unlock()
    }
}