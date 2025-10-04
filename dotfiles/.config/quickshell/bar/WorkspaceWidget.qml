pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtMultimedia

import Quickshell.Hyprland

import qs.globals
import qs.functions
import qs.sources
import qs.globals

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
                Layout.preferredHeight: 30
                Layout.preferredWidth: 30
                required property var modelData
                property int idInt: modelData + 1
                property string idStr: idInt.toString()

                Image {
                    anchors.fill: parent
                    sourceSize.width: width
                    sourceSize.height: height
                    source: {
                        if (area.containsMouse)
                            return Variables.osuDirectory + "/palette3-" + container.idStr + ".png";

                        const matchingWorkspace = Desktop.workspaces.find(wk => wk.id === container.idInt);

                        if (matchingWorkspace) {
                            if (matchingWorkspace.id === Desktop.activeWorkspace.id)
                                return Variables.osuDirectory + "/palette3-" + container.idStr + ".png";
                            else
                                return Variables.osuDirectory + "/palette5-" + container.idStr + ".png";
                        }

                        return Variables.osuDirectory + "/palette1-" + container.idStr + ".png";
                    }
                    smooth: true
                    mipmap: true

                    MouseArea {
                        id: area
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onPressed: {
                            sfx.play();
                            Hyprland.dispatch("workspace " + container.idStr);
                        }
                    }

                    SoundEffect {
                        id: sfx
                        source: Variables.osuDirectory + "/drum-hitnormal-hitfinish.wav"
                    }
                }
            }
        }
    }
}
