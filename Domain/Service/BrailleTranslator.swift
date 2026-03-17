import Foundation

class BrailleTranslator {

    // MARK: - Constants

    private let NUMBER_PREFIX = "3456"
    private let DOUBLE_CONSONANT_PREFIX = "6"
    private let SINGLE_CONSONANT_PREFIX = "456"

    // MARK: - Mapping Dictionaries

    // 초성 (ㅇ 은 음절 안에서 빈칸, 단독 입력 시에는 1245)
    private let chosungMap: [String: String] = [
        "ㄱ": "4",   "ㄴ": "14",  "ㄷ": "24",  "ㄹ": "5",   "ㅁ": "15",
        "ㅂ": "45",  "ㅅ": "6",   "ㅈ": "46",  "ㅊ": "56",  "ㅋ": "124",
        "ㅌ": "125", "ㅍ": "145", "ㅎ": "245", "ㅇ": "1245"
    ]

    // 된소리
    private let doubleChosungMap: [String: String] = [
        "ㄲ": "ㄱ", "ㄸ": "ㄷ", "ㅃ": "ㅂ", "ㅆ": "ㅅ", "ㅉ": "ㅈ"
    ]

    // 중성
    private let jungsungMap: [String: String] = [
        "ㅏ": "126",  "ㅑ": "345",  "ㅓ": "234",  "ㅕ": "156",  "ㅗ": "136",
        "ㅛ": "346",  "ㅜ": "134",  "ㅠ": "146",  "ㅡ": "246",  "ㅣ": "135",
        "ㅐ": "1235", "ㅔ": "1345", "ㅖ": "34",   "ㅘ": "1236", "ㅚ": "13456",
        "ㅝ": "1234", "ㅢ": "2456",
        // 조합 모음
        "ㅒ": "345,1235", "ㅙ": "1236,1235", "ㅞ": "1234,1235", "ㅟ": "134,1235"
    ]

    // 종성
    private let jongsungMap: [String: String] = [
        "ㄱ": "1",   "ㄴ": "25",  "ㄷ": "35",  "ㄹ": "2",    "ㅁ": "26",
        "ㅂ": "12",  "ㅅ": "3",   "ㅇ": "2356","ㅈ": "13",   "ㅊ": "23",
        "ㅋ": "235", "ㅌ": "236", "ㅍ": "256", "ㅎ": "356",
        "ㄲ": "1,1", "ㅆ": "34",
        // 겹받침
        "ㄳ": "1,3",    "ㄵ": "25,13",  "ㄶ": "25,356", "ㄺ": "2,1",   "ㄻ": "2,26",
        "ㄼ": "2,12",   "ㄽ": "2,3",    "ㄾ": "2,236",  "ㄿ": "2,256", "ㅀ": "2,356",
        "ㅄ": "12,3"
    ]

    // MARK: - 14개 모음+받침 조합 약자 딕셔너리
    private let vowelJongseongMap: [String: String] = [
        "ㅓㄱ": "1456", "ㅓㄴ": "23456", "ㅓㄹ": "2345",
        "ㅕㄴ": "16",   "ㅕㄹ": "1256",  "ㅕㅇ": "12456",
        "ㅗㄱ": "1346", "ㅗㄴ": "12356", "ㅗㅇ": "123456",
        "ㅜㄴ": "1245", "ㅜㄹ": "12346",
        "ㅡㄴ": "1356", "ㅡㄹ": "2346",
        "ㅣㄴ": "12345"
    ]

    // 숫자
    private let numberMap: [Character: String] = [
        "1": "1", "2": "12", "3": "14", "4": "145", "5": "15",
        "6": "124", "7": "1245", "8": "125", "9": "24", "0": "245"
    ]

    // 문장 부호
    private let punctuationMap: [Character: String] = [
        "?": "236", "!": "235", ".": "256", ",": "5",
        ":": "5", ";": "56", "-": "36", "~": "36,36",
        "\u{201C}": "236", "\u{201D}": "356", "\u{2018}": "236", "\u{2019}": "356",
        "(": "236", ")": "356"
    ]

    // 영어 소문자
    private let englishMap: [Character: String] = [
        "a": "1",    "b": "12",   "c": "14",   "d": "145",  "e": "15",
        "f": "124",  "g": "1245", "h": "125",  "i": "24",   "j": "245",
        "k": "13",   "l": "123",  "m": "134",  "n": "1345", "o": "135",
        "p": "1234", "q": "12345","r": "1235", "s": "234",  "t": "2345",
        "u": "136",  "v": "1236", "w": "2456", "x": "1346", "y": "13456", "z": "1356"
    ]

    // 약어 (Private Use Area 마커로 전처리)
    private let abbrKeys = ["그래서", "그러나", "그러면", "그러므로", "그런데", "그리고", "그리하여"]
    private let abbrDots = ["4,234", "1,14", "1,25", "1,26", "1,1345", "1,136", "1,56"]

    // MARK: - Translation Logic

    func translate(_ input: String, useAbbreviations: Bool = true) -> [String] {
        var result: [String] = []
        var isNumberMode = false

        let preprocessedText = useAbbreviations ? preprocessAbbreviations(input) : input
        let chars = Array(preprocessedText)

        for (i, char) in chars.enumerated() {
            // 약어 마커 처리 (U+E000~)
            if let scalar = char.unicodeScalars.first, scalar.value >= 0xE000 && scalar.value < 0xE008 {
                let index = Int(scalar.value - 0xE000)
                let parts = abbrDots[index].split(separator: ",")
                result.append(contentsOf: parts.map { String($0) })
                isNumberMode = false
                continue
            }

            if let numberDots = numberMap[char] {
                if !isNumberMode {
                    result.append(NUMBER_PREFIX)
                    isNumberMode = true
                }
                result.append(numberDots)
                continue
            }

            if isNumberMode && (char == ":" || char == "-" || char == "·") {
                if let puncDots = punctuationMap[char] { result.append(puncDots) }
                isNumberMode = false
                continue
            }
            isNumberMode = false

            if char.isLetter, let engDots = englishMap[Character(char.lowercased())] {
                result.append(engDots)
                continue
            }

            if let puncDots = punctuationMap[char] {
                let parts = puncDots.split(separator: ",")
                result.append(contentsOf: parts.map { String($0) })
                continue
            }

            if isHangul(char) {
                let nextChar: Character? = (i + 1 < chars.count) ? chars[i + 1] : nil
                result.append(contentsOf: extractJamoDots(from: char, nextChar: nextChar, useAbbreviations: useAbbreviations))
            } else if char.isWhitespace {
                result.append("")
            }
        }
        return result
    }

    // MARK: - Helper Methods

    private func preprocessAbbreviations(_ text: String) -> String {
        var str = text
        for (i, key) in abbrKeys.enumerated() {
            let marker = String(Character(UnicodeScalar(0xE000 + i)!))
            str = str.replacingOccurrences(of: key, with: marker)
        }
        return str
    }

    private func isHangul(_ char: Character) -> Bool {
        guard let scalar = char.unicodeScalars.first else { return false }
        if scalar.value >= 0xAC00 && scalar.value <= 0xD7A3 { return true }
        if scalar.value >= 0x3131 && scalar.value <= 0x314E { return true }
        if scalar.value >= 0x314F && scalar.value <= 0x3163 { return true }
        return false
    }

    private func extractJamoDots(from char: Character, nextChar: Character?, useAbbreviations: Bool = true) -> [String] {
        guard let scalar = char.unicodeScalars.first else { return [] }
        let value = scalar.value
        var dots: [String] = []

        // MARK: 단독 자음 (ㄱ~ㅎ)
        if value >= 0x3131 && value <= 0x314E {
            let jamoList = ["ㄱ","ㄲ","ㄳ","ㄴ","ㄵ","ㄶ","ㄷ","ㄸ","ㄹ","ㄺ","ㄻ","ㄼ","ㄽ","ㄾ","ㄿ","ㅀ","ㅁ","ㅂ","ㅃ","ㅄ","ㅅ","ㅆ","ㅇ","ㅈ","ㅉ","ㅊ","ㅋ","ㅌ","ㅍ","ㅎ"]
            let ch = jamoList[Int(value - 0x3131)]
            if let base = doubleChosungMap[ch] {
                dots.append(DOUBLE_CONSONANT_PREFIX)
                if let d = chosungMap[base] { dots.append(d) }
            } else if let d = chosungMap[ch] {
                dots.append(d)
            } else {
                dots.append(SINGLE_CONSONANT_PREFIX)
                if let d = jongsungMap[ch] {
                    dots.append(contentsOf: d.split(separator: ",").map { String($0) })
                }
            }
            return dots
        }

        // MARK: 단독 모음 (ㅏ~ㅣ)
        if value >= 0x314F && value <= 0x3163 {
            let jungsungList = ["ㅏ","ㅐ","ㅑ","ㅒ","ㅓ","ㅔ","ㅕ","ㅖ","ㅗ","ㅘ","ㅙ","ㅚ","ㅛ","ㅜ","ㅝ","ㅞ","ㅟ","ㅠ","ㅡ","ㅢ","ㅣ"]
            let ch = jungsungList[Int(value - 0x314F)]
            if let d = jungsungMap[ch] {
                dots.append(contentsOf: d.split(separator: ",").map { String($0) })
            }
            return dots
        }

        // MARK: 완성형 한글 (가~힣)
        guard value >= 0xAC00 && value <= 0xD7A3 else { return [] }

        let chosungList  = ["ㄱ","ㄲ","ㄴ","ㄷ","ㄸ","ㄹ","ㅁ","ㅂ","ㅃ","ㅅ","ㅆ","ㅇ","ㅈ","ㅉ","ㅊ","ㅋ","ㅌ","ㅍ","ㅎ"]
        let jungsungList = ["ㅏ","ㅐ","ㅑ","ㅒ","ㅓ","ㅔ","ㅕ","ㅖ","ㅗ","ㅘ","ㅙ","ㅚ","ㅛ","ㅜ","ㅝ","ㅞ","ㅟ","ㅠ","ㅡ","ㅢ","ㅣ"]
        let jongsungList = ["","ㄱ","ㄲ","ㄳ","ㄴ","ㄵ","ㄶ","ㄷ","ㄹ","ㄺ","ㄻ","ㄼ","ㄽ","ㄾ","ㄿ","ㅀ","ㅁ","ㅂ","ㅄ","ㅅ","ㅆ","ㅇ","ㅈ","ㅊ","ㅋ","ㅌ","ㅍ","ㅎ"]

        let idx       = value - 0xAC00
        let choIndex  = Int(idx / (21 * 28))
        let jungIndex = Int((idx % (21 * 28)) / 28)
        let jongIndex = Int(idx % 28)

        let choChar  = chosungList[choIndex]
        let jungChar = jungsungList[jungIndex]
        let jongChar = jongIndex > 0 ? jongsungList[jongIndex] : ""

        // 초성(된소리 포함) 추가 헬퍼
        func appendChosung(_ cho: String) {
            if let base = doubleChosungMap[cho] {
                dots.append(DOUBLE_CONSONANT_PREFIX)
                if let d = chosungMap[base] { dots.append(d) }
            } else if cho != "ㅇ" {
                if let d = chosungMap[cho] { dots.append(d) }
            }
        }

        if useAbbreviations {
            // 1. 단어 약자: 것, 껏
            if char == "것" { return ["456", "234"] }
            if char == "껏" { return ["6", "456", "234"] }

            // 2. 가/까/사/싸 약자 (받침 있어도 적용)
            if jungChar == "ㅏ" && ["ㄱ", "ㄲ", "ㅅ", "ㅆ"].contains(choChar) {
                if choChar == "ㄲ" || choChar == "ㅆ" { dots.append(DOUBLE_CONSONANT_PREFIX) }
                let baseCho = (choChar == "ㄲ") ? "ㄱ" : (choChar == "ㅆ" ? "ㅅ" : choChar)
                dots.append(baseCho == "ㄱ" ? "1246" : "123")
                if jongIndex > 0, let d = jongsungMap[jongChar] {
                    dots.append(contentsOf: d.split(separator: ",").map { String($0) })
                }
                return dots
            }

            // 3. 성/썽/정/쩡/청 등: ㅓ+ㅇ 받침 → 영 약자(12456) 사용
            if jungChar == "ㅓ" && jongChar == "ㅇ" && ["ㅅ", "ㅆ", "ㅈ", "ㅉ", "ㅊ"].contains(choChar) {
                appendChosung(choChar)
                dots.append("12456")
                return dots
            }

            // 4. 모음+받침 약자 (vowelJongseongMap)
            if jongIndex > 0 {
                let key = jungChar + jongChar
                if let contraction = vowelJongseongMap[key] {
                    appendChosung(choChar)
                    dots.append(contraction)
                    return dots
                }
            }

            // 5. ㅏ 생략 약자 (나/다/마/바/자/카/타/파/하 및 된소리)
            let aOmissionCho = ["ㄴ", "ㄷ", "ㄸ", "ㅁ", "ㅂ", "ㅃ", "ㅈ", "ㅉ", "ㅋ", "ㅌ", "ㅍ", "ㅎ"]
            var omitA = false

            if jungChar == "ㅏ" && aOmissionCho.contains(choChar) {
                omitA = true
                if char == "팠" { omitA = false }

                if let next = nextChar, isHangul(next),
                   let nextScalar = next.unicodeScalars.first {
                    let nextValue = nextScalar.value
                    if nextValue >= 0xAC00 && nextValue <= 0xD7A3 {
                        let nextChoIndex = Int((nextValue - 0xAC00) / (21 * 28))
                        if chosungList[nextChoIndex] == "ㅇ" { omitA = false }
                    }
                }
            }

            // 6-약자. 기본 조합 (약자 모드)
            appendChosung(choChar)

            if !omitA {
                if let d = jungsungMap[jungChar] {
                    dots.append(contentsOf: d.split(separator: ",").map { String($0) })
                }
            }

            if jongIndex > 0, let d = jongsungMap[jongChar] {
                dots.append(contentsOf: d.split(separator: ",").map { String($0) })
            }

            return dots
        }

        // 6. 기본 조합 (약자 미사용)
        appendChosung(choChar)

        if let d = jungsungMap[jungChar] {
            dots.append(contentsOf: d.split(separator: ",").map { String($0) })
        }

        if jongIndex > 0, let d = jongsungMap[jongChar] {
            dots.append(contentsOf: d.split(separator: ",").map { String($0) })
        }

        return dots
    }
}
