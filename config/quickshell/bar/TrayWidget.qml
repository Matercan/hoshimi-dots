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
            Rectangle {
                id: trayItem
                required property SystemTrayItem modelData
                property SystemTrayItem item: modelData

                width: 24
                height: 24
                radius: 4

                color: {
                    if (mouseArea.containsMouse) {
                        return trayRect.selectedColor;
                    } else {
                        return "transparent";
                    }
                }

                Image {
                    id: trayIcon
                    anchors.centerIn: parent
                    width: 16
                    height: 16
                    source: trayItem.item.icon
                    fillMode: Image.PreserveAspectFit

                    // Fallback to text if image fails
                    Text {
                        anchors.centerIn: parent
                        text: "?"
                        visible: trayIcon.status === Image.Error
                        font.family: "CaskaydiaCove Nerd Font"
                        font.pixelSize: 12
                        color: trayRect.foregroundColor
                    }
                }

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    acceptedButtons: Qt.LeftButton | Qt.RightButton

                    onClicked: event => {
                        switch (event.button) {
                        case Qt.LeftButton:
                            item.activate();
                            break;
                        case Qt.RightButton:
                            if (item.hasMenu)
                                modelData.menu.open();
                            break;
                        }
                        event.accepted = true;
                    }
                }

                // Tooltip
                Rectangle {
                    id: tooltip
                    visible: mouseArea.containsMouse && trayItem.item.title.length > 0
                    x: parent.width / 2 - width / 2
                    y: parent.height + 5
                    width: tooltipText.width + 8
                    height: tooltipText.height + 4
                    color: "#1e1e2e"
                    border.color: trayRect.foregroundColor
                    border.width: 1
                    radius: 4
                    z: 100

                    Text {
                        id: tooltipText
                        anchors.centerIn: parent
                        text: trayItem.item.title
                        color: trayRect.foregroundColor
                        font.family: "CaskaydiaCove Nerd Font"
                        font.pixelSize: 10
                    }
                }
            }
        }
    }
}
