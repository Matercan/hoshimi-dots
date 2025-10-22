pragma ComponentBehavior: Bound
// TrayWidget.qml
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.SystemTray

Rectangle {
    id: trayRect
    color: "transparent"

    required property var rectY

    property int margin: 10
    implicitWidth: 25
    implicitHeight: rowLayout.height + 2 * margin

    ColumnLayout {
        id: rowLayout
        anchors.centerIn: parent
        spacing: 2
        focus: true

        // Spawns tray icons using actual SystemTray
        Repeater {
            model: SystemTray.items
            delegate: TrayIcon {
                required property int index
                popupY: trayRect.rectY + 32 * index
            }
        }
    }
}
