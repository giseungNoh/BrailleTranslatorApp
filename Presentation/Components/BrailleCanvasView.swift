import SwiftUI
import UIKit

struct BrailleCanvasView: View {
    let text: String
    var useAbbreviations: Bool = true
    var cellsPerLineOverride: Int? = nil
    var useChosungForm: Bool = false
    @Binding var isInteracting: Bool
    var maxCellWidth: CGFloat? = nil
    var accessibilityLabelOverride: String? = nil
    var accessibilityHintOverride: String? = nil
    var hideLabels: Bool = false
    var enableOneFingerSwipe: Bool = false
    var rawDotPatterns: [(dots: String, label: String)]? = nil
    var skipLeadingCells: Int = 0
    var centerVertically: Bool = false
    var onSwipeNext: (() -> Void)? = nil
    var onSwipePrevious: (() -> Void)? = nil

    init(text: String = "", useAbbreviations: Bool = true, cellsPerLineOverride: Int? = nil, useChosungForm: Bool = false, isInteracting: Binding<Bool> = .constant(false), maxCellWidth: CGFloat? = nil, accessibilityLabelOverride: String? = nil, accessibilityHintOverride: String? = nil, hideLabels: Bool = false, enableOneFingerSwipe: Bool = false, rawDotPatterns: [(dots: String, label: String)]? = nil, skipLeadingCells: Int = 0, centerVertically: Bool = false, onSwipeNext: (() -> Void)? = nil, onSwipePrevious: (() -> Void)? = nil) {
        self.text = text
        self.useAbbreviations = useAbbreviations
        self.cellsPerLineOverride = cellsPerLineOverride
        self.useChosungForm = useChosungForm
        self._isInteracting = isInteracting
        self.maxCellWidth = maxCellWidth
        self.accessibilityLabelOverride = accessibilityLabelOverride
        self.accessibilityHintOverride = accessibilityHintOverride
        self.hideLabels = hideLabels
        self.enableOneFingerSwipe = enableOneFingerSwipe
        self.rawDotPatterns = rawDotPatterns
        self.skipLeadingCells = skipLeadingCells
        self.centerVertically = centerVertically
        self.onSwipeNext = onSwipeNext
        self.onSwipePrevious = onSwipePrevious
    }

    var body: some View {
        BrailleTouchCanvasViewRepresentable(
            text: text,
            useAbbreviations: useAbbreviations,
            cellsPerLineOverride: cellsPerLineOverride,
            useChosungForm: useChosungForm,
            isInteracting: $isInteracting,
            maxCellWidth: maxCellWidth,
            accessibilityLabelOverride: accessibilityLabelOverride,
            accessibilityHintOverride: accessibilityHintOverride,
            hideLabels: hideLabels,
            enableOneFingerSwipe: enableOneFingerSwipe,
            rawDotPatterns: rawDotPatterns,
            skipLeadingCells: skipLeadingCells,
            centerVertically: centerVertically,
            onSwipeNext: onSwipeNext,
            onSwipePrevious: onSwipePrevious
        )
        .background(Color.clear)
    }
}

struct BrailleTouchCanvasViewRepresentable: UIViewRepresentable {
    let text: String
    var useAbbreviations: Bool = true
    var cellsPerLineOverride: Int? = nil
    var useChosungForm: Bool = false
    @Binding var isInteracting: Bool
    var maxCellWidth: CGFloat? = nil
    var accessibilityLabelOverride: String? = nil
    var accessibilityHintOverride: String? = nil
    var hideLabels: Bool = false
    var enableOneFingerSwipe: Bool = false
    var rawDotPatterns: [(dots: String, label: String)]? = nil
    var skipLeadingCells: Int = 0
    var centerVertically: Bool = false
    var onSwipeNext: (() -> Void)? = nil
    var onSwipePrevious: (() -> Void)? = nil

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
        view.maxCellWidth = maxCellWidth
        view.accessibilityLabelOverride = accessibilityLabelOverride
        view.accessibilityHintOverride = accessibilityHintOverride
        view.hideLabels = hideLabels
        view.enableOneFingerSwipe = enableOneFingerSwipe
        view.rawDotPatterns = rawDotPatterns
        view.skipLeadingCells = skipLeadingCells
        view.centerVertically = centerVertically
        view.onSwipeNext = onSwipeNext
        view.onSwipePrevious = onSwipePrevious

        view.useChosungForm = useChosungForm
        updateSettings(for: view)
        view.useAbbreviations = useAbbreviations
        view.updateText(text)
        return view
    }

    func updateUIView(_ uiView: BrailleTouchCanvasView, context: Context) {
        uiView.maxCellWidth = maxCellWidth
        uiView.accessibilityLabelOverride = accessibilityLabelOverride
        uiView.accessibilityHintOverride = accessibilityHintOverride
        uiView.hideLabels = hideLabels
        uiView.enableOneFingerSwipe = enableOneFingerSwipe
        uiView.rawDotPatterns = rawDotPatterns
        uiView.skipLeadingCells = skipLeadingCells
        uiView.centerVertically = centerVertically
        uiView.onSwipeNext = onSwipeNext
        uiView.onSwipePrevious = onSwipePrevious
        uiView.useChosungForm = useChosungForm
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
