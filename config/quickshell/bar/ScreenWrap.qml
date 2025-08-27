import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Wayland

import qs.functions as F
import qs.globals as G

Scope {
    Variants {
        model: Quickshell.screens
        PanelWindow {
            required property var modelData
            screen: modelData

            anchors {
                left: true
                right: true
                bottom: true
                top: true
            }

            color: "transparent"
            WlrLayershell.layer: WlrLayer.Top
            WlrLayershell.focusable: false
            mask: Region {}
            focusable: false

            Item {
                anchors.fill: parent

                layer.enabled: true
                layer.effect: MultiEffect {
                    shadowEnabled: true
                    blurMax: 10
                    shadowColor: F.Colors.transparentize(F.Colors.iconColor, 0.3)
                }

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
                            anchors.margins: G.Variables.wrapSize
                            radius: 8
                        }
                    }
                }
            }
        }
    }
}
