pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {
    id: root
    property bool locked: false
    property string iconPath: "/usr/share/icons/"

    property int popupMenuOpenTime: 5000
    property string fontFamily: "CaskaydiaCove Nerd Font"
    property int barSize: 35
    property int wrapSize: 15

    IpcHandler {
        target: "variables"

        function setLocked(locked: bool): void {
            root.locked = locked;
        }
        function getLocked(): bool {
            return root.locked;
        }
        function setPopupTimer(time: int): void {
            root.popupMenuOpenTime = time;
        }
        function getPopupTime(): int {
            return root.popupMenuOpenTime;
        }
        function setFont(font: string): void {
            root.fontFamily = font;
        }
        function getFontText(): string {
            return root.fontFamily;
        }
    }
}
