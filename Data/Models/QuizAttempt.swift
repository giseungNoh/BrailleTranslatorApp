import Foundation
import SwiftData

/// 퀴즈 시도 기록 — 오답 노트에 사용
@Model
class QuizAttempt {
    var id: UUID
    var categoryId: String
    var questionText: String
    var correctLetter: String
    var correctDotLabel: String
    var correctRawDots: String?
    var userSelectedLetter: String
    var isCorrect: Bool
    var timestamp: Date
    /// O/X 규칙 문제 여부
    var isOXQuestion: Bool = false
    /// O/X 해설 텍스트
    var explanation: String?

    init(
        categoryId: String,
        questionText: String,
        correctLetter: String,
        correctDotLabel: String,
        correctRawDots: String? = nil,
        userSelectedLetter: String,
        isCorrect: Bool,
        isOXQuestion: Bool = false,
        explanation: String? = nil
    ) {
        self.id = UUID()
        self.categoryId = categoryId
        self.questionText = questionText
        self.correctLetter = correctLetter
        self.correctDotLabel = correctDotLabel
        self.correctRawDots = correctRawDots
        self.userSelectedLetter = userSelectedLetter
        self.isCorrect = isCorrect
        self.timestamp = Date()
        self.isOXQuestion = isOXQuestion
        self.explanation = explanation
    }
}
