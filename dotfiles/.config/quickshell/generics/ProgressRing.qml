import QtQuick
import QtQuick.Shapes

Rectangle {
    id: root

    // Public properties
    required property string fillColor
    required property string underlyingColor
    required property real percent  // 0.0 to 1.0
    property real strokeWidth: 4
    property real startAngle: -90  // Start at top (12 o'clock)

    color: "transparent"

    // Helper function for progress coordinates
    function getProgressCoords(percentage, radius, centerX, centerY) {
        // Convert percentage to angle (0-360 degrees)
        var angle = (percentage * 360 + startAngle) * (Math.PI / 180);
        var x = centerX + radius * Math.cos(angle);
        var y = centerY + radius * Math.sin(angle);
        return [x, y];
    }

    // Background circle (full ring)
    Shape {
        id: backgroundRing
        anchors.fill: parent
        preferredRendererType: Shape.CurveRenderer

        ShapePath {
            strokeWidth: root.strokeWidth
            strokeStyle: ShapePath.SolidLine
            strokeColor: root.underlyingColor
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap

            startX: root.width / 2
            startY: root.strokeWidth / 2  // Account for stroke width

            PathArc {
                radiusX: (root.width - root.strokeWidth) / 2
                radiusY: (root.height - root.strokeWidth) / 2
                x: root.width / 2 - 0.1  // Slight offset to complete circle
                y: root.strokeWidth / 2
                useLargeArc: true
                direction: PathArc.Clockwise
            }
        }
    }

    // Progress arc
    Shape {
        id: progressRing
        anchors.fill: parent
        preferredRendererType: Shape.CurveRenderer
        visible: root.percent > 0

        ShapePath {
            strokeWidth: root.strokeWidth
            strokeStyle: ShapePath.SolidLine
            strokeColor: root.fillColor
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap

            startX: root.width / 2
            startY: root.strokeWidth / 2  // Start at top

            PathArc {
                property var coords: root.getProgressCoords(root.percent, (root.width - root.strokeWidth) / 2, root.width / 2, root.height / 2)

                radiusX: (root.width - root.strokeWidth) / 2
                radiusY: (root.height - root.strokeWidth) / 2
                x: coords[0]
                y: coords[1]
                useLargeArc: root.percent > 0.5
                direction: PathArc.Clockwise
            }
        }
    }
}
