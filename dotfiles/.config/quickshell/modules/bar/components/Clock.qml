import qs.functions
import qs.services
import qs.globals

import QtQuick
import QtQuick.Layouts

Rectangle {
    property int margins: 5

    implicitWidth: layout.implicitWidth + 2 * margins
    implicitHeight: Status.widgetHeight > 0 ? Status.widgetHeight + margins / 2 : layout.implicitHeight + margins

    radius: implicitHeight / 2
    color: Colors.light ? Colors.darken(Colors.palette.m3inverseSurface, 0.1) : Colors.palette.m3surfaceDim

    RowLayout {
        id: layout
        anchors.centerIn: parent
        spacing: 4

        property int hours: {
            console.log(Status.widgetHeight);
            return Time.hours;
        }
        property int minutes: Time.minutes

        Text {
            color: Colors.foregroundColor
            text: layout.hours
            font.family: "Noto Sans"
            font {
                family: "Noto Sans"
                pixelSize: 10
            }
        }
        Text {
            color: Colors.foregroundColor
            text: layout.minutes
            font.family: "Noto Sans"
            font {
                family: "Noto Sans"
                pixelSize: 10
            }
        }

        Behavior on hours {
            Anims.ExpAnim {}
        }

        Behavior on minutes {
            Anims.ExpAnim {}
        }
    }
}
