import QtQuick

import "../styles"
import "../core"
import "../island"
import "../services"

Item {

    implicitWidth: row.implicitWidth
    implicitHeight: row.implicitHeight

    Row {
        id: row

        anchors.right: parent.right
        anchors.rightMargin: Theme.sectionGap
        anchors.verticalCenter: parent.verticalCenter

        spacing: 10

        StatusChip {
            visible: StatusManager.visible

            icon: StatusManager.icon
            title: StatusManager.title
        }

        Rectangle {
            id: pill

            color: Theme.surface
            radius: 10

            implicitWidth: icons.implicitWidth + 18
            implicitHeight: icons.implicitHeight + 10

            HoverHandler {
                cursorShape: Qt.PointingHandCursor
            }

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton
                cursorShape: Qt.PointingHandCursor

                onClicked: function(mouse) {
                    if (IslandState.mode === IslandState.controlCenterMode)
                        return

                    IslandController.openControlCenterFromRightSection()
                }
            }

            Row {
                id: icons

                anchors.centerIn: parent

                spacing: 14

                Text {
                    id: btIcon
                    text: "󰂯"
                    color: Theme.icon

                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 16
                }

                Text {
                    id: wifiIcon
                    text: WifiService.icon
                    color: Theme.icon

                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 16
                }
            }
        }
    }
}