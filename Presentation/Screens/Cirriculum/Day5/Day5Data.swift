import Foundation

// MARK: - 5일차 학습 데이터

/// 설명1: 한 칸 이중 모음 (다이어그램 표시용)
let day5SingleCellVowelItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "애", letter: "ㅐ", dotLabel: "1·2·3·5점"),
    BrailleLetterItem(name: "에", letter: "ㅔ", dotLabel: "1·3·4·5점"),
    BrailleLetterItem(name: "예", letter: "ㅖ", dotLabel: "3·4점"),
    BrailleLetterItem(name: "와", letter: "ㅘ", dotLabel: "1·2·3·6점"),
    BrailleLetterItem(name: "외", letter: "ㅚ", dotLabel: "1·3·4·5·6점"),
    BrailleLetterItem(name: "워", letter: "ㅝ", dotLabel: "1·2·3·4점"),
    BrailleLetterItem(name: "의", letter: "ㅢ", dotLabel: "2·4·5·6점"),
]

let day5ExplanationTitle = "한 칸 이중 모음과 두 칸 이중 모음"
let day5ExplanationSubtitle = "ㅐ · ㅔ · ㅖ · ㅘ · ㅚ · ㅝ · ㅢ"
let day5ExplanationDescription = "점자에서 'ㅐ, ㅔ, ㅖ, ㅘ, ㅚ, ㅝ, ㅢ'는\n한 칸으로 적습니다.\n\n하지만 'ㅒ, ㅙ, ㅞ, ㅟ'처럼 복잡한 모음은\n두 칸이 필요합니다.\n기본 모음 뒤에 '딴이(1·2·3·5점)'를 붙여서 완성합니다."

/// 실습1: 두 칸 이중 모음 (딴이 결합)
let day5DoubleCellVowelItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "ㅐ", letter: "ㅐ", dotLabel: "ㅐ",cellsPerLine: 1),
    BrailleLetterItem(name: "ㅔ", letter: "ㅔ", dotLabel: "ㅔ",cellsPerLine: 1),
    BrailleLetterItem(name: "ㅖ", letter: "ㅖ", dotLabel: "ㅖ",cellsPerLine: 1),
    BrailleLetterItem(name: "ㅘ", letter: "ㅘ", dotLabel: "ㅘ",cellsPerLine: 1),
    BrailleLetterItem(name: "외", letter: "외", dotLabel: "ㅚ",cellsPerLine: 1),
    BrailleLetterItem(name: "ㅝ", letter: "ㅝ", dotLabel: "ㅝ ",cellsPerLine: 1),
    BrailleLetterItem(name: "ㅢ", letter: "ㅢ", dotLabel: "ㅢ",cellsPerLine: 1),
    BrailleLetterItem(name: "얘", letter: "얘", dotLabel: "ㅑ + 딴이"),
    BrailleLetterItem(name: "왜", letter: "왜", dotLabel: "ㅘ + 딴이"),
    BrailleLetterItem(name: "웨", letter: "웨", dotLabel: "ㅝ + 딴이"),
    BrailleLetterItem(name: "위", letter: "위", dotLabel: "ㅜ + 딴이"),
]

/// 실습2: 왜 vs 와애 비교
let day5SeparatorCompareItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "왜, 이중 모음 2칸", letter: "왜", dotLabel: "ㅘ + 딴이",cellsPerLine: 2),
    BrailleLetterItem(name: "와애, 붙임표 포함 3칸", letter: "와애", dotLabel: "ㅘ + 붙임표 + ㅐ",cellsPerLine: 3),
]

/// 실습3: 돘 vs 도예 비교
let day5YeCompareItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "섰, 쌍시옷 받침 3칸", letter: "섰", dotLabel: "ㅅ + ㅓ + ㅆ받침",cellsPerLine: 3),
    BrailleLetterItem(name: "서예, 붙임표 포함 4칸", letter: "서예", dotLabel: "ㅅ + ㅓ + 붙임표 + ㅖ",cellsPerLine: 4),
]
