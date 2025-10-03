pragma ComponentBehavior: Bound
import QtQuick
import qs.globals
import qs.functions
import qs.sources
import Quickshell.Hyprland
import QtQuick.Layouts
import Quickshell

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
                property string idStr: (modelData + 1).toString()

                Image {
                    anchors.fill: parent
                    sourceSize.width: width
                    sourceSize.height: height
                    source: {
                        if (area.containsMouse)
                            return Quickshell.env("HOME") + "/.local/share/hoshimi/assets/osuGen/palette3-" + (container.modelData + 1).toString() + ".png";

                        const matchingWorkspace = Desktop.workspaces.find(wk => wk.id === container.modelData + 1);

                        if (matchingWorkspace) {
                            if (matchingWorkspace.id === Desktop.activeWorkspace.id)
                                return Quickshell.env("HOME") + "/.local/share/hoshimi/assets/osuGen/palette3-" + (container.modelData + 1).toString() + ".png";
                            else
                                return Quickshell.env("HOME") + "/.local/share/hoshimi/assets/osuGen/palette5-" + (container.modelData + 1).toString() + ".png";
                        }

                        return Quickshell.env("HOME") + "/.local/share/hoshimi/assets/osuGen/palette1-" + (container.modelData + 1).toString() + ".png";
                    }
                    smooth: true
                    mipmap: true

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
