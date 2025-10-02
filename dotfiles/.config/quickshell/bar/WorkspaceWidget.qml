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
                property real textPadding: 10
                required property var modelData

                Shape {
                    anchors.fill: parent
                    preferredRendererType: Shape.CurveRenderer

                    ShapePath {
                        fillColor: {
                            if (area.containsMouse)
                                return Colors.transparentize(Colors.iconColor, 0.5);

                            // Find the workspace that matches the current container
                            const matchingWorkspace = Desktop.workspaces.find(wk => wk.id === container.modelData + 1);

                            if (matchingWorkspace) {
                                // Check if this matching workspace is the active one
                                if (matchingWorkspace.id === Desktop.activeWorkspace.id)
                                    return Colors.transparentize(Colors.iconColor, 0.5);
                                else
                                    return Colors.transparentize(Colors.palette.m3secondaryFixedDim, 0.5);
                            }

                            return Colors.transparentize(Colors.palette.m3surface, 0.5);
                        }
                        strokeColor: Colors.light ? "black" : "white"
                        strokeWidth: container.padding

                        PathAngleArc {
                            centerX: (container.width - container.padding * 2) / 2
                            centerY: (container.height - container.padding * 2) / 2
                            radiusX: (container.width - container.padding * 2) / 2
                            radiusY: (container.height - container.padding * 2) / 2
                            startAngle: 0
                            sweepAngle: 360
                        }
                    }

                    Text {
                        x: parent.x + parent.width / 4
                        y: parent.y + parent.height / 2
                        text: container.modelData + 1
                        color: Colors.light ? "black" : "white"
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
