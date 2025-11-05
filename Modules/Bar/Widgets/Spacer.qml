import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.Commons
import qs.Services
import qs.Widgets

Item {
  id: root

  property ShellScreen screen
  readonly property var _barConfig: screen ? Settings.getMonitorBarConfig(screen.name) : Settings.getDefaultBarConfig()
  readonly property real barHeight: BarService.getBarHeight(_barConfig.density, _barConfig.position)

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

  // Use settings or defaults from BarWidgetRegistry
  readonly property int spacerWidth: widgetSettings.width !== undefined ? widgetSettings.width : widgetMetadata.width

  // Set the width based on user settings
  implicitWidth: spacerWidth
  implicitHeight: barHeight
  width: implicitWidth
  height: implicitHeight
}
