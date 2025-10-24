// Managed by Hoshimi
//@ pragma UseQApplication

import qs.modules.bar
import qs.modules.notifications
import qs.modules.lockscreen
import qs.modules.background

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
        active: false
        sourceComponent: LockItem {}
    }
    Loader {
        active: false
        sourceComponent: Bar {}
    }
    Loader {
        active: true
        sourceComponent: Content {}
    }
}
