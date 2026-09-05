import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Io

import "../styles"
import "../core"
import "../services"

FocusScope {
    id: root

    implicitWidth: 500
    implicitHeight: 460

    focus: true

    property var networks: []
    property int selectedIndex: 0
    property bool scanning: false

    Component.onCompleted: {
        loadNetworks()
        Qt.callLater(function() {
            listView.forceActiveFocus()
        })
    }

    onActiveFocusChanged: {
        if (activeFocus)
            listView.forceActiveFocus()
    }

    function loadNetworks() {
        networks = []
        selectedIndex = 0
        scanProcess.running = true
    }

    Process {
        id: scanProcess

        command: ["nmcli", "-t", "-f", "ACTIVE,SIGNAL,SSID,SECURITY", "dev", "wifi"]

        stdout: StdioCollector {
            onStreamFinished: {
                let lines = text.trim().split("\n")
                let result = []
                let connectedIndex = -1

                for (let i = 0; i < lines.length; i++) {
                    let line = lines[i].trim()
                    if (line.length === 0) continue

                    let parts = line.split(":")
                    let active = parts[0] === "yes"
                    let signal = Number(parts[1])
                    let ssid = parts.slice(2, -1).join(":")
                    let security = parts[parts.length - 1]

                    if (ssid.length === 0) continue

                    result.push({
                        ssid: ssid,
                        signal: signal,
                        security: security,
                        active: active
                    })

                    if (active) connectedIndex = i
                }

                root.networks = result
                if (connectedIndex >= 0)
                    root.selectedIndex = connectedIndex
            }
        }
    }

    Process {
        id: actionProcess

        onExited: {
            Qt.callLater(loadNetworks)
        }
    }

    function connectNetwork(ssid) {
        actionProcess.command = ["nmcli", "dev", "wifi", "connect", ssid]
        actionProcess.running = true
    }

    function disconnectNetwork() {
        actionProcess.command = ["nmcli", "dev", "disconnect", "wlan0"]
        actionProcess.running = true
    }

    function startScan() {
        root.scanning = true
        actionProcess.command = ["nmcli", "dev", "wifi", "rescan"]
        actionProcess.running = true
        Qt.callLater(function() {
            refreshTimer.restart()
        })
    }

    Timer {
        id: refreshTimer
        interval: 3000
        repeat: false
        onTriggered: {
            root.scanning = false
            Qt.callLater(loadNetworks)
        }
    }

    function signalIcon(strength) {
        if (strength >= 80) return "󰤨"
        if (strength >= 60) return "󰤥"
        if (strength >= 40) return "󰤢"
        if (strength >= 20) return "󰤟"
        return "󰤯"
    }

    Column {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 12

        RowLayout {
            width: parent.width
            height: 30

            Text {
                text: "Wi-Fi"
                color: Theme.textPrimary
                font.pixelSize: 20
                font.bold: true
            }

            Item { Layout.fillWidth: true }

            Text {
                visible: scanning || WifiService.connected
                text: scanning ? "Scanning..." : (WifiService.connected ? WifiService.ssid : "Disconnected")
                color: Theme.textMuted
                font.pixelSize: 13
            }

            Rectangle {
                id: scanBtn
                Layout.preferredWidth: 70
                Layout.preferredHeight: 26
                radius: 8
                color: scanning ? Theme.accent : Theme.surfaceVariant

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        if (!scanning)
                            startScan()
                    }
                }

                Text {
                    anchors.centerIn: parent
                    text: scanning ? "Wait" : "Refresh"
                    color: Theme.textPrimary
                    font.pixelSize: 12
                    font.bold: true
                }
            }
        }

        Rectangle {
            width: parent.width
            height: 36
            radius: 10
            color: WifiService.connected ? Theme.accent : Theme.surfaceVariant

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: WifiService.toggle()
            }

            Text {
                anchors.centerIn: parent
                text: WifiService.connected ? "Disconnect" : "Turn On"
                color: Theme.textPrimary
                font.pixelSize: 13
                font.bold: true
            }
        }

        ListView {
            id: listView

            width: parent.width
            height: parent.height - 90

            clip: true
            interactive: true
            focus: true
            boundsBehavior: Flickable.StopAtBounds

            model: root.networks

            currentIndex: root.selectedIndex

            spacing: 4

            delegate: Rectangle {
                width: listView.width
                height: 50
                radius: 10

                color: index === listView.currentIndex
                    ? Theme.accent
                    : (modelData.active ? Theme.surfaceVariant : Theme.surface)

                border.width: 1
                border.color: index === listView.currentIndex
                    ? Theme.accent
                    : "transparent"

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 10

                    Text {
                        text: signalIcon(modelData.signal)
                        color: index === listView.currentIndex
                            ? Theme.background
                            : Theme.icon
                        font.family: Theme.iconFont
                        font.pixelSize: 18
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2

                        Text {
                            text: modelData.ssid
                            color: index === listView.currentIndex
                                ? Theme.background
                                : Theme.textPrimary
                            font.pixelSize: 13
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                        }

                        Text {
                            text: modelData.security.length > 0 ? modelData.security : "Open"
                            color: index === listView.currentIndex
                                ? Theme.background
                                : Theme.textMuted
                            font.pixelSize: 11
                        }
                    }

                    Text {
                        text: modelData.signal + "%"
                        color: index === listView.currentIndex
                            ? Theme.background
                            : Theme.textMuted
                        font.pixelSize: 12
                    }

                    Rectangle {
                        Layout.preferredWidth: 60
                        Layout.preferredHeight: 26
                        radius: 8
                        color: modelData.active ? Theme.surfaceVariant : Theme.accent

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if (modelData.active)
                                    disconnectNetwork()
                                else
                                    connectNetwork(modelData.ssid)
                            }
                        }

                        Text {
                            anchors.centerIn: parent
                            text: modelData.active ? "Connected" : "Connect"
                            color: Theme.textPrimary
                            font.pixelSize: 10
                            font.bold: true
                        }
                    }
                }
            }

            ScrollBar.vertical: ScrollBar {
                policy: ScrollBar.AsNeeded
            }
        }
    }

    Keys.onPressed: function(event) {
        switch (event.key) {
        case Qt.Key_Escape:
            IslandController.reset()
            event.accepted = true
            break

        case Qt.Key_Up:
        case Qt.Key_K:
            if (root.selectedIndex > 0)
                root.selectedIndex--
            event.accepted = true
            break

        case Qt.Key_Down:
        case Qt.Key_J:
            if (root.selectedIndex < listView.count - 1)
                root.selectedIndex++
            event.accepted = true
            break

        case Qt.Key_Return:
        case Qt.Key_Enter:
            if (root.selectedIndex >= 0 && root.selectedIndex < listView.count) {
                let item = listView.model[root.selectedIndex]
                if (item.active)
                    disconnectNetwork()
                else
                    connectNetwork(item.ssid)
            }
            event.accepted = true
            break

        case Qt.Key_R:
            loadNetworks()
            event.accepted = true
            break
        }
    }
}
