import SwiftData
import Foundation

@Model
class SavedWord {
    var id: UUID
    var text: String        // "사랑해" (사용자 입력)
    var braille: String     // "⠂⠣⠃⠇⠚" (변환된 점자)
    var timestamp: Date     // 저장 날짜 (최신순 정렬용)
    
    init(text: String, braille: String) {
        self.id = UUID()
        self.text = text
        self.braille = braille
        self.timestamp = Date()
    }
}
