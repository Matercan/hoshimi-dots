pragma ComponentBehavior: Bound
import qs.lockscreen
import qs.globals as V

import Quickshell.Wayland
import QtQuick

Item {
    // This stores all the information shared between the lock surfaces on each screen.
    LockContext {
        id: lockContext

        onUnlocked: {
            lock.locked = false;
            console.log("Screen unlocked");
        }
    }

    WlSessionLock {
        id: lock
        locked: false

        WlSessionLockSurface {
            LockSurface {
                anchors.fill: parent
                context: lockContext
            }
        }
    }

    Timer {
        interval: 100
        repeat: true
        running: true
        onTriggered: {
            if (V.Variables.locked)
                console.log("LOCKED");
            lock.locked = V.Variables.locked;
        }
    }
}
