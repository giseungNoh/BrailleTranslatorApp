import SwiftUI
import UIKit

struct BrailleCanvasView: View {
    let text: String
    var useAbbreviations: Bool = true
    var cellsPerLineOverride: Int? = nil
    @Binding var isInteracting: Bool

    init(text: String, useAbbreviations: Bool = true, cellsPerLineOverride: Int? = nil, isInteracting: Binding<Bool> = .constant(false)) {
        self.text = text
        self.useAbbreviations = useAbbreviations
        self.cellsPerLineOverride = cellsPerLineOverride
        self._isInteracting = isInteracting
    }

    var body: some View {
        BrailleTouchCanvasViewRepresentable(text: text, useAbbreviations: useAbbreviations, cellsPerLineOverride: cellsPerLineOverride, isInteracting: $isInteracting)
            .background(Color.clear)
    }
}

struct BrailleTouchCanvasViewRepresentable: UIViewRepresentable {
    let text: String
    var useAbbreviations: Bool = true
    var cellsPerLineOverride: Int? = nil
    @Binding var isInteracting: Bool

    // UserDefaults 변경 감지 (설정 즉시 반영)
    @AppStorage("cellsPerLine") private var cellsPerLine: Int = 4
    @AppStorage("activeDotIntensity") private var activeDotIntensity: Double = 1.0
    @AppStorage("inactiveDotIntensity") private var inactiveDotIntensity: Double = 0.5
    @AppStorage("isInactiveDotFeedbackEnabled") private var isInactiveDotFeedbackEnabled: Bool = true
    @AppStorage("isDotNumberAnnouncementEnabled") private var isDotNumberAnnouncementEnabled: Bool = true

    func makeUIView(context: Context) -> BrailleTouchCanvasView {
        let view = BrailleTouchCanvasView()

        view.onTouchStateChanged = { isTouching in
            DispatchQueue.main.async {
                self.isInteracting = isTouching
            }
        }

        updateSettings(for: view)
        view.useAbbreviations = useAbbreviations
        view.updateText(text)
        return view
    }

    func updateUIView(_ uiView: BrailleTouchCanvasView, context: Context) {
        updateSettings(for: uiView)
        uiView.useAbbreviations = useAbbreviations
        uiView.updateText(text)
    }

    private func updateSettings(for view: BrailleTouchCanvasView) {
        let effectiveCellsPerLine = cellsPerLineOverride ?? cellsPerLine

        let newConfig = BrailleDisplayConfig(
            cellsPerLine: effectiveCellsPerLine,
            activeDotIntensity: activeDotIntensity,
            inactiveDotIntensity: inactiveDotIntensity,
            isInactiveDotFeedbackEnabled: isInactiveDotFeedbackEnabled,
            isDotNumberAnnouncementEnabled: isDotNumberAnnouncementEnabled
        )
        view.config = newConfig
    }
}
