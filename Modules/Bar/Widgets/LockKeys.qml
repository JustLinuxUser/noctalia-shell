import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Modules.Settings
import qs.Services
import qs.Widgets

//import qs.Modules.Bar.Extras
Rectangle {
  id: root

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
  readonly property real barHeight: BarService.getBarHeight(barDensity, barPosition)
  readonly property real capsuleHeight: BarService.getCapsuleHeight(barDensity, barPosition)
  readonly property bool isVertical: barPosition === "left" || barPosition === "right"

  readonly property bool showCaps: (widgetSettings.showCapsLock !== undefined) ? widgetSettings.showCapsLock : widgetMetadata.showCapsLock
  readonly property bool showNum: (widgetSettings.showNumLock !== undefined) ? widgetSettings.showNumLock : widgetMetadata.showNumLock
  readonly property bool showScroll: (widgetSettings.showScrollLock !== undefined) ? widgetSettings.showScrollLock : widgetMetadata.showScrollLock

  readonly property string capsIcon: widgetSettings.capsLockIcon !== undefined ? widgetSettings.capsLockIcon : widgetMetadata.capsLockIcon
  readonly property string numIcon: widgetSettings.numLockIcon !== undefined ? widgetSettings.numLockIcon : widgetMetadata.numLockIcon
  readonly property string scrollIcon: widgetSettings.scrollLockIcon !== undefined ? widgetSettings.scrollLockIcon : widgetMetadata.scrollLockIcon

  implicitWidth: isVertical ? capsuleHeight : Math.round(layout.implicitWidth + Style.marginM * 2)
  implicitHeight: isVertical ? Math.round(layout.implicitHeight + Style.marginM * 2) : capsuleHeight

  Layout.alignment: Qt.AlignVCenter

  radius: Style.radiusM
  color: barShowCapsule ? Color.mSurfaceVariant : Color.transparent

  Item {
    id: layout
    anchors.verticalCenter: parent.verticalCenter
    anchors.horizontalCenter: parent.horizontalCenter

    implicitWidth: rowLayout.visible ? rowLayout.implicitWidth : colLayout.implicitWidth
    implicitHeight: rowLayout.visible ? rowLayout.implicitHeight : colLayout.implicitHeight

    RowLayout {
      id: rowLayout
      visible: !root.isVertical
      spacing: 0

      NIcon {
        visible: root.showCaps
        icon: root.capsIcon
        color: LockKeysService.capsLockOn ? Color.mTertiary : Qt.alpha(Color.mOnSurfaceVariant, 0.3)
      }
      NIcon {
        visible: root.showNum
        icon: root.numIcon
        color: LockKeysService.numLockOn ? Color.mTertiary : Qt.alpha(Color.mOnSurfaceVariant, 0.3)
      }
      NIcon {
        visible: root.showScroll
        icon: root.scrollIcon
        color: LockKeysService.scrollLockOn ? Color.mTertiary : Qt.alpha(Color.mOnSurfaceVariant, 0.3)
      }
    }

    ColumnLayout {
      id: colLayout
      visible: root.isVertical
      spacing: 0

      NIcon {
        visible: root.showCaps
        icon: root.capsIcon
        color: LockKeysService.capsLockOn ? Color.mTertiary : Qt.alpha(Color.mOnSurfaceVariant, 0.3)
      }
      NIcon {
        visible: root.showNum
        icon: root.numIcon
        color: LockKeysService.numLockOn ? Color.mTertiary : Qt.alpha(Color.mOnSurfaceVariant, 0.3)
      }
      NIcon {
        visible: root.showScroll
        icon: root.scrollIcon
        color: LockKeysService.scrollLockOn ? Color.mTertiary : Qt.alpha(Color.mOnSurfaceVariant, 0.3)
      }
    }
  }
}
