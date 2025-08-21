// Time.qml
pragma Singleton
import Quickshell

Singleton {
    id: root
    readonly property string datetime: {
        // The passed format string matches the default output of
        // the `date` command.
        Qt.formatDateTime(clock.date, "d MMM hh:mm:ss");
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
