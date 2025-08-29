pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland

import qs.sources
import qs.globals
import qs.functions as F

Rectangle {
    implicitHeight: layout.height + 20
    implicitWidth: layout.width + 10
    color: F.Colors.transparentize(F.Colors.selectedColor, 1)
    radius: 15

    ColumnLayout {
        id: layout
        anchors.centerIn: parent
        spacing: 10

        Repeater {
            model: Desktop.windows
            delegate: Image {
                id: icon
                required property var modelData
                source: Variables.iconDirectory + F.Desktop.appropriate(modelData.className, modelData.title) + ".svg"
                mipmap: true
                smooth: true
                Layout.preferredHeight: 20
                Layout.preferredWidth: 20

                Rectangle {
                    property bool hasNotification: F.Desktop.getNotifications(icon.modelData.title) != 0
                    anchors.left: parent.left
                    anchors.top: parent.top
                    implicitHeight: 14
                    implicitWidth: 14
                    radius: 7
                    color: hasNotification ? F.Colors.backgroundColor : "transparent"
                    border.width: 1
                    border.color: hasNotification ? F.Colors.borderColor : "transparent"

                    Text {
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
