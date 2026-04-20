import Foundation

extension String {
    /// VoiceOver가 특히 잘 읽지 못하거나, 잘못 발음하는 기호 및 자음(겹받침 등)을 
    /// 자연스럽게 읽을 수 있도록 변환합니다.
    func toAccessibilityPronunciation() -> String {
        var result = self
        
        // 1) 물결표(~) 처리
        // 예: "1장~3장" -> "1장부터 3장", "~은" -> "부터은"(자연스럽기 위해 띄어쓰기 등 고려)
        // 상황상 단독 "~" 이거나 "~" 가 포함된 경우 "부터"로 읽게 해달라는 요청 반영
        result = result.replacingOccurrences(of: "~", with: "부터")
        
        // 2) 겹받침 / 쌍자음 처리
        // 아이폰 VoiceOver가 단독으로 있는 ㄲ, ㅃ 등을 잘못 읽을 수 있어 수동 변환
        result = result.replacingOccurrences(of: "ㄲ", with: "쌍기역")
        result = result.replacingOccurrences(of: "ㄸ", with: "쌍디귿")
        result = result.replacingOccurrences(of: "ㅃ", with: "쌍비읍")
        result = result.replacingOccurrences(of: "ㅆ", with: "쌍시옷")
        result = result.replacingOccurrences(of: "ㅉ", with: "쌍지읒")
        
        // 3) 겹받침 처리
        result = result.replacingOccurrences(of: "ㄳ", with: "기역 시옷")
        result = result.replacingOccurrences(of: "ㄵ", with: "니은 지읒")
        result = result.replacingOccurrences(of: "ㄶ", with: "니은 히읗")
        result = result.replacingOccurrences(of: "ㄺ", with: "리을 기역")
        result = result.replacingOccurrences(of: "ㄻ", with: "리을 미음")
        result = result.replacingOccurrences(of: "ㄼ", with: "리을 비읍")
        result = result.replacingOccurrences(of: "ㄽ", with: "리을 시옷")
        result = result.replacingOccurrences(of: "ㄾ", with: "리을 티읕")
        result = result.replacingOccurrences(of: "ㄿ", with: "리을 피읖")
        result = result.replacingOccurrences(of: "ㅀ", with: "리을 히읗")
        result = result.replacingOccurrences(of: "ㅄ", with: "비읍 시옷")

        // 4) 단독 모음 발음 오류 보정 (VoiceOver가 단독 자모 모음을 잘못 읽는 문제)
        result = result.replacingOccurrences(of: "ㅑ", with: "야")
        result = result.replacingOccurrences(of: "ㅓ", with: "어")

        // 5) 중복 낭독 방지: "이응(o)" 또는 "기역(ㄱ)" 형태에서 괄호 부분 제거
        // 한글 단어 이름 뒤에 시각적 확인용으로 붙은 한 글자(영문, 자모 등) 괄호는 보이스오버에서 중복으로 읽으므로 삭제합니다.
        let pattern = "([가-힣]+)\\s*\\(([a-zA-Zㄱ-ㅎㅏ-ㅣ])\\)"
        if let regex = try? NSRegularExpression(pattern: pattern) {
            let range = NSRange(location: 0, length: result.utf16.count)
            result = regex.stringByReplacingMatches(in: result, range: range, withTemplate: "$1")
        }
        
        return result
    }
}
