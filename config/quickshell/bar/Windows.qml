pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell
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

        function appropriate(window: string): string {
            switch (window) {
            case "equibop":
                return "vesktop";
            default:
                return window;
            }
        }

        Repeater {
            model: Desktop.windows
            delegate: Image {
                id: icon
                required property var modelData
                source: Variables.iconDirectory + layout.appropriate(modelData.className) + ".svg"
                mipmap: true
                smooth: true
                Layout.preferredHeight: 16
                Layout.preferredWidth: 16

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
