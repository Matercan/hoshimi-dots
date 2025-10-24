// Managed by hoshimi

pragma Singleton
import Quickshell
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root
    property JsonObject layout: JsonObject {
        property list<int> ratios: [1 / 0.9, 0.9, 0.6]
        property int padding: 8
        property int spacing: 6
        property int radius: 4
    }

    property JsonObject bar: JsonObject {
        property int barSize: 30
        property int wrapSize: 8
    }

    property JsonObject icons: JsonObject {
        property int bigSize: 45
        property int mediumSize: 32
        property int smallSize: 22
    }

    property var notifs: JsonObject {
        property bool timeOut: true
        property int timeOutTime: 5000
        property int width: 360
        property int height: 100
    }

    property JsonObject background: JsonObject {
        property JsonObject clock: JsonObject {
            property int x: 100
            property int y: 900
            property string font: "MRK Maston"
        }
        property JsonObject wallpaper: JsonObject {
            property int preferredScale: root.layout.ratios[0]
            property bool autoParallax: true
        }
    }
}
