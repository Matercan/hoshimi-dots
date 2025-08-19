// Time.qml
import Quickshell

Scope {
    id: root
    readonly property string time: {
        // The passed format string matches the default output of
        // the `date` command.
        Qt.formatDateTime(clock.date, "d MMM hh:mm:ss");
    }

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }
}
