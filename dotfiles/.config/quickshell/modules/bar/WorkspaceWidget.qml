pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts

import Quickshell.Hyprland

import qs.globals
import qs.functions
import qs.services
import qs.globals
import qs.generics

Rectangle {

    implicitWidth: layout.width
    implicitHeight: layout.height

    ColumnLayout {
        id: layout
        anchors.centerIn: parent
        width: Variables.barSize
        spacing: Config.layout.padding

        Repeater {
            id: trueLayout
            Layout.fillWidth: true

            model: Desktop.workspaces[Desktop.workspaces.length - 1].id

            delegate: Circle {
                id: circle
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredHeight: area.containsMouse ? Config.icons.bigSize : Config.icons.mediumSize
                Layout.preferredWidth: height
                required property var modelData

                Behavior on Layout.preferredHeight {
                    NumberAnimation {
                        duration: MaterialEasing.expressiveEffectsTime
                        easing.type: Easing.BezierSpline
                        easing.bezierCurve: MaterialEasing.expressiveEffects
                    }
                }

                property int idInt: modelData + 1
                number: idInt
                paletteColor: {
                    if (area.containsMouse)
                        return 3;

                    const matchingWorkspace = Desktop.workspaces.find(wk => wk.id === circle.idInt);

                    if (matchingWorkspace) {
                        if (matchingWorkspace.id === Desktop.activeWorkspace.id)
                            return 3;
                        else
                            return 5;
                    }

                    return 1;
                }

                MouseArea {
                    id: area
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onPressed: {
                        Hyprland.dispatch("workspace " + circle.idInt.toString());
                        circle.playSfx();
                    }
                }
            }
        }
    }
}
