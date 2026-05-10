import SwiftUI
import TrinityTheme
import TrinityComponents

@main
struct GalleryApp: App {

    @State private var selectedTheme: ThemeOption = .trt

    enum ThemeOption: String, CaseIterable, Identifiable {
        case trt = "TRT"
        case vr = "VR"
        case gr = "GR"
        var id: String { rawValue }

        var theme: any Theme {
            switch self {
            case .trt: return DemoTRTTheme()
            case .vr:  return DemoVRTheme()
            case .gr:  return DemoGRTheme()
            }
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView(selectedTheme: $selectedTheme)
                .theme(selectedTheme.theme)
        }
    }
}
