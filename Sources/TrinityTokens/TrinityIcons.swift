import CoreGraphics
import Foundation

/// SF Symbol name constants used across Trinity components.
///
/// String constants rather than `Image` instances so consumers can choose
/// rendering mode (`.symbolRenderingMode`, hierarchical, multicolor) per use.
public enum TrinityIcons {

    // MARK: - Sizes (point sizes for SF Symbols inside Trinity components)

    public enum Size {
        public static let small: CGFloat = 13
        public static let medium: CGFloat = 17
        public static let large: CGFloat = 22
        public static let xlarge: CGFloat = 28
    }

    // MARK: - Navigation

    public static let chevronRight = "chevron.right"
    public static let chevronDown = "chevron.down"
    public static let chevronUp = "chevron.up"
    public static let xmark = "xmark"
    public static let arrowClockwise = "arrow.clockwise"

    // MARK: - Status

    public static let checkmark = "checkmark"
    public static let checkmarkCircle = "checkmark.circle.fill"
    public static let exclamationTriangle = "exclamationmark.triangle.fill"
    public static let infoCircle = "info.circle"

    // MARK: - Health

    public static let heart = "heart.fill"
    public static let bed = "bed.double.fill"
    public static let bolt = "bolt.fill"
    public static let figure = "figure.run"
    public static let flame = "flame.fill"
    public static let lungs = "lungs.fill"

    // MARK: - Actions

    public static let plus = "plus"
    public static let pencil = "pencil"
    public static let trash = "trash"
    public static let ellipsis = "ellipsis"
    public static let gear = "gearshape"
    public static let link = "link"

    // MARK: - Sync / Connectivity

    public static let cloud = "cloud.fill"
    public static let arrowTriangle2Circlepath = "arrow.triangle.2.circlepath"
    public static let wifi = "wifi"

    // MARK: - Empty State

    public static let trayFull = "tray.fill"
    public static let questionMarkCircle = "questionmark.circle"

    // MARK: - Namespaced icons (ported from VeloReady — used via typealias Icons = TrinityIcons)

    public enum Activity {
        public static let cycling = "bicycle"
        public static let running = "figure.run"
        public static let runningCircle = "figure.run.circle"
        public static let walking = "figure.walk"
        public static let hiking = "figure.hiking"
        public static let swimming = "figure.pool.swim"
        public static let strength = "dumbbell"
        public static let yoga = "figure.mind.and.body"
        public static let hiit = "flame"
        public static let other = "figure.mixed.cardio"
    }

    public enum Health {
        public static let heart = "heart"
        public static let heartFill = "heart.fill"
        public static let heartCircle = "heart.circle.fill"
        public static let heartCircleOutline = "heart.circle"
        public static let heartRate = "waveform.path.ecg"
        public static let hrv = "heart.circle"
        public static let sleep = "moon"
        public static let sleepFill = "moon.fill"
        public static let sleepZzz = "moon.zzz"
        public static let sleepZzzFill = "moon.zzz.fill"
        public static let respiratory = "lungs"
        public static let steps = "figure.walk"
        public static let calories = "flame"
        public static let caloriesFill = "flame.fill"
        public static let recovery = "leaf"
        public static let leafFill = "leaf.fill"
        public static let bed = "bed.double.fill"
        public static let moon = "moon.stars.fill"
        public static let bolt = "bolt.fill"
        public static let boltHeart = "bolt.heart.fill"
        public static let boltSlash = "bolt.slash.fill"
        public static let drop = "drop.fill"
        public static let thermometer = "thermometer.medium"
        public static let brain = "brain.head.profile"
        public static let vo2max = "lungs.fill"
    }

    public enum Status {
        public static let success = "checkmark.circle"
        public static let successFill = "checkmark.circle.fill"
        public static let error = "xmark.circle"
        public static let errorFill = "xmark.circle.fill"
        public static let warning = "exclamationmark.triangle"
        public static let warningFill = "exclamationmark.triangle.fill"
        public static let info = "info.circle"
        public static let infoFill = "info.circle.fill"
        public static let alert = "exclamationmark.circle"
        public static let checkmark = "checkmark"
    }

    public enum DataSource {
        public static let intervalsICU = "chart.line.uptrend.xyaxis"
        public static let strava = "figure.outdoor.cycle"
        public static let wahoo = "sensor"
        public static let garmin = "applewatch"
        public static let appleHealth = "heart"
        public static let oura = "circle.hexagongrid.fill"
    }

    public enum Navigation {
        public static let close = "xmark"
        public static let back = "chevron.left"
        public static let forward = "chevron.right"
        public static let expand = "chevron.down"
        public static let collapse = "chevron.up"
        public static let menu = "line.3.horizontal"
        public static let settings = "gearshape"
        public static let settingsFill = "gearshape.fill"
    }

    public enum Training {
        public static let power = "bolt"
        public static let speed = "speedometer"
        public static let distance = "location"
        public static let duration = "clock"
        public static let elevation = "mountain.2"
        public static let cadence = "metronome"
        public static let tss = "gauge.medium"
        public static let intensity = "chart.bar"
    }

    public enum User {
        public static let profile = "person.circle"
        public static let athlete = "figure.strengthtraining.traditional"
        public static let preferences = "slider.horizontal.3"
    }

    public enum Feature {
        public static let ai = "sparkles"
        public static let pro = "crown"
        public static let trends = "chart.xyaxis.line"
        public static let calendar = "calendar"
        public static let analytics = "chart.bar.doc.horizontal"
    }

    public enum Visibility {
        public static let show = "eye"
        public static let hide = "eye.slash"
    }

    public enum Selection {
        public static let selected = "checkmark.circle"
        public static let unselected = "circle"
        public static let radio = "circle"
    }

    public enum Document {
        public static let file = "doc.text"
        public static let download = "arrow.down.circle"
        public static let upload = "arrow.up.circle"
        public static let refresh = "arrow.clockwise"
        public static let copy = "doc.on.doc"
        public static let trash = "trash"
        public static let key = "key.fill"
    }

    public enum System {
        public static let bug = "ladybug.fill"
        public static let database = "cylinder"
        public static let storage = "externaldrive"
        public static let storageBadge = "externaldrive.badge.xmark"
        public static let chart = "chart.bar.fill"
        public static let chartDoc = "chart.bar.doc.horizontal.fill"
        public static let chartDocHorizontal = "chart.bar.doc.horizontal"
        public static let chartBarXAxis = "chart.bar.xaxis"
        public static let person = "person.crop.circle"
        public static let envelope = "envelope.fill"
        public static let map = "map"
        public static let location = "location.fill"
        public static let clock = "clock.fill"
        public static let star = "star.fill"
        public static let pencil = "pencil"
        public static let plus = "plus"
        public static let minus = "minus"
        public static let chevronRight = "chevron.right"
        public static let chevronDown = "chevron.down"
        public static let chevronUp = "chevron.up"
        public static let gauge = "gauge.medium"
        public static let gaugeBadge = "gauge.with.dots.needle.67percent"
        public static let calendar = "calendar"
        public static let brain = "brain.head.profile"
        public static let sparkles = "sparkles"
        public static let waveform = "waveform.path.ecg"
        public static let network = "network"
        public static let shield = "checkmark.shield"
        public static let hammer = "hammer"
        public static let hammerFill = "hammer.fill"
        public static let magnifyingGlass = "doc.text.magnifyingglass"
        public static let keyHorizontal = "key.horizontal"
        public static let heartTextSquare = "heart.text.square.fill"
        public static let heartTextSquareOutline = "heart.text.square"
        public static let grid2x2 = "square.grid.2x2"
        public static let circleArrowPath = "arrow.triangle.2.circlepath"
        public static let counterclockwise = "arrow.counterclockwise"
        public static let arrowRightCircle = "arrow.right.circle.fill"
        public static let target = "target"
        public static let percent = "percent"
        public static let lightbulb = "lightbulb.fill"
        public static let bell = "bell.fill"
        public static let camera = "camera.fill"
        public static let docText = "doc.text.fill"
        public static let eye = "eye.fill"
        public static let circle = "circle.fill"
        public static let lock = "lock.fill"
        public static let lockShield = "lock.shield.fill"
        public static let link = "link"
        public static let linkCircle = "link.circle"
        public static let linkCircleFill = "link.circle.fill"
        public static let trophy = "trophy.fill"
        public static let icloud = "icloud.fill"
        public static let questionCircleFill = "questionmark.circle.fill"
        public static let menuDecrease = "line.3.horizontal.decrease.circle"
    }

    public enum Arrow {
        public static let up = "arrow.up"
        public static let down = "arrow.down"
        public static let right = "arrow.right"
        public static let upRight = "arrow.up.right"
        public static let downRight = "arrow.down.right"
        public static let clockwise = "arrow.clockwise"
        public static let counterclockwise = "arrow.counterclockwise"
        public static let rectanglePortrait = "rectangle.portrait.and.arrow.right"
        public static let rightCircleFill = "arrow.right.circle.fill"
        public static let rightCircle = "arrow.right.circle"
        public static let triangleCirclePath = "arrow.triangle.2.circlepath"
    }
}
