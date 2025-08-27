import QtQuick
import qs.functions as F
import qs.globals as G
import Quickshell.Hyprland as H

MouseArea {
    id: workspaceDelegate
    required property int activeWorkspaceId
    required property int idNum

    implicitWidth: G.Variables.barSize
    height: 24

    Rectangle {
        property int id: workspaceDelegate.idNum
        property bool isActive: id === workspaceDelegate.activeWorkspaceId

        anchors.verticalCenter: parent.verticalCenter
        width: Math.max(windowContent.width + 16, 40)
        height: 24
        radius: 10

        color: "transparent"

        Text {
            id: windowContent
            anchors.verticalCenter: parent.verticalCenter
            anchors.centerIn: parent
            text: F.Desktop.getWorkspaceIcon(parent.id)

            font.family: "CaskaydiaCove Nerd Font"
            font.pixelSize: 16

            color: {
                if (parent.isActive)
                    return F.Colors.foregroundColor;
                else if (workspaceDelegate.containsMouse)
                    return F.Colors.selectedColor;
                else
                    return F.Colors.activeColor;
            }
        }
    }

    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor

    onClicked: {
        H.Hyprland.dispatch("workspace " + idNum);
    }
}
