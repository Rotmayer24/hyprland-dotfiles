pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import "functions"
import "." as Common
import "../../styles"

Singleton {
    id: root

    property QtObject m3colors: QtObject {
        property bool darkmode: true
        property color m3primary: Theme.accent
        property color m3onPrimary: Theme.textPrimary
        property color m3primaryContainer: Theme.surfaceVariant
        property color m3onPrimaryContainer: Theme.textPrimary
        property color m3secondary: Theme.accent
        property color m3onSecondary: Theme.textPrimary
        property color m3secondaryContainer: Theme.surfaceVariant
        property color m3onSecondaryContainer: Theme.textPrimary
        property color m3background: Theme.background
        property color m3onBackground: Theme.textPrimary
        property color m3surface: Theme.surface
        property color m3surfaceContainerLow: Theme.surface
        property color m3surfaceContainer: Theme.surfaceVariant
        property color m3surfaceContainerHigh: Theme.card
        property color m3surfaceContainerHighest: Theme.card
        property color m3onSurface: Theme.textPrimary
        property color m3surfaceVariant: Theme.surfaceVariant
        property color m3onSurfaceVariant: Theme.textSecondary
        property color m3inverseSurface: Theme.card
        property color m3inverseOnSurface: Theme.textPrimary
        property color m3outline: Theme.border
        property color m3outlineVariant: Theme.borderSubtle
        property color m3shadow: "#000000"
    }

    property QtObject animation
    property QtObject animationCurves
    property QtObject colors
    property QtObject rounding
    property QtObject font
    property QtObject sizes

    colors: QtObject {
        property color colSubtext: Theme.textSecondary
        property color colLayer0: Theme.background
        property color colOnLayer0: Theme.textPrimary
        property color colLayer0Border: Theme.border
        property color colLayer1: Theme.surface
        property color colOnLayer1: Theme.textSecondary
        property color colOnLayer1Inactive: Theme.textMuted
        property color colLayer1Hover: Theme.buttonHover
        property color colLayer1Active: Theme.buttonPressed
        property color colLayer2: Theme.surfaceVariant
        property color colOnLayer2: Theme.textPrimary
        property color colLayer2Hover: Theme.borderHover
        property color colLayer2Active: Theme.buttonPressed
        property color colPrimary: Theme.accent
        property color colOnPrimary: Theme.textPrimary
        property color colSecondary: Theme.accent
        property color colSecondaryContainer: Theme.surfaceVariant
        property color colOnSecondaryContainer: Theme.textPrimary
        property color colTooltip: Theme.card
        property color colOnTooltip: Theme.textPrimary
        property color colShadow: ColorUtils.transparentize("#000000", 0.7)
        property color colOutline: Theme.border
    }

    Connections {
        target: Theme
        function onBackgroundChanged() { root.m3colors.m3background = Theme.background }
        function onSurfaceChanged() { root.m3colors.m3surface = Theme.surface }
        function onAccentChanged() { root.m3colors.m3primary = Theme.accent }
        function onTextPrimaryChanged() { root.m3colors.m3onSurface = Theme.textPrimary }
        function onTextSecondaryChanged() { root.m3colors.m3onSurfaceVariant = Theme.textSecondary }
        function onSurfaceVariantChanged() { root.m3colors.m3surfaceVariant = Theme.surfaceVariant }
        function onBorderChanged() { root.m3colors.m3outline = Theme.border }
        function onCardChanged() { root.m3colors.m3inverseSurface = Theme.card }
    }

    rounding: QtObject {
        property int unsharpen: Common.Config.options.appearance.rounding.unsharpen
        property int verysmall: Common.Config.options.appearance.rounding.verysmall
        property int small: Common.Config.options.appearance.rounding.small
        property int normal: Common.Config.options.appearance.rounding.normal
        property int large: Common.Config.options.appearance.rounding.large
        property int full: Common.Config.options.appearance.rounding.full
        property int screenRounding: Common.Config.options.appearance.rounding.screenRounding
        property int windowRounding: Common.Config.options.appearance.rounding.windowRounding
    }

    font: QtObject {
        property QtObject family: QtObject {
            property string main: Common.Config.options.appearance.font.family.main
            property string title: Common.Config.options.appearance.font.family.title
            property string expressive: Common.Config.options.appearance.font.family.expressive
        }
        property QtObject pixelSize: QtObject {
            property int smaller: Common.Config.options.appearance.font.pixelSize.smaller
            property int small: Common.Config.options.appearance.font.pixelSize.small
            property int normal: Common.Config.options.appearance.font.pixelSize.normal
            property int larger: Common.Config.options.appearance.font.pixelSize.larger
            property int huge: Common.Config.options.appearance.font.pixelSize.huge
        }
    }

    animationCurves: QtObject {
        readonly property list<real> expressiveDefaultSpatial: [0.38, 1.21, 0.22, 1.00, 1, 1]
        readonly property list<real> expressiveEffects: [0.34, 0.80, 0.34, 1.00, 1, 1]
        readonly property list<real> emphasizedDecel: [0.05, 0.7, 0.1, 1, 1, 1]
        readonly property real expressiveDefaultSpatialDuration: Common.Config.options.appearance.animation.duration.elementMove
        readonly property real expressiveEffectsDuration: Common.Config.options.appearance.animation.duration.elementMoveFast
    }

    animation: QtObject {
        property QtObject elementMove: QtObject {
            property int duration: animationCurves.expressiveDefaultSpatialDuration
            property int type: Easing.BezierSpline
            property list<real> bezierCurve: animationCurves.expressiveDefaultSpatial
            property Component numberAnimation: Component {
                NumberAnimation {
                    duration: root.animation.elementMove.duration
                    easing.type: root.animation.elementMove.type
                    easing.bezierCurve: root.animation.elementMove.bezierCurve
                }
            }
        }

        property QtObject elementMoveEnter: QtObject {
            property int duration: Common.Config.options.appearance.animation.duration.elementMoveEnter
            property int type: Easing.BezierSpline
            property list<real> bezierCurve: animationCurves.emphasizedDecel
            property Component numberAnimation: Component {
                NumberAnimation {
                    duration: root.animation.elementMoveEnter.duration
                    easing.type: root.animation.elementMoveEnter.type
                    easing.bezierCurve: root.animation.elementMoveEnter.bezierCurve
                }
            }
        }

        property QtObject elementMoveFast: QtObject {
            property int duration: animationCurves.expressiveEffectsDuration
            property int type: Easing.BezierSpline
            property list<real> bezierCurve: animationCurves.expressiveEffects
            property Component numberAnimation: Component {
                NumberAnimation {
                    duration: root.animation.elementMoveFast.duration
                    easing.type: root.animation.elementMoveFast.type
                    easing.bezierCurve: root.animation.elementMoveFast.bezierCurve
                }
            }
        }
    }

    sizes: QtObject {
        property real elevationMargin: Common.Config.options.appearance.sizes.elevationMargin
    }
}
