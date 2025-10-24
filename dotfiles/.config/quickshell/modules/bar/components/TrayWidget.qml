pragma ComponentBehavior: Bound
// TrayWidget.qml
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.SystemTray

import qs.globals

Rectangle {
    id: trayRect
    color: "transparent"

    required property int pos

    property int margin: 10
    implicitWidth: rowLayout.width + 2 * margin
    implicitHeight: rowLayout.height

    RowLayout {
        id: rowLayout
        anchors.centerIn: parent
        spacing: Config.layout.spacing
        focus: true

        // Spawns tray icons using actual SystemTray
        Repeater {
            model: SystemTray.items
            delegate: TrayIcon {
                visible: false

                Component.onCompleted: {
                    visible = true;
                }

                required property int index
                popupX: trayRect.pos + x - width
            }
        }
    }
}
