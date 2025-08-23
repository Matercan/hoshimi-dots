import QtQuick
import Quickshell
import qs.functions as F
import QtQuick.Layouts as L
import Quickshell.Hyprland as H

MouseArea {
    id: workspaceDelegate
    required property int activeWorkspaceId
    required property int idNum

    width: Math.max(windowContent.width + 16, 40)
    height: 24

    Rectangle {
        property int id: workspaceDelegate.idNum
        property bool isActive: id === workspaceDelegate.activeWorkspaceId

        width: Math.max(windowContent.width + 16, 40)
        height: 24
        radius: 10

        color: {
            if (isActive) {
                return F.Colors.transparentize(F.Colors.activeColor, 0.8);
            } else if (workspaceDelegate) {
                return F.Colors.transparentize(F.Colors.selectedColor, 0.8);
            } else {
                return "transparent";
            }
        }

        Text {
            id: windowContent
            anchors.centerIn: parent
            text: F.Desktop.getWorkspaceIcon(parent.id)

            font.family: "CaskaydiaCove Nerd Font"
            font.pixelSize: 16

            color: parent.isActive ? F.Colors.foregroundColor : F.Colors.activeColor
        }
    }

    hoverEnabled: true

    onClicked: {
        H.Hyprland.dispatch("workspace " + idNum);
    }
}
