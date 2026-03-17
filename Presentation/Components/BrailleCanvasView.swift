import SwiftUI
import UIKit

struct BrailleCanvasView: View {
    let text: String
    var useAbbreviations: Bool = true
    @Binding var isInteracting: Bool

    init(text: String, useAbbreviations: Bool = true, isInteracting: Binding<Bool> = .constant(false)) {
        self.text = text
        self.useAbbreviations = useAbbreviations
        self._isInteracting = isInteracting
    }

    var body: some View {
        BrailleTouchCanvasViewRepresentable(text: text, useAbbreviations: useAbbreviations, isInteracting: $isInteracting)
            .background(Color.clear)
    }
}

struct BrailleTouchCanvasViewRepresentable: UIViewRepresentable {
    let text: String
    var useAbbreviations: Bool = true
    @Binding var isInteracting: Bool
    
    // UserDefaults 변경 감지 (설정 즉시 반영)
    @AppStorage("cellsPerLine") private var cellsPerLine: Int = 4
    @AppStorage("activeDotIntensity") private var activeDotIntensity: Double = 1.0
    @AppStorage("inactiveDotIntensity") private var inactiveDotIntensity: Double = 0.5
    @AppStorage("isInactiveDotFeedbackEnabled") private var isInactiveDotFeedbackEnabled: Bool = true
    
    func makeUIView(context: Context) -> BrailleTouchCanvasView {
        let view = BrailleTouchCanvasView()
        
        view.onTouchStateChanged = { isTouching in
            // 메인 스레드에서 상태 업데이트 보장
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
        // 뷰의 settings 객체에 값 주입
        view.settings.cellsPerLine = cellsPerLine
        view.settings.activeDotIntensity = activeDotIntensity
        view.settings.inactiveDotIntensity = inactiveDotIntensity
        view.settings.isInactiveDotFeedbackEnabled = isInactiveDotFeedbackEnabled
        
        // 설정 변경 알림 (레이아웃 갱신 트리거)
        // 새로운 Settings 객체 생성해서 할당하여 didSet 트리거
        let newSettings = BrailleSettings()
        newSettings.cellsPerLine = cellsPerLine
        newSettings.activeDotIntensity = activeDotIntensity
        newSettings.inactiveDotIntensity = inactiveDotIntensity
        newSettings.isInactiveDotFeedbackEnabled = isInactiveDotFeedbackEnabled
        
        view.settings = newSettings
    }
}
