import SwiftUI
import Combine

// MARK: - BrailleDisplayConfig
// BrailleTouchCanvasView에 전달하는 순수 값 타입 설정.
// @AppStorage와 무관하므로 값을 변경해도 UserDefaults에 영향 없음.
struct BrailleDisplayConfig: Equatable {
    var cellsPerLine: Int = 4
    var activeDotIntensity: Double = 1.0
    var inactiveDotIntensity: Double = 0.5
    var isInactiveDotFeedbackEnabled: Bool = true
    var isDotNumberAnnouncementEnabled: Bool = true
}

// MARK: - BrailleSettings
// 설정 화면에서 UserDefaults를 읽고 쓰는 용도.
class BrailleSettings: ObservableObject {

    @AppStorage("cellsPerLine") var cellsPerLine: Int = 4
    @AppStorage("activeDotIntensity") var activeDotIntensity: Double = 1.0
    @AppStorage("inactiveDotIntensity") var inactiveDotIntensity: Double = 0.5
    @AppStorage("isInactiveDotFeedbackEnabled") var isInactiveDotFeedbackEnabled: Bool = true
    @AppStorage("isDotNumberAnnouncementEnabled") var isDotNumberAnnouncementEnabled: Bool = true
    @AppStorage("appFontSize") var appFontSize: Int = 0 // -1=작게, 0=기본, 1=크게, 2=아주 크게

    // 점자 크기를 셀 단위로 관리합니다.
    // 1(가장 큼) ~ 8(가장 작음)

    func resetToDefaults() {
        cellsPerLine = 4
        activeDotIntensity = 1.0
        inactiveDotIntensity = 0.5
        isInactiveDotFeedbackEnabled = true
        isDotNumberAnnouncementEnabled = true
        appFontSize = 0
    }
}

