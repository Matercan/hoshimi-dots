import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import Qt5Compat.GraphicalEffects

import qs.functions as F
import qs.globals

Image {
    id: icon
    required property var modelData
    source: Variables.iconDirectory + F.Desktop.appropriate(modelData.className, modelData.title) + ".svg" || Variables.iconDirectory + "help-about" + ".svg"

    mipmap: true
    smooth: true
    Layout.preferredHeight: 20
    Layout.preferredWidth: 20

    Rectangle {
        property bool hasNotification: F.Desktop.getNotifications(icon.modelData.title) != 0
        anchors.left: parent.left
        anchors.top: parent.top
        implicitHeight: 7
        implicitWidth: Math.max(7, notifText.width + 5)
        radius: implicitWidth / 2
        color: hasNotification ? F.Colors.backgroundColor : "transparent"
        border.width: 1
        border.color: hasNotification ? F.Colors.borderColor : "transparent"

        Text {
            id: notifText
            anchors.centerIn: parent
            text: {
                if (F.Desktop.getNotifications(icon.modelData.title) == 9)
                    return "9";
                else
                    return F.Desktop.getNotifications(icon.modelData.title);
            }
            font.pixelSize: icon.height / 2
            color: parent.hasNotification ? F.Colors.getPaletteColor("blue") : "transparent"
        }
    }

    Rectangle {
        anchors.centerIn: parent
        implicitHeight: parent.height + 4
        implicitWidth: parent.width + 4
        radius: 8
        color: area.containsMouse ? F.Colors.transparentize(F.Colors.selectedColor, 0.8) : "transparent"

        MouseArea {
            id: area
            hoverEnabled: true
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: Hyprland.dispatch("focuswindow class:" + icon.modelData.className)
        }
    }

    ColorOverlay {
        anchors.fill: icon
        source: icon
        color: F.Colors.transparentize(F.Colors.foregroundColor, 0.7) // make things more readable
    }
}
