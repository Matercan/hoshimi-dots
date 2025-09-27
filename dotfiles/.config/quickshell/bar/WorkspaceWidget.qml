pragma ComponentBehavior: Bound
import QtQuick
import qs.globals
import qs.functions
import qs.sources
import Quickshell.Hyprland
import QtQuick.Layouts
import QtQuick.Shapes

Rectangle {

    implicitWidth: layout.width
    implicitHeight: layout.height

    ColumnLayout {
        id: layout
        anchors.centerIn: parent
        width: Variables.barSize
        spacing: Config.padding

        Repeater {
            id: trueLayout
            Layout.fillWidth: true

            model: Desktop.workspaces[Desktop.workspaces.length - 1].id

            delegate: Item {
                id: container
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredHeight: 20
                Layout.preferredWidth: 20
                property real padding: 2
                property real textPadding: 5
                required property var modelData

                Rectangle {
                    anchors.fill: parent
                    radius: width / 2
                    color: "white"
                }
                Shape {}
                Rectangle {
                    anchors.fill: parent
                    anchors.margins: parent.padding
                    radius: width / 2
                    color: {
                        if (area.containsMouse)
                            return Colors.iconColor;
                        for (let wk of Desktop.workspaces) {
                            if (wk.id === container.modelData + 1) {
                                if (wk.id === Desktop.activeWorkspace.id)
                                    return Colors.selectedColor;
                                else
                                    return Colors.palette.m3primaryContainer;
                            }
                        }
                        return Colors.palette.m3surface;
                    }

                    Text {
                        anchors.centerIn: parent
                        text: container.modelData + 1
                        color: "white"
                        font.pixelSize: parent.width - container.textPadding
                        font.family: "CaskaydiaMono Nerd Font Propo"
                    }

                    MouseArea {
                        id: area
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: Hyprland.dispatch("workspace " + (container.modelData + 1).toString())
                    }
                }
            }
        }
    }
}
