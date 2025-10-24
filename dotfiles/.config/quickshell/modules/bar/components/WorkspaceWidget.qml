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

    RowLayout {
        id: layout
        spacing: 10
        anchors.centerIn: parent

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
                Layout.preferredWidth: {
                    if (modelData == Desktop.activeWorkspace?.id ?? 0) {
                        return 20;
                    }
                    return 10;
                }
                Layout.preferredHeight: 10
                radius: width / 2
                required property int modelData

                color: {
                    if (modelData === Desktop.activeWorkspace?.id ?? 0) {
                        return Colors.palette.m3primary;
                    }

                    return Colors.palette.m3surfaceDim;
                }

                Behavior on color {
                    ColorAnimation {
                        duration: MaterialEasing.emphasizedTime
                        easing.bezierCurve: MaterialEasing.emphasized
                    }
                }

                Behavior on Layout.preferredWidth {
                    Anims.EmphAnim {}
                }
            }
        }
    }
}
