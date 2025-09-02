pragma ComponentBehavior: Bound
import Quickshell
import QtQuick
import QtQuick.Layouts as L

import qs.generics as Gen

PanelWindow {
    id: root
    required property var openWorkspaces
    required property var activeWorkspaceId

    anchors {
        top: true
        left: true
    }

    implicitWidth: rect.width
    implicitHeight: rect.height  // Start with 0 height
    color: "transparent"

    visible: true
    property bool varShow: false
    property bool fullyOpen: false

    Gen.PopupBox {
        id: rect
        root: root
        fullyOpen: root.fullyOpen
        varShow: root.varShow
        implicitWidth: layout.width + 2
        implicitHeight: layout.height + 2
        radius: 10

        Rectangle {
            L.ColumnLayout {
                id: layout

                Repeater {
                    model: root.openWorkspaces
                    enabled: root.fullyOpen
                    delegate: WorkspaceItem {
                        required property var modelData
                        opacity: {
                            return rect.closedAnimRunning ? 0 : 1;
                        }
                        activeWorkspaceId: root.activeWorkspaceId
                        idNum: modelData.id
                    }
                }
            }
        }
    }
}
