import SwiftUI
import TrinityTokens
import TrinityTheme

/// Compact inline indicator showing a data pipeline sync state.
///
/// Three display states:
/// - `.syncing`: rotating icon + custom syncing message
/// - `.analysing`: rotating icon + "Analysing"
/// - `.synced(Date?)`: checkmark + "Synced · X ago" (or just "Synced")
///
/// The indicator holds the loading state for a minimum of 3 seconds before
/// transitioning to the synced state, to prevent flickering.
///
/// Usage:
/// ```swift
/// TrinityHealthKitSyncIndicator(state: .syncing("Syncing HealthKit"), isAnalysing: false)
/// TrinityHealthKitSyncIndicator(state: .synced(Date()), isAnalysing: false)
/// ```
public struct TrinityHealthKitSyncIndicator: View {

    @Environment(\.theme) private var theme

    /// The current data fetch state.
    public enum SyncState: Equatable {
        case idle
        case syncing(String = "Syncing")
        case synced(Date?)
    }

    public let state: SyncState
    public let isAnalysing: Bool

    @State private var showingSyncingState = false
    @State private var rotationAngle: Double = 0
    @State private var isSpinning = false
    @State private var lastSyncDate: Date? = nil
    @State private var minimumHoldTask: Task<Void, Never>? = nil
    @State private var lastLoadingText = "Syncing"

    private var isLoadingVisible: Bool {
        state == .syncing("") || isAnalysing || showingSyncingState
    }

    private var syncingMessage: String? {
        if case .syncing(let msg) = state { return msg }
        return nil
    }

    private var isLoadingState: Bool {
        if case .syncing = state { return true }
        return false
    }

    private var loadingText: String {
        if let msg = syncingMessage, !msg.isEmpty { return msg }
        if isAnalysing { return "Analysing" }
        return lastLoadingText
    }

    public init(state: SyncState, isAnalysing: Bool = false) {
        self.state = state
        self.isAnalysing = isAnalysing
    }

    public var body: some View {
        HStack(spacing: TrinitySpacing.xs) {
            if isLoadingVisible {
                Image(systemName: "arrow.triangle.2.circlepath")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(theme.labelSecondary)
                    .rotationEffect(.degrees(rotationAngle))
                Text(loadingText)
                    .font(TrinityTypography.caption)
                    .foregroundStyle(theme.labelSecondary)
                    .animation(.easeInOut(duration: 0.2), value: loadingText)
            } else {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(TrinityStatusColors.success)
                if let date = lastSyncDate {
                    Text("Synced \u{00B7} \(relativeTimeText(date))")
                        .font(TrinityTypography.caption)
                        .foregroundStyle(theme.labelSecondary)
                } else {
                    Text("Synced")
                        .font(TrinityTypography.caption)
                        .foregroundStyle(theme.labelSecondary)
                }
            }
        }
        .onAppear {
            startLoadingDisplay()
        }
        .onChange(of: state) { newState in
            switch newState {
            case .syncing(let msg):
                lastLoadingText = msg.isEmpty ? "Syncing" : msg
                startLoadingDisplay()
            case .synced(let date):
                if let date { lastSyncDate = date }
                if !isAnalysing {
                    startLoadingDisplay()
                }
            case .idle:
                break
            }
        }
        .onChange(of: isAnalysing) { analysing in
            if analysing {
                lastLoadingText = "Analysing"
            } else {
                if !isLoadingState {
                    startLoadingDisplay()
                }
            }
        }
    }

    // MARK: - Display lifecycle

    private func startLoadingDisplay() {
        showingSyncingState = true
        if !isSpinning {
            isSpinning = true
            withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                rotationAngle = 360
            }
        }
        minimumHoldTask?.cancel()
        minimumHoldTask = Task { @MainActor in
            try? await Task.sleep(for: .seconds(3))
            guard !Task.isCancelled else { return }
            let blocked = isAnalysing || isLoadingState
            guard !blocked else { return }
            endLoadingDisplay()
        }
    }

    private func endLoadingDisplay() {
        showingSyncingState = false
        isSpinning = false
        withAnimation(.default) {
            rotationAngle = 0
        }
    }

    // MARK: - Time formatting

    private func relativeTimeText(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

#if canImport(UIKit)
#Preview("Syncing") {
    TrinityHealthKitSyncIndicator(state: .syncing("Syncing HealthKit"), isAnalysing: false)
        .padding(TrinitySpacing.lg)
        .theme(DemoTRTTheme())
}

#Preview("Analysing") {
    TrinityHealthKitSyncIndicator(state: .synced(nil), isAnalysing: true)
        .padding(TrinitySpacing.lg)
        .theme(DemoTRTTheme())
}

#Preview("Synced — with date") {
    TrinityHealthKitSyncIndicator(state: .synced(Date(timeIntervalSinceNow: -120)), isAnalysing: false)
        .padding(TrinitySpacing.lg)
        .theme(DemoTRTTheme())
}
#endif
