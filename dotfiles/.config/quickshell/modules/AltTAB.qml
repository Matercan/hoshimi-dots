pragma ComponentBehavior: Bound
import Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell.Hyprland
import Quickshell.Io

import qs.sources
import qs.functions as F

import qs.globals

PanelWindow {
    id: root
    color: "transparent"
    width: layout.width
    height: 100 * 3
    visible: true

    IpcHandler {
        target: "at"

        function enable(): void {
            root.visible = true;
        }
        function hide(): void {
            root.visible = false;
        }
        function toggle(): void {
            root.visible = !root.visible;
        }
    }

    Rectangle {
        implicitWidth: parent.width
        implicitHeight: parent.height
        anchors.centerIn: parent
        color: "transparent"

        GridLayout {
            id: layout
            implicitWidth: parent.width
            implicitHeight: parent.height
            columns: 4
            rowSpacing: 10
            columnSpacing: 10

            Repeater {
                model: Desktop.workspaces
                delegate: Rectangle {
                    id: workspace
                    required property var modelData

                    // Set explicit size for workspace container
                    Layout.preferredWidth: 200
                    Layout.preferredHeight: 100
                    color: "transparent"
                    border.color: F.Colors.borderColor
                    border.width: 1
                    radius: 4

                    layer.enabled: true
                    layer.effect: MultiEffect {
                        shadowEnabled: true
                        shadowColor: F.Colors.borderColor
                        shadowBlur: 1
                        shadowOpacity: 0.5
                    }

                    GridLayout {
                        anchors.fill: parent
                        anchors.margins: 5
                        columns: 2 // Define columns for window icons within workspace
                        rowSpacing: 2
                        columnSpacing: 2

                        Repeater {
                            model: F.Desktop.getWindowsInWorkspace(workspace.modelData.id)
                            delegate: Rectangle {
                                id: window
                                required property var modelData

                                // Set explicit size for window container
                                Layout.preferredWidth: workspace.width / 5
                                Layout.preferredHeight: width
                                color: "transparent"
                                Layout.alignment: Qt.AlignHCenter

                                Image {
                                    id: icon
                                    source: Variables.iconDirectory + F.Desktop.appropriate(window.modelData.className, window.modelData.title) + ".svg"
                                    Layout.alignment: Qt.AlignHCenter

                                    anchors.fill: parent
                                    fillMode: Image.PreserveAspectFit
                                    mipmap: true
                                    smooth: true
                                }

                                MouseArea {
                                    id: area
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor

                                    onClicked: {
                                        Hyprland.dispatch("workspace " + window.modelData.workspace);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
