pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts

import Quickshell.Hyprland
import Quickshell

import qs.functions
import qs.services
import qs.globals

Rectangle {

    implicitWidth: layout.width
    implicitHeight: layout.height
    color: "transparent"

    Row {
        id: layout
        spacing: 10
        anchors.centerIn: parent
        width: 400
        height: 35

        Repeater {
            model: ScriptModel {
                values: {
                    const lastWindow = Desktop.biggestWindow;
                    const result = [];

                    for (let i = 1; i <= lastWindow; ++i) {
                        result.push(i);
                    }
                    return result.filter(a => a != null);
                }
            }

            delegate: Rectangle {
                implicitWidth: {
                    if (modelData == Desktop.activeWorkspace?.id ?? 0) {
                        return 20;
                    }
                    if (area.containsMouse) {
                        return 20;
                    }
                    return 10;
                }
                anchors.verticalCenter: parent.verticalCenter
                implicitHeight: 10
                radius: width / 2
                required property int modelData

                color: {
                    if (modelData === Desktop.activeWorkspace?.id ?? 0) {
                        return Colors.palette.m3primary;
                    }
                    if (area.containsMouse) {
                        return Colors.palette.m3secondary;
                    }

                    return Colors.palette.m3surfaceDim;
                }

                MouseArea {
                    id: area
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: Hyprland.dispatch("workspace " + parent.modelData)
                    cursorShape: Qt.PointingHandCursor
                }

                Behavior on color {
                    ColorAnimation {
                        duration: MaterialEasing.emphasizedTime
                        easing.bezierCurve: MaterialEasing.emphasized
                    }
                }

                Behavior on implicitWidth {
                    Anims.EmphAnim {}
                }
            }
        }
    }
}
