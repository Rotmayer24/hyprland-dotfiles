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

    property var apps: []
    property int selectedIndex: 0
    property int columns: 4
    property string filter: ""
    property bool searchFocused: true
    property var filteredApps: []

    Component.onCompleted: {
        searchInput.forceActiveFocus()
        searchFocused = true
        loadApps()
    }

    function loadApps() {
        root.apps = []
        appLoader.running = true
    }

    Process {
        id: appLoader

        command: [
            "bash",
            "-c",
            "find /usr/share/applications ~/.local/share/applications -name '*.desktop' -type f 2>/dev/null | while read -r f; do " +
            "name=$(grep -m1 '^Name=' \"$f\" | cut -d= -f2-); " +
            "exec=$(grep -m1 '^Exec=' \"$f\" | cut -d= -f2-); " +
            "icon=$(grep -m1 '^Icon=' \"$f\" | cut -d= -f2-); " +
            "nodisplay=$(grep -m1 '^NoDisplay=' \"$f\" | cut -d= -f2-); " +

            "[ \"$nodisplay\" = 'true' ] && continue; " +
            "[ -z \"$icon\" ] && continue; " +

            "iconpath=\"\"; " +

            "if echo \"$icon\" | grep -q '/'; then " +
            "    [ -f \"$icon\" ] && iconpath=\"$icon\"; " +
            "else " +
            "    for dir in " +
            "/usr/share/icons/hicolor/scalable/apps " +
            "/usr/share/icons/hicolor/128x128/apps " +
            "/usr/share/icons/hicolor/64x64/apps " +
            "/usr/share/icons/hicolor/48x48/apps " +
            "/usr/share/icons/hicolor/32x32/apps " +
            "/usr/share/pixmaps; do " +

            "        for ext in .svg .png .xpm; do " +
            "            [ -f \"$dir/$icon$ext\" ] && iconpath=\"$dir/$icon$ext\" && break 2; " +
            "        done; " +
            "    done; " +
            "fi; " +

            "[ -n \"$name\" ] && [ -n \"$exec\" ] && " +
            "printf '%s|%s|%s\\n' \"$name\" \"$exec\" \"$iconpath\"; " +

            "done"
        ]

        stdout: SplitParser {
            splitMarker: "\n"

            onRead: function(line) {
                if (!line || line.trim().length === 0)
                    return

                let parts = line.split("|")

                if (parts.length >= 2) {
                    let newApps = root.apps.slice()

                    newApps.push({
                        name: parts[0],
                        exec: parts[1],
                        iconPath: parts.length > 2 ? parts[2] : ""
                    })

                    root.apps = newApps
                }
            }
        }

        onExited: {
            updateFiltered()
        }
    }

    Process {
        id: launchProcess

        onExited: function(exitCode, exitStatus) {
            IslandController.reset()
        }
    }

    function updateFiltered() {
        if (filter.length === 0) {
            filteredApps = apps
            return
        }

        let lower = filter.toLowerCase()
        let result = []

        for (let i = 0; i < apps.length; i++) {
            if (apps[i].name.toLowerCase().indexOf(lower) !== -1)
                result.push(apps[i])
        }

        filteredApps = result

        if (selectedIndex >= filteredApps.length)
            selectedIndex = Math.max(0, filteredApps.length - 1)
    }

    onFilterChanged: updateFiltered()
    onAppsChanged: updateFiltered()

    function launch(execCmd) {
        let cmd = execCmd
            .replace(/%[fFuUdDnNickvm]/g, "")
            .trim()

        if (cmd.length === 0)
            return

        launchProcess.command = [
            "bash",
            "-c",
            "setsid -f bash -c " + JSON.stringify(cmd)
        ]

        launchProcess.running = true
    }

    Column {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 12

        Rectangle {
            width: parent.width
            height: 36
            radius: 10

            color: Theme.inputBackground

            border.width: 1
            border.color: searchInput.activeFocus
                ? Theme.accent
                : Theme.inputBorder

            TextInput {
                id: searchInput

                anchors.fill: parent
                anchors.margins: 10

                color: Theme.textPrimary
                selectionColor: Theme.accent

                font.pixelSize: 14
                clip: true
                focus: true

                onTextChanged: {
                    root.filter = text
                    root.selectedIndex = 0
                }

                Keys.onPressed: function(event) {
                    if (event.key === Qt.Key_Escape) {
                        IslandController.reset()
                        event.accepted = true
                        return
                    }

                    if (event.key === Qt.Key_Tab) {
                        root.searchFocused = false
                        gridView.forceActiveFocus()
                        event.accepted = true
                        return
                    }

                    if (
                        event.key === Qt.Key_Down ||
                        event.key === Qt.Key_J
                    ) {
                        root.searchFocused = false
                        gridView.forceActiveFocus()
                        event.accepted = true
                        return
                    }

                    if (
                        event.key === Qt.Key_Return ||
                        event.key === Qt.Key_Enter
                    ) {
                        if (
                            root.selectedIndex >= 0 &&
                            root.selectedIndex < root.filteredApps.length
                        ) {
                            root.launch(
                                root.filteredApps[root.selectedIndex].exec
                            )
                        }

                        event.accepted = true
                        return
                    }
                }

                Text {
                    visible:
                        searchInput.text.length === 0 &&
                        !searchInput.activeFocus

                    anchors.verticalCenter: parent.verticalCenter

                    text: "  Search apps..."

                    color: Theme.textMuted
                    font.family: Theme.iconFont
                    font.pixelSize: 14
                }
            }
        }

        Text {
            text: root.filteredApps.length + " apps"

            color: Theme.textMuted
            font.pixelSize: 12
        }

        GridView {
            id: gridView

            width: parent.width
            height: parent.height - 80

            clip: true
            interactive: true
            boundsBehavior: Flickable.StopAtBounds

            cellWidth:
                (width - 20) / root.columns

            cellHeight: 85

            model: root.filteredApps

            currentIndex: root.selectedIndex

            onCurrentIndexChanged: {
                if (root.selectedIndex !== currentIndex)
                    root.selectedIndex = currentIndex
            }

            Keys.onPressed: function(event) {
                if (event.key === Qt.Key_Escape) {
                    IslandController.reset()
                    event.accepted = true
                    return
                }

                if (event.key === Qt.Key_Tab) {
                    root.searchFocused = true
                    searchInput.forceActiveFocus()

                    event.accepted = true
                    return
                }

                if (
                    event.key === Qt.Key_Up ||
                    event.key === Qt.Key_K
                ) {
                    if (
                        root.selectedIndex - root.columns >= 0
                    ) {
                        root.selectedIndex -= root.columns
                        gridView.currentIndex = root.selectedIndex
                    } else {
                        root.searchFocused = true
                        searchInput.forceActiveFocus()
                    }

                    event.accepted = true
                    return
                }

                if (
                    event.key === Qt.Key_Down ||
                    event.key === Qt.Key_J
                ) {
                    let count = root.filteredApps.length

                    if (
                        root.selectedIndex + root.columns < count
                    ) {
                        root.selectedIndex += root.columns
                        gridView.currentIndex = root.selectedIndex
                    }

                    event.accepted = true
                    return
                }

                if (
                    event.key === Qt.Key_Left ||
                    event.key === Qt.Key_H
                ) {
                    if (root.selectedIndex % root.columns > 0) {
                        root.selectedIndex--
                        gridView.currentIndex = root.selectedIndex
                    }

                    event.accepted = true
                    return
                }

                if (
                    event.key === Qt.Key_Right ||
                    event.key === Qt.Key_L
                ) {
                    let count = root.filteredApps.length

                    if (
                        root.selectedIndex % root.columns <
                            root.columns - 1 &&
                        root.selectedIndex < count - 1
                    ) {
                        root.selectedIndex++
                        gridView.currentIndex = root.selectedIndex
                    }

                    event.accepted = true
                    return
                }

                if (
                    event.key === Qt.Key_Return ||
                    event.key === Qt.Key_Enter
                ) {
                    let count = root.filteredApps.length

                    if (
                        root.selectedIndex >= 0 &&
                        root.selectedIndex < count
                    ) {
                        root.launch(
                            root.filteredApps[root.selectedIndex].exec
                        )
                    }

                    event.accepted = true
                    return
                }
            }

            delegate: Item {
                width: gridView.cellWidth
                height: gridView.cellHeight

                Rectangle {
                    anchors.fill: parent
                    anchors.margins: 4

                    radius: 12

                    color:
                        index === gridView.currentIndex
                            ? Theme.accent
                            : Theme.surface

                    border.width: 1

                    border.color:
                        index === gridView.currentIndex
                            ? Theme.accent
                            : "transparent"

                    Column {
                        anchors.centerIn: parent
                        spacing: 6

                        Rectangle {
                            width: 40
                            height: 40

                            radius: 10

                            color:
                                index === gridView.currentIndex
                                    ? Theme.background
                                    : Theme.surfaceVariant

                            anchors.horizontalCenter:
                                parent.horizontalCenter

                            Image {
                                id: iconImg

                                anchors.fill: parent
                                anchors.margins: 4

                                source:
                                    modelData.iconPath.length > 0
                                        ? "file://" + modelData.iconPath
                                        : ""

                                sourceSize: Qt.size(32, 32)

                                fillMode: Image.PreserveAspectFit

                                asynchronous: true
                                cache: true

                                visible:
                                    status === Image.Ready
                            }

                            Text {
                                anchors.centerIn: parent

                                visible:
                                    iconImg.status !== Image.Ready

                                text:
                                    modelData.name
                                        .charAt(0)
                                        .toUpperCase()

                                color:
                                    index === gridView.currentIndex
                                        ? Theme.accent
                                        : Theme.textPrimary

                                font.pixelSize: 18
                                font.bold: true
                            }
                        }

                        Text {
                            text: modelData.name

                            color:
                                index === gridView.currentIndex
                                    ? Theme.background
                                    : Theme.textPrimary

                            font.pixelSize: 11

                            width: parent.width - 8

                            horizontalAlignment:
                                Text.AlignHCenter

                            elide:
                                Text.ElideRight

                            maximumLineCount: 2

                            wrapMode:
                                Text.WordWrap

                            anchors.horizontalCenter:
                                parent.horizontalCenter
                        }
                    }

                    MouseArea {
                        anchors.fill: parent

                        cursorShape:
                            Qt.PointingHandCursor

                        onClicked: {
                            gridView.currentIndex = index
                            root.selectedIndex = index

                            root.launch(modelData.exec)
                        }
                    }
                }
            }

            ScrollBar.vertical: ScrollBar {
                policy: ScrollBar.AsNeeded
            }
        }
    }
}
