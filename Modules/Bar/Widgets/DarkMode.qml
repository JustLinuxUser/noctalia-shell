import Quickshell
import qs.Commons
import qs.Widgets
import qs.Services

NIconButton {
  id: root

  property ShellScreen screen
  readonly property var _barConfig: screen ? Settings.getMonitorBarConfig(screen.name) : Settings.getDefaultBarConfig()
  readonly property real capsuleHeight: BarService.getCapsuleHeight(_barConfig.density, _barConfig.position)
  property bool barShowCapsule: true // Passed from Bar.qml

  icon: "dark-mode"
  tooltipText: Settings.data.colorSchemes.darkMode ? I18n.tr("tooltips.switch-to-light-mode") : I18n.tr("tooltips.switch-to-dark-mode")
  tooltipDirection: BarService.getTooltipDirection(barPosition)
  density: barDensity
  baseSize: capsuleHeight
  applyUiScale: false
  colorBg: Settings.data.colorSchemes.darkMode ? (barShowCapsule ? Color.mSurfaceVariant : Color.transparent) : Color.mPrimary
  colorFg: Settings.data.colorSchemes.darkMode ? Color.mOnSurface : Color.mOnPrimary
  colorBorder: Color.transparent
  colorBorderHover: Color.transparent
  onClicked: Settings.data.colorSchemes.darkMode = !Settings.data.colorSchemes.darkMode
}
