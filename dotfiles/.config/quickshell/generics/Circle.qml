pragma ComponentBehavior: Bound

import QtQuick

import qs.functions
import qs.globals

Item {
    id: container
    property int number: -1
    required property int paletteColor
    property string numberStr: number?.toString()

    function playSfx() {
        Sounds.drums.play("", 0.7);
    }

    function playEnter() {
        Sounds.softs.play("", 0.3);
    }

    Image {
        anchors.fill: parent
        sourceSize.width: width
        sourceSize.height: height
        smooth: true
        mipmap: true

        source: {
            if (container.number != -1) {
                return Variables.osuDirectory + "/palette" + container.paletteColor + "-" + container.numberStr + ".png";
            } else {
                return Variables.osuDirectory + "/palette" + container.paletteColor + ".png";
            }
        }

        MouseArea {
            id: area
            cursorShape: Qt.PointingHandCursor
            onPressed: Sounds.drums.play("", 0.7)
            onEntered: Sounds.softs.play("", 0.3)
        }
    }
}
