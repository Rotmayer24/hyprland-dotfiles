pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property var bars: []

    property bool shouldRun: true
    property int restartDelay: 1000
    property int maxRestartDelay: 10000

    Process {
        id: cava

        running: false

        command: [
            "cava",
            "-p",
            Quickshell.env("HOME") + "/.config/quickshell/scripts/cava.conf"
        ]

        stdout: SplitParser {
            splitMarker: "\n"

            onRead: function(line) {

                if (line.trim().length === 0)
                    return

                const values = line.trim().split(";")
                const parsed = []

                for (let i = 0; i < values.length; ++i) {
                    if (values[i] !== "")
                        parsed.push(Number(values[i]))
                }

                root.bars = parsed
                root.restartDelay = 1000
            }
        }

       

        onExited: function(exitCode, exitStatus) {

            root.bars = []

            if (root.shouldRun) {
                restartTimer.interval = root.restartDelay
                restartTimer.restart()

                root.restartDelay = Math.min(
                    root.restartDelay * 2,
                    root.maxRestartDelay
                )
            }
                
        }
    }

    Timer {
        id: startupTimer

        interval: 1000
        repeat: false
        running: true

        onTriggered: {
            cava.running = true
        }
    }

    Timer {
        id: restartTimer

        interval: 1000
        repeat: false

        onTriggered: {

            if (!root.shouldRun)
                return

            cava.running = false
            cava.running = true
        }
    }
}