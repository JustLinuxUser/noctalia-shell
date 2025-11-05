import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire
import qs.Commons
import qs.Modules.Settings
import qs.Services
import qs.Widgets
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
  readonly property string displayMode: (widgetSettings.displayMode !== undefined) ? widgetSettings.displayMode : widgetMetadata.displayMode

  // Used to avoid opening the pill on Quickshell startup
  property bool firstVolumeReceived: false
  property int wheelAccumulator: 0

  implicitWidth: pill.width
  implicitHeight: pill.height

  // Connection used to open the pill when volume changes
  Connections {
    target: AudioService.sink?.audio ? AudioService.sink?.audio : null
    function onVolumeChanged() {
      // Logger.i("Bar:Volume", "onVolumeChanged")
      if (!firstVolumeReceived) {
        // Ignore the first volume change
        firstVolumeReceived = true
      } else {
        pill.show()
        externalHideTimer.restart()
      }
    }
  }

  Timer {
    id: externalHideTimer
    running: false
    interval: 1500
    onTriggered: {
      pill.hide()
    }
  }

  BarPill {
    id: pill

    density: barDensity
    oppositeDirection: BarService.getPillDirection(root)
    icon: AudioService.getOutputIcon()
    autoHide: false // Important to be false so we can hover as long as we want
    text: Math.round(AudioService.volume * 100)
    suffix: "%"
    forceOpen: displayMode === "alwaysShow"
    forceClose: displayMode === "alwaysHide"
    tooltipText: I18n.tr("tooltips.volume-at", {
                           "volume": Math.round(AudioService.volume * 100)
                         })

    onWheel: function (delta) {
      wheelAccumulator += delta
      if (wheelAccumulator >= 120) {
        wheelAccumulator = 0
        AudioService.increaseVolume()
      } else if (wheelAccumulator <= -120) {
        wheelAccumulator = 0
        AudioService.decreaseVolume()
      }
    }
    onClicked: {
      PanelService.getPanel("audioPanel", screen)?.toggle(this)
    }
    onRightClicked: {
      AudioService.setOutputMuted(!AudioService.muted)
    }
    onMiddleClicked: {
      Quickshell.execDetached(["sh", "-c", "pwvucontrol || pavucontrol"])
    }
  }
}
