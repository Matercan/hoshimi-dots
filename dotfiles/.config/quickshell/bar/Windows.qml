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
                delegate: WindowItem {}
            }
        }
    }
}
