pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import QtQuick.Shapes
import QtQuick.Layouts
import QtQuick.Effects

import qs.globals
import qs.functions
import qs.sources
import qs.generics

Item {
    id: root
    width: 0.9 * parent.width
    height: width

    property real widgetLayoutY
    required property var topLevel

    Rectangle {
        id: widget

        anchors.centerIn: parent
        width: parent.width
        height: parent.height
        radius: 8
        color: Colors.getPaletteColor("grey")

        ProgressRing {
            anchors.centerIn: parent

            width: 0.6 * parent.width
            height: width

            fillColor: Colors.interpolate(Colors.getPaletteColor("navy"), Colors.getPaletteColor("red"), System.percentMemory)
            underlyingColor: Colors.transparentize(Colors.getPaletteColor("teal"), 0.7)
            percent: System.percentMemory
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
                    easing.type: Easing.OutCurve
                }
            }
        }

        MouseArea {
            id: area
            anchors.fill: parent
            hoverEnabled: true
        }
    }

    PopupWindow {
        anchor.window: root.topLevel
        anchor.rect.x: Variables.barSize - 8
        anchor.rect.y: root.y + root.widgetLayoutY
        implicitWidth: rect.width + 8
        implicitHeight: rect.height + 8
        visible: true
        color: "transparent"

        Rectangle {
            id: rect
            height: 160
            width: popupArea.containsMouse || area.containsMouse ? 280 : 0

            Behavior on width {
                NumberAnimation {
                    duration: MaterialEasing.standardTime
                    easing.type: Easing.OutCurve
                }
            }

            anchors.top: parent.top
            anchors.leftMargin: 8
            anchors.left: parent.left

            color: Colors.backgroundColor
            radius: 8

            Rectangle {
                id: systemInfoCard
                width: 280
                height: 160
                color: Colors.backgroundColor  // Surface container
                radius: 16  // M3 uses larger radius (12-16px)

                // Subtle elevation shadow
                layer.enabled: true

                // Header section with accent
                Rectangle {
                    id: header
                    width: parent.width
                    height: 24
                    color: Colors.getPaletteColor("teal")
                    radius: 16
                    opacity: 0.12  // M3 surface tint

                    Rectangle {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        height: parent.height / 2
                        color: parent.color
                        opacity: parent.opacity
                    }
                }

                // Content container
                ColumnLayout {
                    Rectangle {}
                }
            }
        }

        MouseArea {
            id: popupArea
            hoverEnabled: true
            anchors.fill: parent

            onEntered: parent.showContent = true
        }
    }
}
