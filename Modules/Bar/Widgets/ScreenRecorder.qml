import Quickshell
import qs.Commons
import qs.Services
import qs.Widgets

// Screen Recording Indicator
NIconButton {
  id: root

  property ShellScreen screen
  property string barPosition: "top" // Passed from Bar.qml
  property string barDensity: "default" // Passed from Bar.qml
  property bool barShowCapsule: true // Passed from Bar.qml
  readonly property real barHeight: BarService.getBarHeight(barDensity, barPosition)
  readonly property real capsuleHeight: BarService.getCapsuleHeight(barDensity, barPosition)

  icon: "camera-video"
  tooltipText: ScreenRecorderService.isRecording ? I18n.tr("tooltips.click-to-stop-recording") : I18n.tr("tooltips.click-to-start-recording")
  tooltipDirection: BarService.getTooltipDirection(barPosition)
  density: barDensity
  baseSize: capsuleHeight
  applyUiScale: false
  colorBg: ScreenRecorderService.isRecording ? Color.mPrimary : (barShowCapsule ? Color.mSurfaceVariant : Color.transparent)
  colorFg: ScreenRecorderService.isRecording ? Color.mOnPrimary : Color.mOnSurface
  colorBorder: Color.transparent
  colorBorderHover: Color.transparent

  function handleClick() {
    if (!ScreenRecorderService.isAvailable) {
      ToastService.showError(I18n.tr("toast.recording.not-installed"), I18n.tr("toast.recording.not-installed-desc"), 7000)
      return
    }
    ScreenRecorderService.toggleRecording()
  }

  onClicked: handleClick()
}
