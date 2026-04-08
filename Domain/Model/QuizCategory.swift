import Foundation

/// 퀴즈 카테고리 정의
struct QuizCategory: Identifiable, Sendable {
    let id: String
    let title: String           // "기본 자음"
    let subtitle: String        // "ㄱ·ㄴ·ㄷ·ㄹ·ㅁ·ㅂ·ㅅ·ㅈ·ㅊ"
    let section: Int            // 섹션 번호 (1: 감각 깨우기, 2: 한글 기초, 3: 실전 규칙)
    let questionPool: @Sendable () -> [BrailleLetterItem]

    /// 문제 수 = 객관식 아이템 수 + O/X 규칙 문제 수
    var questionCount: Int {
        let poolCount = questionPool().count
        let oxCount = quizOXRules[id]?.count ?? 0
        return poolCount + oxCount
    }
}
