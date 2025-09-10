pragma ComponentBehavior: Bound
import QtQuick
import Quickshell.Services.SystemTray
import Quickshell

import qs.generics as Gen
import qs.functions as F
import qs.globals as G

Rectangle {
    id: root

    required property var popupY

    property var bar: root.QsWindow.window
    required property var modelData
    property SystemTrayItem item: modelData

    width: trayIcon.width + 4
    height: trayIcon.height + 4
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
        width: 15
        height: 15
        sourceSize.width: 15
        sourceSize.height: 15
        source: root.item.icon
        fillMode: Image.PreserveAspectFit

        // Fallback to text if image fails
        Text {
            anchors.centerIn: parent
            text: "?"
            visible: trayIcon.status === Image.Error
            font.family: G.Variables.fontFamily
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
        anchor.rect.x: G.Variables.barSize
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

        Gen.PopupBox {
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
                    color: F.Colors.foregroundColor
                    font.family: G.Variables.fontFamily
                    font.pixelSize: 10
                }
            }
        }
    }
}
