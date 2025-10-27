// Time.qml
pragma Singleton
import Quickshell

Singleton {
    id: root
    readonly property string datetime: {
        return Qt.formatDateTime(clock.date, "d MMM hh:mm:ss");
    }
    readonly property string date: {
        Qt.formatDateTime(clock.date, "d MMM yyyy");
    }
    readonly property string time: {
        Qt.formatDateTime(clock.date, "hh:mm:ss");
    }

    readonly property int hours: {
        return parseInt(time.split(':')[0]);
    }
    readonly property int minutes: {
        return parseInt(time.split(':')[1]);
    }
    readonly property int seconds: {
        return parseInt(time.split(':')[2]);
    }

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }
}
