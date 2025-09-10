pragma ComponentBehavior: Bound
// WorkspaceWidget.qml
import QtQuick
import Quickshell.Io
import qs.globals as G
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

        Repeater {

            model: Desktop.workspaces
            delegate: WorkspaceItem {
                id: mainItem
                required property var modelData
                activeWorkspaceId: Desktop.activeWorkspace.id
                idNum: modelData.id
            }
        }
    }
}
