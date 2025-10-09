pragma Singleton
import Quickshell

Singleton {
    property var layout: {
        return {
            ratios: [0.9, 0.6],
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
}
