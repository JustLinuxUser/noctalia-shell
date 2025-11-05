import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.Commons
import qs.Services
import qs.Widgets

NIconButton {
  id: root

  property ShellScreen screen
  readonly property var _barConfig: screen ? Settings.getMonitorBarConfig(screen.name) : Settings.getDefaultBarConfig()
  readonly property real capsuleHeight: BarService.getCapsuleHeight(_barConfig.density, _barConfig.position)
  property bool barShowCapsule: true // Passed from Bar.qml

  density: barDensity
  baseSize: capsuleHeight
  applyUiScale: false
  icon: "power"
  tooltipText: I18n.tr("tooltips.session-menu")
  tooltipDirection: BarService.getTooltipDirection(barPosition)
  colorBg: (barShowCapsule ? Color.mSurfaceVariant : Color.transparent)
  colorFg: Color.mError
  colorBorder: Color.transparent
  colorBorderHover: Color.transparent
  onClicked: PanelService.getPanel("sessionMenuPanel", screen)?.toggle()
}
