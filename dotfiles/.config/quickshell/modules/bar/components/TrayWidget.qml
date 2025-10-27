pragma ComponentBehavior: Bound
// TrayWidget.qml
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.SystemTray

import qs.globals
import qs.functions

Rectangle {
    id: trayRect
    color: Colors.light ? Colors.darken(Colors.palette.m3inverseSurface, 0.1) : Colors.palette.m3surfaceContainerLowest

    required property int pos
    property int margin: 5
    implicitWidth: rowLayout.width + 2 * margin
    implicitHeight: rowLayout.height + margin
    radius: implicitHeight / 2

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
