// Managed by hoshimi

pragma Singleton
import Quickshell

Singleton {
    property var layout: {
        return {
            ratios: [1 / 0.9, 0.9, 0.6],
            padding: 8,
            spacing: 6,
            radius: 4
        };
    }

    property var bar: {
        return {
            barSize: 50,
            wrapSize: 8
        };
    }

    property var icons: {
        return {
            bigSize: 45,
            mediumSize: 32,
            smallSize: 22
        };
    }

    property var notifs: {
        return {
            timeOut: true,
            timeOutTime: 5000,
            width: 360,
            height: 100
        };
    }

    property var background: {
        return {
            clockX: 100,
            clockY: 900,
            clockFont: "MRK Maston"
        };
    }
}
