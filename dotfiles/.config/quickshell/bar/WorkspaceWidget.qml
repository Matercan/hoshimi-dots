pragma ComponentBehavior: Bound
// WorkspaceWidget.qml
import QtQuick
import Quickshell.Io
import qs.globals
import qs.functions
import qs.sources
import QtQuick.Layouts

Rectangle {
    id: wkRect

    implicitWidth: layout.width
    implicitHeight: layout.height
    property var cursorPos: []
    property bool showPopUp

    ColumnLayout {
        id: layout
        anchors.centerIn: parent
        width: Variables.barSize
        spacing: Config.padding

        Repeater {
            id: trueLayout
            Layout.fillWidth: true

            model: Desktop.workspaces
            delegate: Rectangle {
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredHeight: 10
                Layout.preferredWidth: 10
                radius: width / 2
                color: {
                    return Colors.palette.m3primary;
                }
            }
        }
    }
}
