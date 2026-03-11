import SwiftUI
import Combine

class BrailleSettings: ObservableObject {
    
    @AppStorage("cellsPerLine") var cellsPerLine: Int = 4
    @AppStorage("activeDotIntensity") var activeDotIntensity: Double = 1.0
    @AppStorage("inactiveDotIntensity") var inactiveDotIntensity: Double = 0.5
    @AppStorage("isInactiveDotFeedbackEnabled") var isInactiveDotFeedbackEnabled: Bool = true
    
    // 점자 크기를 셀 단위로 관리합니다.
    // 1(가장 큼) ~ 8(가장 작음)
    
    func resetToDefaults() {
        cellsPerLine = 4
        activeDotIntensity = 1.0
        inactiveDotIntensity = 0.5
        isInactiveDotFeedbackEnabled = true
    }
}

