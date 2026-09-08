import QtQuick

import "../core"

Item {
    id: root

    anchors.fill: parent

    property bool hovered: false

    function handleHoverChanged(isHovered) {

        root.hovered = isHovered

        if (IslandState.modal)
            return

        if (isHovered) {

            collapseTimer.stop()

            if (
                (IslandState.mode === IslandState.mediaControlsMode ||
                IslandState.mode === IslandState.controlCenterMode) &&
                IslandState.islandPinned
            )
                return

            expandTimer.restart()

        } else {

            expandTimer.stop()

            if (
                IslandState.mode === IslandState.mediaControlsMode ||
                IslandState.mode === IslandState.controlCenterMode
            ) {

                if (!IslandState.islandPinned)
                    collapseTimer.restart()

                return
            }

            if (!IslandState.islandPinned)
                collapseTimer.restart()
        }
    }

    MouseArea {
        anchors.fill: parent

        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onClicked: function(mouse) {

            if (IslandState.modal)
                return

            if (mouse.button === Qt.RightButton) {
                let rightSectionWidth = 90
                let rightMargin = 14
                let rightSectionStart = root.width - rightSectionWidth - rightMargin
                let midPoint = rightSectionStart + rightSectionWidth / 2

                if (mouse.x >= rightSectionStart) {
                    if (mouse.x > midPoint)
                        IslandController.openWifi()
                    else
                        IslandController.openBluetooth()
                } else {
                    IslandController.openBluetooth()
                }
                return
            }

            if (IslandState.mode === IslandState.controlCenterMode)
                return

            if (
                IslandState.ignoreNextIslandTap &&
                IslandState.mode === IslandState.mediaControlsMode
            ) {

                IslandController.clearIgnoredTap()

                expandTimer.stop()
                collapseTimer.stop()

                return
            }

            IslandController.togglePin()

            if (IslandState.islandPinned) {

                expandTimer.stop()
                collapseTimer.stop()

                if (
                    IslandState.mode !==
                    IslandState.mediaControlsMode
                ) {
                    IslandController.openExpanded()
                }

            } else {

                if (!root.hovered)
                    collapseTimer.restart()
            }
        }
    }

    Timer {
        id: expandTimer

        interval: 100
        repeat: false

        onTriggered: {

            if (
                IslandState.mode === IslandState.mediaControlsMode &&
                IslandState.islandPinned
            )
                return

            if (IslandState.modal)
                return

            IslandController.openExpanded()
        }
    }

    Timer {
        id: collapseTimer

        interval: 250
        repeat: false

        onTriggered: {

            if (
                IslandState.mode === IslandState.mediaControlsMode ||
                IslandState.mode === IslandState.controlCenterMode
            ) {

                if (IslandState.returnToExpanded) {

                    IslandController.restoreExpanded()

                } else {

                    IslandController.reset()
                }

                return
            }

            IslandController.reset()
        }
    }
}