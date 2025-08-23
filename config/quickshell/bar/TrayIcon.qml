import QtQuick
import Quickshell.Services.SystemTray
import Quickshell
import qs.functions as F

Rectangle {
    id: root

    property var bar: root.QsWindow.window
    required property SystemTrayItem modelData
    property SystemTrayItem item: modelData

    width: 24
    height: 24
    radius: 4

    color: {
        if (mouseArea.containsMouse) {
            return F.Colors.selectedColor;
        } else {
            return "transparent";
        }
    }

    Image {
        id: trayIcon
        anchors.centerIn: parent
        width: 16
        height: 16
        source: root.item.icon
        fillMode: Image.PreserveAspectFit

        // Fallback to text if image fails
        Text {
            anchors.centerIn: parent
            text: "?"
            visible: trayIcon.status === Image.Error
            font.family: "CaskaydiaCove Nerd Font"
            font.pixelSize: 12
            color: F.Colors.foregroundColor
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
                root.item.activate();
                break;
            case Qt.RightButton:
                if (root.item.hasMenu)
                    menu.open();
                break;
            }
            event.accepted = true;
        }
    }

    QsMenuAnchor {
        id: menu

        menu: root.item.menu
    }

    // Tooltip
    Rectangle {
        id: tooltip
        visible: mouseArea.containsMouse && root.item.title.length > 0
        x: parent.width / 2 - width / 2
        y: parent.height + 5
        width: tooltipText.width + 8
        height: tooltipText.height + 4
        color: F.Colors.backgroundColor
        border.color: F.Colors.foregroundColor
        border.width: 1
        radius: 4
        z: 100

        Text {
            id: tooltipText
            anchors.centerIn: parent
            text: root.item.title
            color: F.Colors.foregroundColor
            font.family: "CaskaydiaCove Nerd Font"
            font.pixelSize: 10
        }
    }
}
