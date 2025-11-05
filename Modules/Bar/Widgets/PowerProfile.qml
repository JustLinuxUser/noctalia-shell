import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.UPower
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
  visible: PowerProfileService.available
  icon: PowerProfileService.getIcon()
  tooltipText: I18n.tr("tooltips.power-profile", {
                         "profile": PowerProfileService.getName()
                       })
  tooltipDirection: BarService.getTooltipDirection(barPosition)
  colorBg: (PowerProfileService.profile === PowerProfile.Balanced) ? (barShowCapsule ? Color.mSurfaceVariant : Color.transparent) : Color.mPrimary
  colorFg: (PowerProfileService.profile === PowerProfile.Balanced) ? Color.mOnSurface : Color.mOnPrimary
  colorBorder: Color.transparent
  colorBorderHover: Color.transparent
  onClicked: PowerProfileService.cycleProfile()
}
