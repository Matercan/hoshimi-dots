pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Qt5Compat.GraphicalEffects

import qs.globals
import qs.functions
import qs.sources

Item {
    id: root
    width: Config.ratios[0] * parent.width
    height: width

    property real widgetLayoutY
    required property var topLevel

    Rectangle {
        id: widget

        anchors.centerIn: parent
        width: parent.width
        height: parent.height
        radius: Config.radius
        color: Colors.palette.m3surfaceDim

        Image {
            id: icon
            anchors.centerIn: parent
            width: Config.ratios[1] * parent.width
            height: width
            sourceSize.width: width
            sourceSize.height: height
            source: {
                if (Audio.volume != 0) {
                    return Quickshell.env("HOME") + "/.local/share/hoshimi/assets/m3icons/headphones_24dp_E3E3E3_FILL0_wght400_GRAD0_opsz24.svg";
                } else {
                    return Quickshell.env("HOME") + "/.local/share/hoshimi/assets/m3icons/headset_off_24dp_E3E3E3_FILL0_wght400_GRAD0_opsz24.svg";
                }
            }
            visible: false // It will be covered by the colorOverlay
        }

        ColorOverlay {
            anchors.fill: icon
            source: icon
            color: Colors.palette.m3onBackground
        }

        layer.enabled: true
        layer.effect: MultiEffect {
            shadowColor: Colors.getPaletteColor("teal")
            shadowEnabled: true
            blurMax: 10
            shadowScale: area.containsMouse ? 1 : 0

            Behavior on shadowScale {
                NumberAnimation {
                    duration: MaterialEasing.standardTime
                    easing.type: Easing.InCurve
                }
            }
        }

        MouseArea {
            id: area
            anchors.fill: parent
            hoverEnabled: true
        }

        PopupWindow {
            anchor.window: root.topLevel
            anchor.rect.x: Variables.barSize - Config.padding
            anchor.rect.y: root.y + root.widgetLayoutY
            implicitWidth: 500 + Config.padding
            implicitHeight: 500 + Config.padding
            visible: true
            color: "transparent"
        }
    }
}
