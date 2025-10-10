import Quickshell
import QtQuick
import QtQuick.Layouts

import qs.globals

PanelWindow {
    anchors {
        right: true
        top: true
    }

    Notifications {
        id: notifs
    }

    margins {
        right: 15
        top: 0
    }

    mask: Region {
        height: (Config.notifs.height + Config.layout.spacing) * layout.count
        width: (Config.notifs.width)
    }

    implicitWidth: rectangle.width
    implicitHeight: rectangle.height
    color: "transparent"

    Rectangle {
        id: rectangle
        implicitWidth: layout.width
        implicitHeight: layout.height
        color: "transparent"

        ListView {
            id: layout
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            width: Config.notifs.width * Config.layout.ratios[0]
            height: Quickshell.screens[0].height
            spacing: Config.layout.spacing
            anchors.bottomMargin: -0.2 * Config.notifs.height
            anchors.horizontalCenter: parent.horizontalCenter

            model: ScriptModel {
                values: notifs.popups.filter(a => a != null)
            }

            delegate: Notification {
                id: notif
                required property int index
                expandText: area.containsMouse

                anchors.horizontalCenter: parent.horizontalCenter

                MouseArea {
                    id: area
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.WhatsThisCursor
                }

                scale: notif.expandText ? Config.layout.ratios[0] : 1

                Behavior on scale {
                    Anims.ExpAnim {}
                }

                Behavior on implicitHeight {
                    Anims.ExpAnim {}
                }
            }

            add: Transition {
                Anims.ExpAnim {
                    property: "y"
                }
            }

            remove: Transition {
                Anims.EmphAnim {
                    property: "y"
                }
            }

            displaced: Transition {
                Anims.EmphAnim {
                    property: "y"
                }
            }

            move: Transition {
                Anims.EmphAnim {
                    property: "y"
                }
            }
        }
    }
}
