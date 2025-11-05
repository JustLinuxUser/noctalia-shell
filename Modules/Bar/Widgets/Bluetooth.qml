import QtQuick
import Quickshell
import qs.Commons
import qs.Services
import qs.Modules.Bar.Extras

Item {
  id: root

  property ShellScreen screen

  // Widget properties passed from Bar.qml for per-instance settings
  property string widgetId: ""
  property string section: ""
  property int sectionWidgetIndex: -1
  property int sectionWidgetsCount: 0

  property var widgetMetadata: BarWidgetRegistry.widgetMetadata[widgetId]
  property var widgetSettings: {
    if (screen && section && sectionWidgetIndex >= 0) {
      return Settings.getWidgetSettings(screen.name, section, sectionWidgetIndex)
    }
    return {}
  }

  property string barPosition: "top" // Passed from Bar.qml
  property string barDensity: "default" // Passed from Bar.qml
  property bool barShowCapsule: true // Passed from Bar.qml
  readonly property bool isBarVertical: barPosition === "left" || barPosition === "right"
  readonly property string displayMode: widgetSettings.displayMode !== undefined ? widgetSettings.displayMode : widgetMetadata.displayMode

  implicitWidth: pill.width
  implicitHeight: pill.height

  BarPill {
    id: pill

    density: barDensity
    oppositeDirection: BarService.getPillDirection(root)
    icon: BluetoothService.enabled ? "bluetooth" : "bluetooth-off"
    text: {
      if (BluetoothService.connectedDevices && BluetoothService.connectedDevices.length > 0) {
        const firstDevice = BluetoothService.connectedDevices[0]
        return firstDevice.name || firstDevice.deviceName
      }
      return ""
    }
    suffix: {
      if (BluetoothService.connectedDevices && BluetoothService.connectedDevices.length > 1) {
        return ` + ${BluetoothService.connectedDevices.length - 1}`
      }
      return ""
    }
    autoHide: false
    forceOpen: !isBarVertical && root.displayMode === "alwaysShow"
    forceClose: isBarVertical || root.displayMode === "alwaysHide" || BluetoothService.connectedDevices.length === 0
    onClicked: PanelService.getPanel("bluetoothPanel", screen)?.toggle(this)
    onRightClicked: PanelService.getPanel("bluetoothPanel", screen)?.toggle(this)
    tooltipText: {
      if (pill.text !== "") {
        return pill.text
      }
      return I18n.tr("tooltips.bluetooth-devices")
    }
  }
}
