pragma ComponentBehavior: Bound
// TrayWidget.qml
import QtQuick
import QtQuick.Layouts as L
import Quickshell.Services.SystemTray

Rectangle {
    id: trayRect

    property int margin: 10
    implicitWidth: Math.max(rowLayout.width + 2 * margin, 100)

    // Property to store tray items
    property var trayItems: []

    property string foregroundColor: "#cdd6f4"
    property string selectedColor: "#cdd6f4"
    property string activeColor: "#f38ba8"

    L.RowLayout {
        id: rowLayout
        anchors.centerIn: parent
        spacing: 2
        focus: true

        // Spawns tray icons using actual SystemTray
        Repeater {
            model: SystemTray.items
            TrayIcon {}
        }
    }
}
