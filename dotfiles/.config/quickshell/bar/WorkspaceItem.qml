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
        property bool isActive: id == workspaceDelegate.activeWorkspaceId

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

            font.family: G.Variables.fontFamily
            font.pixelSize: 16

            color: {
                if (parent.isActive)
                    return F.Colors.activeColor;
                else if (workspaceDelegate.containsMouse)
                    return F.Colors.selectedColor;
                else
                    return F.Colors.foregroundColor;
            }
        }

        WindowItem {
            width: 10
            height: 10
            modelData: F.Desktop.getWindowsInWorkspace(workspaceDelegate.idNum)[0]
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.margins: 5
        }
    }

    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor

    onClicked: {
        H.Hyprland.dispatch("workspace " + idNum);
    }
}
