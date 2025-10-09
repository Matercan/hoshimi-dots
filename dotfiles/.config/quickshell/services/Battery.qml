pragma Singleton
import Quickshell.Services.UPower
import Quickshell

Singleton {

    property string batteryText: UPower.displayDevice.isLaptopBattery ? qsTr("%1%").arg(Math.round(UPower.displayDevice.percentage * 100)) : qsTr("No battery detected")
    property int batteryAmount: UPower.displayDevice.isLaptopBattery ? Math.round(UPower.displayDevice.percentage * 100) : -1
}
