import QtQuick
import QtQuick.Shapes
import QtQuick.Effects
import Quickshell
import Quickshell.Wayland

import qs.functions as F
import qs.globals as G

PanelWindow {
    anchors {
        left: true
        right: true
        bottom: true
        top: true
    }

    color: "transparent"
    WlrLayershell.layer: WlrLayer.Bottom

    Item {
        anchors.fill: parent
        Rectangle {
            anchors.fill: parent
            color: F.Colors.backgroundColor

            layer.enabled: true
            layer.effect: MultiEffect {
                maskSource: mask
                maskEnabled: true
                maskInverted: true
                maskThresholdMin: 0.5
                maskSpreadAtMin: 1
            }
        }

        Item {
            id: mask

            anchors.fill: parent
            layer.enabled: true
            visible: false

            Rectangle {
                anchors.fill: parent
                anchors.margins: 8
                anchors.topMargin: 20
                radius: 8
            }
        }
    }
}
