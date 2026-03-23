import Foundation

class BrailleTranslator {

    // MARK: - Constants

    private let NUMBER_PREFIX = "3456"
    private let DOUBLE_CONSONANT_PREFIX = "6"
    private let SINGLE_CONSONANT_PREFIX = "456"

    private let STANDALONE_JAMO_PREFIX = "123456" // 온표: 단독 자음/모음 앞에 붙임

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

    // 겹받침 → (첫 번째 자음, 두 번째 자음) 분리
    private let compoundJongsungMap: [String: (String, String)] = [
        "ㄳ": ("ㄱ", "ㅅ"), "ㄵ": ("ㄴ", "ㅈ"), "ㄶ": ("ㄴ", "ㅎ"),
        "ㄺ": ("ㄹ", "ㄱ"), "ㄻ": ("ㄹ", "ㅁ"), "ㄼ": ("ㄹ", "ㅂ"),
        "ㄽ": ("ㄹ", "ㅅ"), "ㄾ": ("ㄹ", "ㅌ"), "ㄿ": ("ㄹ", "ㅍ"),
        "ㅀ": ("ㄹ", "ㅎ"), "ㅄ": ("ㅂ", "ㅅ"), "ㄲ": ("ㄱ", "ㄱ")
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
        var capitalMode: Int = 0      // 0=개별, 1=단어표, 2=구절표
        var phraseEndIndex: Int = -1
        var inRomanMode = false
        let needsRomanIndicator = input.contains(where: { isHangul($0) }) // 한글이 있을 때만 로마자표 사용

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
                // 로마자표 (356): 한글이 포함된 문장에서만
                if needsRomanIndicator && !inRomanMode {
                    result.append("356")
                    inRomanMode = true
                }
                // 대문자 연속 시작 감지 (이전 글자가 대문자 영문이 아닐 때)
                let isUpperRunStart = char.isUppercase &&
                    (i == 0 || !isEnglishLetter(chars[i - 1]) || !chars[i - 1].isUppercase)
                if isUpperRunStart && capitalMode != 2 {
                    let analysis = analyzeCapitalMode(chars, from: i)
                    capitalMode = analysis.mode
                    if capitalMode == 2 {
                        phraseEndIndex = analysis.lastIndex
                        result.append("6"); result.append("6"); result.append("6")
                    } else if capitalMode == 1 {
                        result.append("6"); result.append("6")
                    }
                }
                // 개별 모드일 때만 글자별 대문자표
                if capitalMode == 0 && char.isUppercase {
                    result.append("6")
                }
                result.append(engDots)
                // 구절 종료
                if capitalMode == 2 && i == phraseEndIndex {
                    result.append("6"); result.append("3")
                    capitalMode = 0
                }
                // 단어표 모드: 다음 글자가 대문자 영문이 아니면 리셋
                if capitalMode == 1 {
                    let nextIsUpperEng = (i + 1 < chars.count) && isEnglishLetter(chars[i + 1]) && chars[i + 1].isUppercase
                    if !nextIsUpperEng { capitalMode = 0 }
                }
                // 로마자 종료표 (256): 한글이 포함된 문장에서만
                if needsRomanIndicator && !isRomanSectionContinuing(chars, after: i) {
                    result.append("256")
                    inRomanMode = false
                }
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
                // 제11항/제12항: 모음 연쇄 구분표
                if let next = nextChar, needsVowelSeparator(current: char, next: next) {
                    result.append("36")
                }
            } else if char.isWhitespace {
                result.append("")
            }
        }
        return result
    }

    // MARK: - Translation with Labels

    /// 번역 결과와 각 셀에 대응하는 레이블(자모/음절)을 함께 반환합니다.
    func translateWithLabels(_ input: String, useAbbreviations: Bool = true, useChosungForm: Bool = false) -> [(dots: String, label: String)] {
        var result: [(dots: String, label: String)] = []
        var isNumberMode = false
        var capitalMode: Int = 0
        var phraseEndIndex: Int = -1
        var inRomanMode = false
        let needsRomanIndicator = input.contains(where: { isHangul($0) })

        let preprocessedText = useAbbreviations ? preprocessAbbreviations(input) : input
        let chars = Array(preprocessedText)

        for (i, char) in chars.enumerated() {
            if let scalar = char.unicodeScalars.first, scalar.value >= 0xE000 && scalar.value < 0xE008 {
                let index = Int(scalar.value - 0xE000)
                let phrase = abbrKeys[index]
                let parts = abbrDots[index].split(separator: ",").map { String($0) }
                for (j, dots) in parts.enumerated() {
                    result.append((dots, j == 0 ? phrase : ""))
                }
                isNumberMode = false
                continue
            }

            if let numberDots = numberMap[char] {
                if !isNumberMode {
                    result.append((NUMBER_PREFIX, "#"))
                    isNumberMode = true
                }
                result.append((numberDots, String(char)))
                continue
            }

            if isNumberMode && (char == ":" || char == "-" || char == "·") {
                if let puncDots = punctuationMap[char] { result.append((puncDots, String(char))) }
                isNumberMode = false
                continue
            }
            isNumberMode = false

            if char.isLetter, let engDots = englishMap[Character(char.lowercased())] {
                // 로마자표 (356): 한글이 포함된 문장에서만
                if needsRomanIndicator && !inRomanMode {
                    result.append(("356", ""))
                    inRomanMode = true
                }
                let isUpperRunStart = char.isUppercase &&
                    (i == 0 || !isEnglishLetter(chars[i - 1]) || !chars[i - 1].isUppercase)
                if isUpperRunStart && capitalMode != 2 {
                    let analysis = analyzeCapitalMode(chars, from: i)
                    capitalMode = analysis.mode
                    if capitalMode == 2 {
                        phraseEndIndex = analysis.lastIndex
                        result.append(("6", "")); result.append(("6", "")); result.append(("6", ""))
                    } else if capitalMode == 1 {
                        result.append(("6", "")); result.append(("6", ""))
                    }
                }
                if capitalMode == 0 && char.isUppercase {
                    result.append(("6", ""))
                }
                result.append((engDots, String(char)))
                if capitalMode == 2 && i == phraseEndIndex {
                    result.append(("6", "")); result.append(("3", ""))
                    capitalMode = 0
                }
                if capitalMode == 1 {
                    let nextIsUpperEng = (i + 1 < chars.count) && isEnglishLetter(chars[i + 1]) && chars[i + 1].isUppercase
                    if !nextIsUpperEng { capitalMode = 0 }
                }
                // 로마자 종료표 (256): 한글이 포함된 문장에서만
                if needsRomanIndicator && !isRomanSectionContinuing(chars, after: i) {
                    result.append(("256", ""))
                    inRomanMode = false
                }
                continue
            }

            if let puncDots = punctuationMap[char] {
                let parts = puncDots.split(separator: ",").map { String($0) }
                for (j, dots) in parts.enumerated() {
                    result.append((dots, j == 0 ? String(char) : ""))
                }
                continue
            }

            if isHangul(char) {
                let nextChar: Character? = (i + 1 < chars.count) ? chars[i + 1] : nil
                result.append(contentsOf: extractJamoDotsWithLabels(from: char, nextChar: nextChar, useAbbreviations: useAbbreviations, useChosungForm: useChosungForm))
                // 제11항/제12항: 모음 연쇄 구분표
                if let next = nextChar, needsVowelSeparator(current: char, next: next) {
                    result.append(("36", ""))
                }
            } else if char.isWhitespace {
                result.append(("", " "))
            }
        }
        return result
    }

    private func extractJamoDotsWithLabels(from char: Character, nextChar: Character?, useAbbreviations: Bool, useChosungForm: Bool = false) -> [(String, String)] {
        guard let scalar = char.unicodeScalars.first else { return [] }
        let value = scalar.value
        var pairs: [(String, String)] = []

        // 단독 자음
        if value >= 0x3131 && value <= 0x314E {
            let jamoList = ["ㄱ","ㄲ","ㄳ","ㄴ","ㄵ","ㄶ","ㄷ","ㄸ","ㄹ","ㄺ","ㄻ","ㄼ","ㄽ","ㄾ","ㄿ","ㅀ","ㅁ","ㅂ","ㅃ","ㅄ","ㅅ","ㅆ","ㅇ","ㅈ","ㅉ","ㅊ","ㅋ","ㅌ","ㅍ","ㅎ"]
            let ch = jamoList[Int(value - 0x3131)]

            // 초성 형태: 온표 없이 초성 점형만 사용 (커리큘럼용)
            if useChosungForm {
                if let base = doubleChosungMap[ch] {
                    pairs.append((DOUBLE_CONSONANT_PREFIX, ""))
                    if let d = chosungMap[base] { pairs.append((d, ch)) }
                } else if let d = chosungMap[ch] {
                    pairs.append((d, ch))
                }
                return pairs
            }

            // 기본 형태: 온표 + 받침
            pairs.append((STANDALONE_JAMO_PREFIX, ""))
            if let base = doubleChosungMap[ch] {
                // 된소리 단독: 온표 + 기본자음 받침 2번 반복
                if let d = jongsungMap[base] {
                    let parts = d.split(separator: ",").map { String($0) }
                    for (j, p) in parts.enumerated() { pairs.append((p, j == 0 ? ch : "")) }
                    for p in parts { pairs.append((p, "")) }
                }
            } else if let d = jongsungMap[ch] {
                for (j, p) in d.split(separator: ",").enumerated() { pairs.append((String(p), j == 0 ? ch : "")) }
            }
            return pairs
        }

        // 단독 모음: 온표 + 모음 (useChosungForm이면 온표 생략)
        if value >= 0x314F && value <= 0x3163 {
            let jungsungList = ["ㅏ","ㅐ","ㅑ","ㅒ","ㅓ","ㅔ","ㅕ","ㅖ","ㅗ","ㅘ","ㅙ","ㅚ","ㅛ","ㅜ","ㅝ","ㅞ","ㅟ","ㅠ","ㅡ","ㅢ","ㅣ"]
            let ch = jungsungList[Int(value - 0x314F)]
            if !useChosungForm {
                pairs.append((STANDALONE_JAMO_PREFIX, ""))
            }
            if let d = jungsungMap[ch] {
                for (j, p) in d.split(separator: ",").enumerated() { pairs.append((String(p), j == 0 ? ch : "")) }
            }
            return pairs
        }

        guard value >= 0xAC00 && value <= 0xD7A3 else { return [] }

        let charLabel = String(char)
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

        // 초성 셀 추가 (된소리표 prefix는 "" 레이블, 초성 셀은 지정 레이블)
        func appendChosungPairs(cho: String, mainLabel: String) {
            if let base = doubleChosungMap[cho] {
                pairs.append((DOUBLE_CONSONANT_PREFIX, ""))
                if let d = chosungMap[base] { pairs.append((d, mainLabel)) }
            } else if cho != "ㅇ" {
                if let d = chosungMap[cho] { pairs.append((d, mainLabel)) }
            }
        }

        if useAbbreviations {
            if char == "것" { return [("456", ""), ("234", "것")] }
            if char == "껏" { return [("6", ""), ("456", ""), ("234", "껏")] }

            // 가/까/사/싸: abbreviation 셀에 원래 음절 레이블
            if jungChar == "ㅏ" && ["ㄱ", "ㄲ", "ㅅ", "ㅆ"].contains(choChar) {
                if choChar == "ㄲ" || choChar == "ㅆ" { pairs.append((DOUBLE_CONSONANT_PREFIX, "")) }
                let baseCho = (choChar == "ㄲ") ? "ㄱ" : (choChar == "ㅆ" ? "ㅅ" : choChar)
                pairs.append((baseCho == "ㄱ" ? "1246" : "123", charLabel))
                if jongIndex > 0, let d = jongsungMap[jongChar] {
                    d.split(separator: ",").forEach { pairs.append((String($0), "")) }
                }
                return pairs
            }

            // ㅓ+ㅇ 예외: 약자 셀에 원래 음절 레이블
            if jungChar == "ㅓ" && jongChar == "ㅇ" && ["ㅅ", "ㅆ", "ㅈ", "ㅉ", "ㅊ"].contains(choChar) {
                appendChosungPairs(cho: choChar, mainLabel: "")
                pairs.append(("12456", charLabel))
                return pairs
            }

            // vowelJongseongMap: 약자 셀에 원래 음절 레이블
            if jongIndex > 0 {
                let key = jungChar + jongChar
                if let contraction = vowelJongseongMap[key] {
                    appendChosungPairs(cho: choChar, mainLabel: "")
                    pairs.append((contraction, charLabel))
                    return pairs
                }
                // 겹받침: 첫 자음으로 모음+받침 약자 매칭 시도, 나머지는 별도 받침
                if let (first, second) = compoundJongsungMap[jongChar] {
                    let compoundKey = jungChar + first
                    if let contraction = vowelJongseongMap[compoundKey] {
                        appendChosungPairs(cho: choChar, mainLabel: "")
                        pairs.append((contraction, charLabel))
                        if let d = jongsungMap[second] {
                            d.split(separator: ",").forEach { pairs.append((String($0), "")) }
                        }
                        return pairs
                    }
                }
            }

            // ㅏ 생략: 초성 셀에 원래 음절 레이블
            let aOmissionCho = ["ㄴ", "ㄷ", "ㄸ", "ㅁ", "ㅂ", "ㅃ", "ㅈ", "ㅉ", "ㅋ", "ㅌ", "ㅍ", "ㅎ"]
            if jungChar == "ㅏ" && aOmissionCho.contains(choChar) {
                var omitA = true
                if char == "팠" { omitA = false }
                // 받침이 없을 때만: 다음 글자 초성이 ㅇ이면 ㅏ 생략 취소
                if jongIndex == 0, let next = nextChar, isHangul(next), let nextScalar = next.unicodeScalars.first {
                    let nextValue = nextScalar.value
                    if nextValue >= 0xAC00 && nextValue <= 0xD7A3 {
                        let nextChoIndex = Int((nextValue - 0xAC00) / (21 * 28))
                        if chosungList[nextChoIndex] == "ㅇ" { omitA = false }
                    }
                }
                if omitA {
                    appendChosungPairs(cho: choChar, mainLabel: charLabel)
                    if jongIndex > 0, let d = jongsungMap[jongChar] {
                        d.split(separator: ",").forEach { pairs.append((String($0), "")) }
                    }
                    return pairs
                }
            }
        }

        // 기본 조합: 각 자모에 개별 레이블
        if choChar != "ㅇ" {
            if let base = doubleChosungMap[choChar] {
                pairs.append((DOUBLE_CONSONANT_PREFIX, ""))
                if let d = chosungMap[base] { pairs.append((d, choChar)) }
            } else {
                if let d = chosungMap[choChar] { pairs.append((d, choChar)) }
            }
        }

        if let d = jungsungMap[jungChar] {
            for (j, p) in d.split(separator: ",").enumerated() { pairs.append((String(p), j == 0 ? jungChar : "")) }
        }

        if jongIndex > 0, let d = jongsungMap[jongChar] {
            for (j, p) in d.split(separator: ",").enumerated() { pairs.append((String(p), j == 0 ? jongChar : "")) }
        }

        return pairs
    }

    // MARK: - Helper Methods

    private func preprocessAbbreviations(_ text: String) -> String {
        var str = text
        for (i, key) in abbrKeys.enumerated() {
            let marker = String(Character(UnicodeScalar(0xE000 + i)!))
            // 약어 앞에 다른 글자가 붙어 나오면 약어를 사용하지 않음
            var result = ""
            var searchRange = str.startIndex..<str.endIndex
            while let range = str.range(of: key, range: searchRange) {
                let isWordStart = range.lowerBound == str.startIndex ||
                    str[str.index(before: range.lowerBound)].isWhitespace
                result += str[searchRange.lowerBound..<range.lowerBound]
                result += isWordStart ? marker : key
                searchRange = range.upperBound..<str.endIndex
            }
            result += str[searchRange]
            str = result
        }
        return str
    }

    /// 제11항: 모음 + 예(ㅖ) 연쇄, 제12항: ㅑ/ㅘ/ㅜ/ㅝ + 애(ㅐ) 연쇄 시 구분표(36) 필요 여부
    private func needsVowelSeparator(current: Character, next: Character) -> Bool {
        guard let curScalar = current.unicodeScalars.first,
              let nextScalar = next.unicodeScalars.first else { return false }
        let curValue = curScalar.value
        let nextValue = nextScalar.value

        guard curValue >= 0xAC00 && curValue <= 0xD7A3,
              nextValue >= 0xAC00 && nextValue <= 0xD7A3 else { return false }

        let jungsungList = ["ㅏ","ㅐ","ㅑ","ㅒ","ㅓ","ㅔ","ㅕ","ㅖ","ㅗ","ㅘ","ㅙ","ㅚ","ㅛ","ㅜ","ㅝ","ㅞ","ㅟ","ㅠ","ㅡ","ㅢ","ㅣ"]
        let chosungList = ["ㄱ","ㄲ","ㄴ","ㄷ","ㄸ","ㄹ","ㅁ","ㅂ","ㅃ","ㅅ","ㅆ","ㅇ","ㅈ","ㅉ","ㅊ","ㅋ","ㅌ","ㅍ","ㅎ"]

        let curIdx = curValue - 0xAC00
        let curJungIndex = Int((curIdx % (21 * 28)) / 28)
        let curJongIndex = Int(curIdx % 28)

        let nextIdx = nextValue - 0xAC00
        let nextChoIndex = Int(nextIdx / (21 * 28))
        let nextJungIndex = Int((nextIdx % (21 * 28)) / 28)

        // 현재 음절에 받침이 없고, 다음 음절 초성이 ㅇ이어야 함
        guard curJongIndex == 0 else { return false }
        guard chosungList[nextChoIndex] == "ㅇ" else { return false }

        let nextJung = jungsungList[nextJungIndex]

        // 제11항: 모음 + 예(ㅖ)
        if nextJung == "ㅖ" { return true }

        // 제12항: ㅑ/ㅘ/ㅜ/ㅝ + 애(ㅐ)
        let curJung = jungsungList[curJungIndex]
        if ["ㅑ", "ㅘ", "ㅜ", "ㅝ"].contains(curJung) && nextJung == "ㅐ" { return true }

        return false
    }

    private func isEnglishLetter(_ char: Character) -> Bool {
        char.isLetter && englishMap[Character(char.lowercased())] != nil
    }

    /// 현재 영문 글자 뒤에 로마자 구간이 계속되는지 (공백 넘어서도 영문이 이어지면 true)
    private func isRomanSectionContinuing(_ chars: [Character], after index: Int) -> Bool {
        var j = index + 1
        while j < chars.count {
            if isEnglishLetter(chars[j]) { return true }
            if chars[j].isWhitespace { j += 1; continue }
            return false
        }
        return false
    }

    /// 영문 대문자 모드 분석: 0=개별(6), 1=단어표(6,6), 2=구절표(6,6,6...6,3)
    private func analyzeCapitalMode(_ chars: [Character], from index: Int) -> (mode: Int, lastIndex: Int) {
        // 현재 위치부터 연속 대문자 수 계산
        var i = index
        while i < chars.count && isEnglishLetter(chars[i]) && chars[i].isUppercase {
            i += 1
        }
        let runLength = i - index
        let runEnd = i - 1

        if runLength < 2 {
            return (0, index) // 1글자 → 개별 대문자표
        }

        // 2+ 연속 대문자 → 최소 단어표
        // 구절표 체크: 단어 시작 위치에서 3개+ 연속 전체 대문자 단어
        let isAtWordStart = (index == 0 || !isEnglishLetter(chars[index - 1]))
        if isAtWordStart {
            func scanUpperWord(from idx: Int) -> Int? {
                guard idx < chars.count && isEnglishLetter(chars[idx]) && chars[idx].isUppercase else { return nil }
                var j = idx
                while j < chars.count && isEnglishLetter(chars[j]) {
                    if !chars[j].isUppercase { return nil }
                    j += 1
                }
                return j - 1
            }

            var wordCount = 0
            var lastEnd = index
            var scanIdx = index

            while let wordEnd = scanUpperWord(from: scanIdx) {
                wordCount += 1
                lastEnd = wordEnd
                scanIdx = wordEnd + 1
                if scanIdx < chars.count && chars[scanIdx].isWhitespace {
                    scanIdx += 1
                } else {
                    break
                }
            }

            if wordCount >= 3 {
                return (2, lastEnd) // 구절표
            }
        }

        return (1, runEnd) // 단어표
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

        // MARK: 단독 자음 (ㄱ~ㅎ): 온표 + 받침 형태
        if value >= 0x3131 && value <= 0x314E {
            let jamoList = ["ㄱ","ㄲ","ㄳ","ㄴ","ㄵ","ㄶ","ㄷ","ㄸ","ㄹ","ㄺ","ㄻ","ㄼ","ㄽ","ㄾ","ㄿ","ㅀ","ㅁ","ㅂ","ㅃ","ㅄ","ㅅ","ㅆ","ㅇ","ㅈ","ㅉ","ㅊ","ㅋ","ㅌ","ㅍ","ㅎ"]
            let ch = jamoList[Int(value - 0x3131)]
            dots.append(STANDALONE_JAMO_PREFIX)
            if let base = doubleChosungMap[ch] {
                // 된소리 단독: 온표 + 기본자음 받침 2번 반복
                if let d = jongsungMap[base] {
                    let parts = d.split(separator: ",").map { String($0) }
                    dots.append(contentsOf: parts)
                    dots.append(contentsOf: parts)
                }
            } else if let d = jongsungMap[ch] {
                // 일반/겹받침: 온표 + 받침
                dots.append(contentsOf: d.split(separator: ",").map { String($0) })
            }
            return dots
        }

        // MARK: 단독 모음 (ㅏ~ㅣ): 온표 + 모음
        if value >= 0x314F && value <= 0x3163 {
            let jungsungList = ["ㅏ","ㅐ","ㅑ","ㅒ","ㅓ","ㅔ","ㅕ","ㅖ","ㅗ","ㅘ","ㅙ","ㅚ","ㅛ","ㅜ","ㅝ","ㅞ","ㅟ","ㅠ","ㅡ","ㅢ","ㅣ"]
            let ch = jungsungList[Int(value - 0x314F)]
            dots.append(STANDALONE_JAMO_PREFIX)
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
                // 겹받침: 첫 자음으로 모음+받침 약자 매칭 시도, 나머지는 별도 받침
                if let (first, second) = compoundJongsungMap[jongChar] {
                    let compoundKey = jungChar + first
                    if let contraction = vowelJongseongMap[compoundKey] {
                        appendChosung(choChar)
                        dots.append(contraction)
                        if let d = jongsungMap[second] {
                            dots.append(contentsOf: d.split(separator: ",").map { String($0) })
                        }
                        return dots
                    }
                }
            }

            // 5. ㅏ 생략 약자 (나/다/마/바/자/카/타/파/하 및 된소리)
            let aOmissionCho = ["ㄴ", "ㄷ", "ㄸ", "ㅁ", "ㅂ", "ㅃ", "ㅈ", "ㅉ", "ㅋ", "ㅌ", "ㅍ", "ㅎ"]
            var omitA = false

            if jungChar == "ㅏ" && aOmissionCho.contains(choChar) {
                omitA = true
                if char == "팠" { omitA = false }
                // 받침이 없을 때만: 다음 글자 초성이 ㅇ이면 ㅏ 생략 취소
                if jongIndex == 0, let next = nextChar, isHangul(next),
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
