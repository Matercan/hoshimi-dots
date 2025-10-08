pragma ComponentBehavior: Bound
import QtQuick
import Quickshell.Services.SystemTray
import Quickshell
import Qt5Compat.GraphicalEffects

import qs.generics
import qs.functions
import qs.globals

Rectangle {
    id: root

    required property var popupY

    property var bar: root.QsWindow.window
    required property var modelData
    property SystemTrayItem item: modelData

    width: trayIcon.width + 4
    height: trayIcon.height + 4
    radius: width / 2

    color: {
        if (mouseArea.containsMouse) {
            return Colors.selectedColor;
        } else {
            return "transparent";
        }
    }

    Image {
        id: trayIcon
        width: 30
        height: 30
        sourceSize.width: width
        sourceSize.height: height
        anchors.centerIn: parent

        source: Colors.light ? Variables.osuDirectory + "/palette12.png" : Variables.osuDirectory + "/palette1.png"

        Image {
            id: sysTrayIcon
            anchors.centerIn: parent
            width: 10
            height: 10
            sourceSize.width: width
            sourceSize.height: height
            source: root.item.icon
            fillMode: Image.PreserveAspectFit
            visible: true
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
                break;
            case Qt.RightButton:
                menuOpener.open();
                break;
            }

            event.accepted = true;
        }
    }

    QsMenuAnchor {
        id: menuOpener
        menu: root.item.menu

        anchor.window: root.bar
        anchor.rect.x: Variables.barSize
        anchor.rect.y: root.popupY
        anchor.rect.height: root.height
        anchor.rect.width: root.width
    }

    // Tooltip
    PanelWindow {
        id: tooltip
        property bool varShow: false
        property bool fullyOpen: false
        visible: rect.varShow

        anchors {
            top: true
            left: true
        }

        color: "transparent"

        margins {
            top: root.popupY
            left: 5
        }

        implicitWidth: rect.width
        implicitHeight: rect.height

        PopupBox {
            id: rect
            root: tooltip
            fullyOpen: tooltip.fullyOpen
            varShow: mouseArea.containsMouse && root.item.title.length > 0
            radius: 10
            implicitWidth: layout.width + 2
            implicitHeight: layout.height + 2

            Rectangle {
                id: layout
                implicitHeight: tooltipText.implicitHeight + 15
                implicitWidth: tooltipText.implicitWidth + 5
                color: "transparent"

                Text {
                    id: tooltipText
                    anchors.centerIn: parent
                    text: root.item.title
                    color: Colors.foregroundColor
                    font.family: Variables.fontFamily
                    font.pixelSize: 10
                }
            }
        }
    }
}
