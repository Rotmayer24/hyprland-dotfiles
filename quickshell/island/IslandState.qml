pragma Singleton

import QtQuick

QtObject {

    // =========================================================
    // MODES
    // =========================================================

    readonly property int defaultMode: 0
    readonly property int expandedMode: 1
    readonly property int powerMenuMode: 2
    readonly property int controlCenterMode: 3
    readonly property int themeSelectorMode: 4
    readonly property int wallpaperSelectorMode: 5
    readonly property int mediaControlsMode: 6
    readonly property int appLauncherMode: 7
    readonly property int clipboardMode: 8
    readonly property int bluetoothMode: 9
    readonly property int wifiMode: 10

    // =========================================================
    // STATE
    // =========================================================

    property int mode: defaultMode

    property bool islandPinned: false
    property bool returnToExpanded: false
    property bool ignoreNextIslandTap: false
    property bool barVisible: true
    property bool locked: false

    // =========================================================
    // DERIVED STATE
    // =========================================================

    readonly property bool modal:
        mode === powerMenuMode ||
        mode === themeSelectorMode ||
        mode === wallpaperSelectorMode ||
        mode === appLauncherMode ||
        mode === clipboardMode ||
        mode === bluetoothMode ||
        mode === wifiMode
}