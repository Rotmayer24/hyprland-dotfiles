import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Io

import "../styles"
import "../core"
import "../services"

FocusScope {
    id: root

    implicitWidth: 550
    implicitHeight: 460

    focus: true

    property var entries: []
    property int selectedIndex: 0
    property int decodeIndex: 0

    Component.onCompleted: {
        loadClipboard()
        Qt.callLater(function() {
            listView.forceActiveFocus()
        })
    }

    onActiveFocusChanged: {
        if (activeFocus)
            listView.forceActiveFocus()
    }

    function loadClipboard() {
        root.entries = []
        root.selectedIndex = 0
        root.decodeIndex = 0
        clipboardLoader.running = true
    }

    Process {
        id: clipboardLoader

        command: ["cliphist", "list"]

        stdout: StdioCollector {

            onStreamFinished: {
                let lines = text.split("\n")
                let result = []

                for (let i = 0; i < lines.length; i++) {
                    let trimmed = lines[i].trim()
                    if (trimmed.length === 0)
                        continue

                    let isImage = trimmed.indexOf("[[ binary data") !== -1

                    result.push({
                        display: trimmed,
                        raw: trimmed,
                        isImage: isImage,
                        previewPath: ""
                    })
                }

                root.entries = result
                root.decodeNextImage()
            }
        }
    }

    Process {
        id: decodeProcess

        property string outputPath: ""

        onExited: {
            if (outputPath.length > 0 && root.decodeIndex < root.entries.length) {
                let entries = root.entries.slice()
                entries[root.decodeIndex] = {
                    display: entries[root.decodeIndex].display,
                    raw: entries[root.decodeIndex].raw,
                    isImage: entries[root.decodeIndex].isImage,
                    previewPath: outputPath
                }
                root.entries = entries
            }

            root.decodeIndex++
            root.decodeNextImage()
        }
    }

    function decodeNextImage() {
        while (root.decodeIndex < root.entries.length) {
            if (root.entries[root.decodeIndex].isImage) {
                let entry = root.entries[root.decodeIndex]
                let id = entry.raw.split("\t")[0]
                let safeId = id.replace(/'/g, "'\\''")
                let path = "/tmp/cliphist_" + id.replace(/[^a-zA-Z0-9_-]/g, "_") + ".png"

                decodeProcess.outputPath = path
                decodeProcess.command = ["sh", "-c", "printf '%s' '" + safeId + "' | cliphist decode > " + path]
                decodeProcess.running = true
                return
            }

            root.decodeIndex++
        }
    }

    Process {
        id: pasteProcess

        onExited: function(exitCode, exitStatus) {
            IslandController.reset()
        }
    }

    Process {
        id: deleteProcess

        onExited: function(exitCode, exitStatus) {
            loadClipboard()
        }
    }

    function copyEntry(entry) {
        let id = entry.split("\t")[0]
        let safeId = id.replace(/'/g, "'\\''")
        pasteProcess.command = ["sh", "-c", "printf '%s' '" + safeId + "' | cliphist decode | wl-copy"]
        pasteProcess.running = true
    }

    function deleteEntry(entry) {
        let id = entry.split("\t")[0]
        let safeId = id.replace(/'/g, "'\\''")
        deleteProcess.command = ["sh", "-c", "printf '%s' '" + safeId + "' | cliphist delete"]
        deleteProcess.running = true
    }

    Column {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 12

        Row {
            width: parent.width
            height: 30

            Text {
                text: "Clipboard"
                color: Theme.textPrimary
                font.pixelSize: 20
                font.bold: true
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                text: root.entries.length + " items"
                color: Theme.textMuted
                font.pixelSize: 13
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

            model: root.entries

            currentIndex: root.selectedIndex

            spacing: 6

            delegate: Rectangle {
                width: listView.width
                height: modelData.isImage ? 100 : 50
                radius: 10

                color: index === listView.currentIndex
                    ? Theme.accent
                    : Theme.surface

                border.width: 1
                border.color: index === listView.currentIndex
                    ? Theme.accent
                    : "transparent"

                property string displayText: {
                    let text = modelData.display
                    let parts = text.split("\t")
                    return parts.length > 1 ? parts.slice(1).join("\t") : text
                }

                property bool hasPreview: modelData.isImage && modelData.previewPath.length > 0

                Row {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 10

                    Rectangle {
                        width: modelData.isImage ? 80 : 30
                        height: modelData.isImage ? 80 : 30
                        radius: 6
                        color: Theme.surfaceVariant
                        anchors.verticalCenter: parent.verticalCenter
                        clip: true

                        Image {
                            id: previewImg
                            anchors.fill: parent
                            anchors.margins: 2
                            source: hasPreview ? "file://" + modelData.previewPath : ""
                            sourceSize: Qt.size(76, 76)
                            fillMode: Image.PreserveAspectFit
                            asynchronous: true
                            cache: false
                        }

                        Text {
                            anchors.centerIn: parent
                            visible: previewImg.status !== Image.Ready
                            text: modelData.isImage ? " 󰇧 " : "󰅩"
                            color: index === listView.currentIndex
                                ? Theme.background
                                : Theme.icon
                            font.family: Theme.iconFont
                            font.pixelSize: modelData.isImage ? 24 : 16
                        }
                    }

                    Column {
                        width: parent.width - (modelData.isImage ? 100 : 50)
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 2

                        Text {
                            visible: modelData.isImage
                            text: displayText.indexOf("[[ binary data") !== -1
                                ? displayText.replace("[[ binary data ", "").replace(" ]]", "")
                                : "Image"
                            color: index === listView.currentIndex
                                ? Theme.background
                                : Theme.textSecondary
                            font.pixelSize: 11
                            elide: Text.ElideRight
                            width: parent.width
                        }

                        Text {
                            text: modelData.isImage ? "" : displayText
                            visible: !modelData.isImage
                            color: index === listView.currentIndex
                                ? Theme.background
                                : Theme.textPrimary
                            font.pixelSize: 13
                            width: parent.width
                            elide: Text.ElideRight
                            maximumLineCount: 2
                            wrapMode: Text.WordWrap
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor

                    onClicked: {
                        listView.currentIndex = index
                        root.selectedIndex = index
                        root.copyEntry(modelData.raw)
                    }

                    onDoubleClicked: {
                        listView.currentIndex = index
                        root.selectedIndex = index
                        root.deleteEntry(modelData.raw)
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
                    if (root.selectedIndex < root.entries.length - 1)
                        root.selectedIndex++
                    event.accepted = true
                    break

                case Qt.Key_Return:
                case Qt.Key_Enter:
                    if (root.selectedIndex >= 0 && root.selectedIndex < root.entries.length)
                        root.copyEntry(root.entries[root.selectedIndex].raw)
                    event.accepted = true
                    break

                case Qt.Key_D:
                    if (root.selectedIndex >= 0 && root.selectedIndex < root.entries.length) {
                        root.deleteEntry(root.entries[root.selectedIndex].raw)
                        if (root.selectedIndex >= root.entries.length)
                            root.selectedIndex = Math.max(0, root.entries.length - 1)
                    }
                    event.accepted = true
                    break
                }
            }

            ScrollBar.vertical: ScrollBar {
                policy: ScrollBar.AsNeeded
            }
        }
    }
}
