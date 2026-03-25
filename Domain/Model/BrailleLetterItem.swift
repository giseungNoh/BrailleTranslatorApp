import Foundation

/// 커리큘럼 전체에서 공유하는 점자 글자 데이터 모델
struct BrailleLetterItem {
    let name: String        // VoiceOver용 이름 ("기역", "아")
    let letter: String      // 표시 글자 ("ㄱ", "ㅏ")
    let dotLabel: String    // 점형 설명 ("4점", "1·2·6점")

    /// "4점" → [4], "1·4점" → [1, 4]
    var activeDotNumbers: Set<Int> {
        Set(dotLabel.replacingOccurrences(of: "점", with: "")
            .split(separator: "·")
            .compactMap { Int($0.trimmingCharacters(in: .whitespaces)) })
    }
}
