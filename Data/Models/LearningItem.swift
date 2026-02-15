import SwiftData
import Foundation

@Model
class LearningItem {
    @Attribute(.unique) var day: Int // 1일차, 2일차... (고유 키)
    var title: String                // "점자의 첫걸음"
    var subtitle: String             // "구조 익히기"
    var isCompleted: Bool            // 학습 완료 여부 (체크박스)
    
    init(day: Int, title: String, subtitle: String, isCompleted: Bool = false) {
        self.day = day
        self.title = title
        self.subtitle = subtitle
        self.isCompleted = isCompleted
    }
}
