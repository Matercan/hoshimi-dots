pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Shapes

import qs.globals
import qs.functions
import qs.sources
import qs.generics

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

        ProgressRing {
            anchors.centerIn: parent

            width: Config.ratios[1] * parent.width
            height: width

            fillColor: Colors.blend(Colors.palette.success, Colors.palette.warning, System.percentMemory)
            underlyingColor: Colors.transparentize(Colors.palette.m3surfaceBright, 0.7)
            percent: System.percentMemory

            Behavior on percent {
                NumberAnimation {
                    duration: MaterialEasing.standardTime
                    easing.type: Easing.Bezier
                    easing.bezierCurve: MaterialEasing.standard
                }
            }
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
                    easing.type: Easing.Bezier
                    easing.bezierCurve: MaterialEasing.standard
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
        anchor.rect.x: Variables.barSize - Config.padding
        anchor.rect.y: root.y + root.widgetLayoutY
        implicitWidth: rect.width + Config.padding
        implicitHeight: rect.height + Config.padding
        visible: true
        color: "transparent"
        mask: Region {}

        Shape {
            anchors.centerIn: parent
            width: 500
            height: 500
            preferredRendererType: Shape.CurveRenderer

            ShapePath {
                strokeWidth: 4
                strokeStyle: ShapePath.SolidLine
                strokeColor: Colors.palette.m3background
            }
        }

        Rectangle {
            id: rect
            height: systemInfoCard.height
            width: popupArea.containsMouse || area.containsMouse ? systemInfoCard.width : 0

            Behavior on width {
                NumberAnimation {
                    duration: MaterialEasing.standardTime
                    easing.type: Easing.Bezier
                    easing.bezierCurve: MaterialEasing.standard
                }
            }

            anchors.top: parent.top
            anchors.leftMargin: Config.padding
            anchors.left: parent.left

            color: Colors.backgroundColor
            radius: Config.radius

            Rectangle {
                id: systemInfoCard
                width: systemInfoContent.width + margins * 2
                height: systemInfoContent.height + header.height + 3 * margins
                color: Colors.backgroundColor  // Surface container
                radius: 2 * Config.radius
                property real margins: Config.padding * 3 / 2

                // Subtle elevation shadow
                layer.enabled: true

                // Header section with accent
                Rectangle {
                    id: header
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width
                    height: 24
                    color: Colors.getPaletteColor("teal")
                    radius: 2 * Config.radius
                    opacity: 0.12

                    Rectangle {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        height: parent.height / 2
                        color: parent.color
                        opacity: parent.opacity
                    }
                }

                Text {
                    text: "System Information"
                    color: Colors.foregroundColor
                    anchors.centerIn: header
                    font.pixelSize: 10
                }

                // Content container
                GridLayout {
                    id: systemInfoContent
                    y: systemInfoCard.height - height - systemInfoCard.margins
                    anchors.horizontalCenter: parent.horizontalCenter

                    columns: 2
                    rows: 2

                    ProgressRing {
                        Layout.preferredWidth: 100
                        Layout.preferredHeight: 100

                        fillColor: Colors.blend(Colors.palette.success, Colors.palette.warning, System.percentMemory)
                        underlyingColor: Colors.transparentize(Colors.palette.m3surfaceBright, 0.7)
                        percent: System.percentMemory
                        showText: true
                        text: "RAM:"

                        Behavior on percent {
                            NumberAnimation {
                                duration: MaterialEasing.standardTime
                                easing.type: Easing.Bezier
                                easing.bezierCurve: MaterialEasing.standard
                            }
                        }
                    }

                    ProgressRing {
                        Layout.preferredWidth: 100
                        Layout.preferredHeight: 100

                        fillColor: Colors.blend(Colors.palette.success, Colors.palette.warning, System.load)
                        underlyingColor: Colors.transparentize(Colors.palette.m3surfaceBright, 0.7)
                        percent: System.load
                        showText: true
                        text: "CPU:"

                        Behavior on percent {
                            NumberAnimation {
                                duration: MaterialEasing.standardTime
                                easing.type: Easing.Bezier
                                easing.bezierCurve: MaterialEasing.standard
                            }
                        }
                    }

                    ProgressRing {
                        Layout.preferredWidth: 100
                        Layout.preferredHeight: 100

                        fillColor: Colors.blend(Colors.palette.success, Colors.palette.warning, System.percentSwap)
                        underlyingColor: Colors.transparentize(Colors.palette.m3surfaceBright, 0.7)
                        percent: System.percentSwap
                        showText: true
                        text: "Swap:"

                        Behavior on percent {
                            NumberAnimation {
                                duration: MaterialEasing.standardTime
                                easing.type: Easing.Bezier
                                easing.bezierCurve: MaterialEasing.standard
                            }
                        }
                    }

                    ProgressRing {
                        id: tempRing
                        Layout.preferredWidth: 100
                        Layout.preferredHeight: 100

                        fillColor: Colors.blend(Colors.palette.success, Colors.palette.warning, System.temperature / 100)
                        underlyingColor: Colors.transparentize(Colors.palette.m3surfaceBright, 0.7)
                        percent: System.temperature / 100
                        showText: false
                        text: "Temp:"

                        ColumnLayout {

                            anchors.centerIn: parent
                            implicitWidth: iconText.width
                            implicitHeight: iconText.height + percentText.height + spacing
                            spacing: 2

                            Text {
                                id: iconText
                                Layout.alignment: Qt.AlignCenter

                                text: "temp"
                                font.pixelSize: Math.min(tempRing.width, tempRing.height) * 0.15
                                font.weight: Font.Medium
                                color: tempRing.fillColor
                            }

                            Text {
                                id: percentText
                                Layout.alignment: Qt.AlignCenter

                                text: Math.round(tempRing.percent * 100) + "°C"
                                font.pixelSize: Math.min(tempRing.width, tempRing.height) * 0.15
                                font.weight: Font.Medium
                                color: tempRing.fillColor
                            }
                        }

                        Behavior on percent {
                            NumberAnimation {
                                duration: MaterialEasing.standardTime
                                easing.type: Easing.Bezier
                                easing.bezierCurve: MaterialEasing.standard
                            }
                        }
                    }
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
