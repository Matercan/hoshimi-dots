pragma ComponentBehavior: Bound
import QtQuick
import qs.globals
import qs.functions
import qs.sources
import Quickshell.Hyprland
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

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
                            return Quickshell.env("HOME") + "/.local/share/hoshimi/assets/osuGen/palette3-" + container.idStr + ".png";

                        const matchingWorkspace = Desktop.workspaces.find(wk => wk.id === container.idInt);

                        if (matchingWorkspace) {
                            if (matchingWorkspace.id === Desktop.activeWorkspace.id)
                                return Quickshell.env("HOME") + "/.local/share/hoshimi/assets/osuGen/palette3-" + container.idStr + ".png";
                            else
                                return Quickshell.env("HOME") + "/.local/share/hoshimi/assets/osuGen/palette5-" + container.idStr + ".png";
                        }

                        return Quickshell.env("HOME") + "/.local/share/hoshimi/assets/osuGen/palette1-" + container.idStr + ".png";
                    }
                    smooth: true
                    mipmap: true

                    MouseArea {
                        id: area
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            sfx.running = true, Hyprland.dispatch("workspace " + container.idStr);
                        }
                    }

                    Process {
                        id: sfx
                        running: false
                        command: ["mpv", Quickshell.env("HOME") + "/.local/share/hoshimi/assets/osuGen/drum-hitnormal-hitfinish.wav"]
                    }
                }
            }
        }
    }
}
