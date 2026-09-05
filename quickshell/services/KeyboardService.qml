import QtQuick
import Quickshell
import Quickshell.Io

import "../core"

Item {
    id: root

    property string layout: ""
    property string icon: "󰌌"

    property string lastLayout: ""

    Process {
        id: layoutReader

        running: true

        command: [
            "hyprctl",
            "-j",
            "devices"
        ]

        stdout: StdioCollector {

            onStreamFinished: {

                try {

                    let data = JSON.parse(text)

                    let keyboard = null

                    for (let i = 0; i < data.keyboards.length; i++) {
                        if (data.keyboards[i].main === true) {
                            keyboard = data.keyboards[i]
                            break
                        }
                    }

                    if (!keyboard)
                        return

                    let layouts = keyboard.layout.split(",")

                    let index = keyboard.active_layout_index

                    if (index < 0 || index >= layouts.length)
                        return

                    let layoutCode = layouts[index].trim().toUpperCase()

                    if (layoutCode.length === 0)
                        return

                    if (root.lastLayout === "") {
                        root.lastLayout = layoutCode
                        root.layout = layoutCode
                        return
                    }

                    if (layoutCode === root.lastLayout)
                        return

                    root.lastLayout = layoutCode
                    root.layout = layoutCode

                    StatusManager.show({
                        mode: "keyboard",
                        icon: root.icon,
                        title: layoutCode,
                        value: layoutCode,

                        statusWidth: 220,
                        statusHeight: 33
                    })

                } catch(e) {}
            }
        }
    }

    Timer {

        interval: 300

        running: true

        repeat: true

        onTriggered: {

            layoutReader.running = false
            layoutReader.running = true
        }
    }
}
