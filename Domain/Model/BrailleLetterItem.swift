import Foundation

/// 커리큘럼 전체에서 공유하는 점자 글자 데이터 모델
struct BrailleLetterItem: Sendable, Codable {
    let name: String        // VoiceOver용 이름 ("기역", "아")
    let letter: String      // 표시 글자 ("ㄱ", "ㅏ")
    let dotLabel: String    // 점형 설명 ("4점", "1·2·6점")
    var cellsPerLine: Int?  // nil이면 뷰의 기본값 사용
    var rawDots: String?    // 번역기 우회, 직접 점형 표시 ("1", "25" 등)
    var rawDotLabels: String?  // rawDots 셀별 레이블 ("ㄱ,억" — 콤마 구분, rawDots 셀 수와 동일)
    var fromDotLabel: String?  // 변환 전 점형 (설명뷰에서 → 표시용)

    /// "4점" → [4], "1·4점" → [1, 4]
    var activeDotNumbers: Set<Int> {
        parseDots(from: dotLabel)
    }

    /// fromDotLabel의 활성 점 번호
    var fromActiveDotNumbers: Set<Int> {
        guard let from = fromDotLabel else { return [] }
        return parseDots(from: from)
    }

    /// 복합 점형 여부: "ㄱ(1점) + ㅅ(3점)" 형태인지
    var isCompoundDot: Bool {
        dotLabel.contains(" + ")
    }

    /// 복합 점형을 셀별 점 번호 배열로 파싱: "ㄱ(1점) + ㅅ(3점)" → [[1], [3]]
    var compoundDotSets: [Set<Int>] {
        dotLabel.components(separatedBy: " + ").map { part in
            // "ㄱ(1점)" → 괄호 안 "1점" 추출 → parseDots
            if let open = part.firstIndex(of: "("),
               let close = part.firstIndex(of: ")") {
                let inner = String(part[part.index(after: open)..<close])
                return parseDots(from: inner)
            }
            return parseDots(from: part)
        }
    }

    private func parseDots(from label: String) -> Set<Int> {
        // "연(1·6점)" 같은 형식이면 괄호 안 내용만 추출
        let target: String
        if let open = label.firstIndex(of: "("),
           let close = label.firstIndex(of: ")") {
            target = String(label[label.index(after: open)..<close])
        } else {
            target = label
        }
        return Set(target.replacingOccurrences(of: "점", with: "")
            .split(separator: "·")
            .compactMap { Int($0.trimmingCharacters(in: .whitespaces)) })
    }
}
