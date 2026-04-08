import Foundation

/// 퀴즈 문제 유형
enum QuizType: Sendable, Codable {
    case multipleChoice   // 객관식: 3개 보기 중 정답 선택
    case oxQuestion       // O/X: 제시된 점자가 맞는지 판별
}

/// 퀴즈 문제 데이터
struct QuizQuestion: Identifiable, Sendable, Codable {
    let id: UUID
    let type: QuizType
    let questionText: String            // "다음 중 'ㄱ'의 점자를 고르세요"
    let correctItem: BrailleLetterItem  // 정답 아이템
    let choices: [BrailleLetterItem]    // 객관식 보기 (정답 포함, 셔플됨)
    let displayedItem: BrailleLetterItem? // O/X용: 화면에 표시할 점자
    let isCorrectPairing: Bool?         // O/X용: 표시된 점자가 정답인지
    let explanation: String?            // O/X용: 해설
    let categoryId: String

    /// 객관식 문제 생성
    static func multipleChoice(
        questionText: String,
        correctItem: BrailleLetterItem,
        choices: [BrailleLetterItem],
        categoryId: String
    ) -> QuizQuestion {
        QuizQuestion(
            id: UUID(),
            type: .multipleChoice,
            questionText: questionText,
            correctItem: correctItem,
            choices: choices,
            displayedItem: nil,
            isCorrectPairing: nil,
            explanation: nil,
            categoryId: categoryId
        )
    }

    /// O/X 문제 생성
    static func ox(
        questionText: String,
        correctItem: BrailleLetterItem,
        displayedItem: BrailleLetterItem,
        isCorrectPairing: Bool,
        explanation: String,
        categoryId: String
    ) -> QuizQuestion {
        QuizQuestion(
            id: UUID(),
            type: .oxQuestion,
            questionText: questionText,
            correctItem: correctItem,
            choices: [],
            displayedItem: displayedItem,
            isCorrectPairing: isCorrectPairing,
            explanation: explanation,
            categoryId: categoryId
        )
    }
}
