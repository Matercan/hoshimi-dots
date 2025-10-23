import QtQuick
import Quickshell

import qs.globals
import qs.functions

Item {

    Rectangle {
        anchors.fill: parent
        radius: Config.layout.radius
        color: Colors.paletteColor2
        opacity: area.containsMouse ? 1 : 0

        Behavior on opacity {
            Anims.ExpAnim {}
        }
    }

    Image {
        anchors.centerIn: parent
        width: 0.7 * parent.width
        height: width
        source: Variables.osuIcons + "/wifi.svg"
        smooth: true
        mipmap: true
    }

    MouseArea {
        id: area
        anchors.fill: parent
        hoverEnabled: true
    }
}
