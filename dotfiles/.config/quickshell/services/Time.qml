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

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }
}
