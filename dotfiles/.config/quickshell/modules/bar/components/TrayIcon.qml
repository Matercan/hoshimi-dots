pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.SystemTray
import Quickshell
import Qt5Compat.GraphicalEffects

import qs.generics
import qs.functions
import qs.globals
import qs.generics

Rectangle {
    id: root

    required property var popupX

    property var bar: root.QsWindow.window
    required property var modelData
    property SystemTrayItem item: modelData

    Layout.preferredWidth: trayIcon.width + 4
    Layout.preferredHeight: trayIcon.height + 4

    radius: width / 2

    Layout.alignment: Qt.AlignHCenter

    color: {
        if (mouseArea.containsMouse) {
            return Colors.selectedColor;
        } else {
            return "transparent";
        }
    }

    Item {
        id: trayIcon
        width: 16
        height: width
        anchors.centerIn: parent

        Image {
            id: sysTrayIcon
            anchors.centerIn: parent
            width: trayIcon.width
            height: width
            sourceSize.width: width
            sourceSize.height: height
            source: root.item.icon
            fillMode: Image.PreserveAspectFit
            smooth: true
            mipmap: true
        }

        // Fallback to text if image fails
        Text {
            anchors.centerIn: parent
            text: "?"
            visible: trayIcon.status === Image.Error
            font.family: Variables.fontFamily
            font.pixelSize: 12
            color: Colors.foregroundColor
        }

        ColorOverlay {
            anchors.fill: sysTrayIcon
            source: sysTrayIcon
            color: Colors.light ? Colors.transparentize(Colors.palette.m3surface, 0.5) : Colors.transparentize(Colors.palette.m3onSurface, 0.5)
        }

        Behavior on width {
            Anims.ExpAnim {}
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
                console.log(menuOpener.menu.objectName);
                root.item.activate();
                trayIcon.playSfx();
                break;
            case Qt.RightButton:
                menuOpener.open();
                trayIcon.playEnter();
                break;
            }

            event.accepted = true;
        }
    }

    QsMenuAnchor {
        id: menuOpener
        menu: root.item.menu

        anchor.window: root.bar
        anchor.rect.x: root.popupX
        anchor.rect.y: 45
        anchor.rect.height: root.height
        anchor.rect.width: root.width
    }
}
