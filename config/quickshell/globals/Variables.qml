pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {
    id: root
    property bool locked: false
    property string iconPath: "/usr/share/icons/"

    IpcHandler {
        target: "variables"

        function setLocked(locked: bool): void {
            root.locked = locked;
        }
        function getLocked(): bool {
            return root.locked;
        }
    }
}
