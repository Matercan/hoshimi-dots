// Managed by Hoshimi
//@ pragma UseQApplication

import qs.bar
import qs.notifications
import qs.modules

import Quickshell
import QtQuick

ShellRoot {
    id: root

    Loader {
        active: true
        sourceComponent: WallpaperItem {}
    }
    Loader {
        active: true
        sourceComponent: ScreenWrap {}
    }
    Loader {
        active: true
        sourceComponent: Notifications {}
    }
    Loader {
        active: true
        sourceComponent: LockItem {}
    }
    Loader {
        active: true
        sourceComponent: Bar {}
    }
    Loader {
        active: true
        sourceComponent: Content {}
    }
    Loader {
        active: true

        sourceComponent: AltTAB {}
    }
}
