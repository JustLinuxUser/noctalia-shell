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
    icon: {
      try {
        if (NetworkService.ethernetConnected) {
          return "ethernet"
        }
        let connected = false
        let signalStrength = 0
        for (const net in NetworkService.networks) {
          if (NetworkService.networks[net].connected) {
            connected = true
            signalStrength = NetworkService.networks[net].signal
            break
          }
        }
        return connected ? NetworkService.signalIcon(signalStrength) : "wifi-off"
      } catch (error) {
        Logger.e("Wi-Fi", "Error getting icon:", error)
        return "signal_wifi_bad"
      }
    }
    text: {
      try {
        if (NetworkService.ethernetConnected) {
          return ""
        }
        for (const net in NetworkService.networks) {
          if (NetworkService.networks[net].connected) {
            return net
          }
        }
        return ""
      } catch (error) {
        Logger.e("Wi-Fi", "Error getting ssid:", error)
        return "error"
      }
    }
    autoHide: false
    forceOpen: !isBarVertical && root.displayMode === "alwaysShow"
    forceClose: isBarVertical || root.displayMode === "alwaysHide" || !pill.text
    onClicked: PanelService.getPanel("wifiPanel", screen)?.toggle(this)
    onRightClicked: PanelService.getPanel("wifiPanel", screen)?.toggle(this)
    tooltipText: {
      if (pill.text !== "") {
        return pill.text
      }
      return I18n.tr("tooltips.manage-wifi")
    }
  }
}
