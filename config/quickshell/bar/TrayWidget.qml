pragma ComponentBehavior: Bound
// TrayWidget.qml
import QtQuick
import QtQuick.Layouts as L
import Quickshell.Services.SystemTray

import qs.functions as F

Rectangle {
    id: trayRect

    required property var rectY

    property int margin: 10
    implicitWidth: 25
    implicitHeight: rowLayout.height + 2 * margin

    // Property to store tray items
    property var trayItems: []

    property string foregroundColor: F.Colors.foregroundColor
    property string selectedColor: F.Colors.selectedColor
    property string activeColor: F.Colors.activeColor

    L.ColumnLayout {
        id: rowLayout
        anchors.centerIn: parent
        spacing: 2
        focus: true

        // Spawns tray icons using actual SystemTray
        Repeater {
            model: SystemTray.items
            delegate: TrayIcon {
                popupY: trayRect.rectY + 32
            }
        }
    }
}
