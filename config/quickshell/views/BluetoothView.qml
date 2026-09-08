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

    property var devices: []
    property int selectedIndex: 0
    property bool scanning: false

    Component.onCompleted: {
        loadDevices()
        Qt.callLater(function() {
            listView.forceActiveFocus()
        })
    }

    onActiveFocusChanged: {
        if (activeFocus)
            listView.forceActiveFocus()
    }

    function loadDevices() {
        devices = []
        selectedIndex = 0
        loadAll.running = true
    }

    Process {
        id: loadAll

        command: ["sh", "-c", "bluetoothctl devices | while read -r line; do mac=$(echo \"$line\" | awk '{print $2}'); info=$(bluetoothctl info \"$mac\" 2>/dev/null); connected=$(echo \"$info\" | grep -c 'Connected: yes'); echo \"$line|$connected\"; done"]

        stdout: StdioCollector {
            onStreamFinished: {
                let lines = text.trim().split("\n")
                let result = []
                for (let i = 0; i < lines.length; i++) {
                    let line = lines[i].trim()
                    if (line.length === 0) continue
                    let parts = line.split("|")
                    let deviceLine = parts[0]
                    let connected = parts[1] === "1"
                    if (!deviceLine.startsWith("Device")) continue
                    let devParts = deviceLine.split(" ")
                    let mac = devParts[1]
                    let name = devParts.slice(2).join(" ")
                    result.push({ mac: mac, name: name, connected: connected })
                }
                root.devices = result
            }
        }
    }

    Process {
        id: scanProcess

        command: ["bluetoothctl", "--timeout", "5", "scan", "on"]

        onExited: {
            root.scanning = false
            Qt.callLater(loadDevices)
        }
    }

    Process {
        id: actionProcess

        property var pendingMac: ""

        onExited: {
            if (pendingMac.length > 0) {
                let mac = pendingMac
                pendingMac = ""
                connectAfterPair.command = ["bluetoothctl", "connect", mac]
                connectAfterPair.running = true
            } else {
                Qt.callLater(loadDevices)
            }
        }
    }

    Process {
        id: connectAfterPair

        onExited: {
            Qt.callLater(loadDevices)
        }
    }

    function connectDevice(mac) {
        actionProcess.command = ["bluetoothctl", "connect", mac]
        actionProcess.pendingMac = ""
        actionProcess.running = true
    }

    function disconnectDevice(mac) {
        actionProcess.command = ["bluetoothctl", "disconnect", mac]
        actionProcess.pendingMac = ""
        actionProcess.running = true
    }

    function pairDevice(mac) {
        actionProcess.command = ["bluetoothctl", "pair", mac]
        actionProcess.pendingMac = mac
        actionProcess.running = true
    }

    function startScan() {
        scanning = true
        scanProcess.running = true
    }

    Column {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 12

        RowLayout {
            width: parent.width
            height: 30

            Text {
                text: "Bluetooth"
                color: Theme.textPrimary
                font.pixelSize: 20
                font.bold: true
            }

            Item { Layout.fillWidth: true }

            Text {
                visible: scanning
                text: "Scanning..."
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
                    text: scanning ? "Wait" : "Scan"
                    color: Theme.textPrimary
                    font.pixelSize: 12
                    font.bold: true
                }
            }
        }

        ListView {
            id: listView

            width: parent.width
            height: parent.height - 50

            clip: true
            interactive: true
            focus: true
            boundsBehavior: Flickable.StopAtBounds

            model: root.devices

            currentIndex: root.selectedIndex

            spacing: 4

            delegate: Rectangle {
                width: listView.width
                height: 50
                radius: 10

                color: index === listView.currentIndex
                    ? Theme.accent
                    : Theme.surface

                border.width: 1
                border.color: index === listView.currentIndex
                    ? Theme.accent
                    : "transparent"

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 10

                    Rectangle {
                        Layout.preferredWidth: 30
                        Layout.preferredHeight: 30
                        radius: 6
                        color: Theme.surfaceVariant

                        Text {
                            anchors.centerIn: parent
                            text: "󰂯"
                            color: index === listView.currentIndex
                                ? Theme.background
                                : Theme.icon
                            font.family: Theme.iconFont
                            font.pixelSize: 16
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2

                        Text {
                            text: modelData.name.length > 18 ? modelData.name.substring(0, 18) + "..." : modelData.name
                            color: index === listView.currentIndex
                                ? Theme.background
                                : Theme.textPrimary
                            font.pixelSize: 13
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                        }

                        Text {
                            text: modelData.connected ? "Connected" : modelData.mac
                            color: index === listView.currentIndex
                                ? Theme.background
                                : Theme.textMuted
                            font.pixelSize: 11
                        }
                    }

                    Rectangle {
                        Layout.preferredWidth: 70
                        Layout.preferredHeight: 26
                        radius: 8
                        color: modelData.connected ? Theme.surfaceVariant : Theme.accent

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if (modelData.connected)
                                    disconnectDevice(modelData.mac)
                                else
                                    pairDevice(modelData.mac)
                            }
                        }

                        Text {
                            anchors.centerIn: parent
                            text: modelData.connected ? "Disconnect" : "Pair"
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
                if (item.connected)
                    disconnectDevice(item.mac)
                else
                    pairDevice(item.mac)
            }
            event.accepted = true
            break

        case Qt.Key_R:
            loadDevices()
            event.accepted = true
            break
        }
    }
}
