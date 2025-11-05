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

  baseSize: capsuleHeight
  applyUiScale: false
  density: barDensity
  icon: IdleInhibitorService.isInhibited ? "keep-awake-on" : "keep-awake-off"
  tooltipText: IdleInhibitorService.isInhibited ? I18n.tr("tooltips.disable-keep-awake") : I18n.tr("tooltips.enable-keep-awake")
  tooltipDirection: BarService.getTooltipDirection(barPosition)
  colorBg: IdleInhibitorService.isInhibited ? Color.mPrimary : (barShowCapsule ? Color.mSurfaceVariant : Color.transparent)
  colorFg: IdleInhibitorService.isInhibited ? Color.mOnPrimary : Color.mOnSurface
  colorBorder: Color.transparent
  colorBorderHover: Color.transparent
  onClicked: IdleInhibitorService.manualToggle()
}
