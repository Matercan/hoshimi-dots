pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes
import QtQuick.Effects

import qs.globals
import qs.functions
import qs.sources

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

        Shape {
            width: widget.width
            height: widget.height
            anchors.centerIn: parent
            anchors.bottomMargin: parent.height / 2
            preferredRendererType: Shape.CurveRenderer

            ShapePath {
                id: ramRing
                strokeWidth: 4
                strokeStyle: ShapePath.SolidLine
                strokeColor: Colors.interpolate(Colors.getPaletteColor("navy"), Colors.getPaletteColor("red"), parseFloat(Memory.memoryUsed) / parseFloat(Memory.totalMemory))
                fillColor: "transparent"
                startX: widget.width / 2
                startY: (widget.height / 4)  // Start at top of circle

                PathArc {
                    radiusX: widget.width / 4
                    radiusY: widget.height / 4
                    x: Maths.getProgressCoords(parseFloat(Memory.memoryUsed) / parseFloat(Memory.totalMemory), widget.width / 4, widget.width / 2, widget.height / 2)[0]
                    y: Maths.getProgressCoords(parseFloat(Memory.memoryUsed) / parseFloat(Memory.totalMemory), widget.width / 4, widget.width / 2, widget.height / 2)[1]
                    useLargeArc: parseFloat(Memory.memoryUsed) / parseFloat(Memory.totalMemory) > 0.5
                }
            }
        }

        layer.enabled: true
        layer.effect: MultiEffect {
            shadowColor: Colors.getPaletteColor("teal")
            shadowEnabled: true
            blurMax: 10
            shadowScale: area.containsMouse || popupArea.containsMouse ? 1 : 0

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
        width: rect.width + 8
        height: rect.height + 8
        visible: true
        color: "transparent"

        property bool showContent: false

        Rectangle {
            id: rect
            height: 200
            width: popupArea.containsMouse || area.containsMouse ? 200 : 0

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
        }

        MouseArea {
            id: popupArea
            hoverEnabled: true
            anchors.fill: parent

            onEntered: parent.showContent = true
        }
    }
}
