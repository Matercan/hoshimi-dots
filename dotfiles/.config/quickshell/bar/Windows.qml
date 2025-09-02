pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland

import qs.sources
import qs.globals
import qs.functions as F

Rectangle {
    color: F.Colors.transparentize(F.Colors.selectedColor, 1)
    implicitWidth: 25
    implicitHeight: 300

    Rectangle {
        anchors.centerIn: parent
        implicitWidth: layout.width + 10
        implicitHeight: layout.height + 20
        color: F.Colors.transparentize(F.Colors.borderColor, 0.95)
        border.width: 1
        border.color: F.Colors.borderColor
        radius: 10

        ColumnLayout {
            id: layout
            anchors.centerIn: parent
            spacing: 20

            Repeater {
                model: Desktop.windows
                delegate: Image {
                    id: icon
                    required property var modelData
                    source: Variables.iconDirectory + F.Desktop.appropriate(modelData.className, modelData.title) + ".svg" || Variables.iconDirectory + "help-about" + ".svg"

                    mipmap: true
                    smooth: true
                    Layout.preferredHeight: 20
                    Layout.preferredWidth: 20

                    Rectangle {
                        property bool hasNotification: F.Desktop.getNotifications(icon.modelData.title) != 0
                        anchors.left: parent.left
                        anchors.top: parent.top
                        implicitHeight: 14
                        implicitWidth: Math.max(14, notifText.width + 5)
                        radius: implicitWidth / 2
                        color: hasNotification ? F.Colors.backgroundColor : "transparent"
                        border.width: 1
                        border.color: hasNotification ? F.Colors.borderColor : "transparent"

                        Text {
                            id: notifText
                            anchors.centerIn: parent
                            text: F.Desktop.getNotifications(icon.modelData.title)
                            font.pixelSize: 10
                            color: parent.hasNotification ? F.Colors.getPaletteColor("blue") : "transparent"
                        }
                    }

                    Rectangle {
                        anchors.centerIn: parent
                        implicitHeight: parent.height + 4
                        implicitWidth: parent.width + 4
                        radius: 8
                        color: area.containsMouse ? F.Colors.transparentize(F.Colors.selectedColor, 0.8) : "transparent"

                        MouseArea {
                            id: area
                            hoverEnabled: true
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: Hyprland.dispatch("focuswindow class:" + icon.modelData.className)
                        }
                    }
                }
            }
        }
    }
}
