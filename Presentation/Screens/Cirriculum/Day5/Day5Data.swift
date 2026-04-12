import Foundation

// MARK: - 5일차 학습 데이터

/// 설명1: 한 칸 이중 모음 (다이어그램 표시용)
let day5SingleCellVowelItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "애", letter: "ㅐ", dotLabel: "1·2·3·5점", voiceOverName: "애, 애인할때의 애 입니다."),
    BrailleLetterItem(name: "에", letter: "ㅔ", dotLabel: "1·3·4·5점", voiceOverName: "에, 에너지할때 에 입니다."),
    BrailleLetterItem(name: "예", letter: "ㅖ", dotLabel: "3·4점", voiceOverName: "예, 예의할때 예 입니다."),
    BrailleLetterItem(name: "와", letter: "ㅘ", dotLabel: "1·2·3·6점"),
    BrailleLetterItem(name: "외", letter: "ㅚ", dotLabel: "1·3·4·5·6점", voiceOverName: "외, 외투할때 외 입니다."),
    BrailleLetterItem(name: "워", letter: "ㅝ", dotLabel: "1·2·3·4점"),
    BrailleLetterItem(name: "의", letter: "ㅢ", dotLabel: "2·4·5·6점"),
]

let day5ExplanationTitle = "한 칸 이중 모음"
let day5ExplanationSubtitle = "ㅐ · ㅔ · ㅖ · ㅘ · ㅚ · ㅝ · ㅢ"
let day5ExplanationDescription = "점자에서 'ㅐ, ㅔ, ㅖ, ㅘ, ㅚ, ㅝ, ㅢ'는\n한 칸으로 적습니다."

/// 실습1: 한 칸 이중 모음
let day5SingleCellPracticeItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "ㅐ", letter: "ㅐ", dotLabel: "1·2·3·5점", cellsPerLine: 1),
    BrailleLetterItem(name: "ㅔ", letter: "ㅔ", dotLabel: "1·3·4·5점", cellsPerLine: 1),
    BrailleLetterItem(name: "ㅖ", letter: "ㅖ", dotLabel: "3·4점", cellsPerLine: 1),
    BrailleLetterItem(name: "ㅘ", letter: "ㅘ", dotLabel: "1·2·3·6점", cellsPerLine: 1),
    BrailleLetterItem(name: "ㅚ", letter: "ㅚ", dotLabel: "1·3·4·5·6점", cellsPerLine: 1),
    BrailleLetterItem(name: "ㅝ", letter: "ㅝ", dotLabel: "1·2·3·4점", cellsPerLine: 1),
    BrailleLetterItem(name: "ㅢ", letter: "ㅢ", dotLabel: "2·4·5·6점", cellsPerLine: 1),
]

/// 설명2: 두 칸 이중 모음 (다이어그램 표시용)
let day5TwoCellVowelItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "얘", letter: "ㅒ", dotLabel: "ㅑ(3·4·5점) + 딴이(1·2·3·5점)", cellsPerLine: 2, voiceOverName: "얘, 얘기할때 얘 입니다."),
    BrailleLetterItem(name: "왜", letter: "ㅙ", dotLabel: "ㅘ(1·2·3·6점) + 딴이(1·2·3·5점)", cellsPerLine: 2, voiceOverName: "왜, 왜? 할때 왜 입니다."),
    BrailleLetterItem(name: "웨", letter: "ㅞ", dotLabel: "ㅝ(1·2·3·4점) + 딴이(1·2·3·5점)", cellsPerLine: 2, voiceOverName: "웨, 웨딩할때 웨 입니다."),
    BrailleLetterItem(name: "위", letter: "ㅟ", dotLabel: "ㅜ(1·3·4점) + 딴이(1·2·3·5점)", cellsPerLine: 2),
]

let day5TwoCellExplanationTitle = "두 칸 이중 모음"
let day5TwoCellExplanationSubtitle = "ㅒ · ㅙ · ㅞ · ㅟ"
let day5TwoCellExplanationDescription = "'ㅒ, ㅙ, ㅞ, ㅟ'처럼 복잡한 모음은\n두 칸이 필요합니다.\n\n기본 모음 뒤에 '딴이(1·2·3·5점)'를 붙여서 완성합니다."

/// 실습2: 두 칸 이중 모음 (딴이 결합)
let day5TwoCellPracticeItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "얘", letter: "얘", dotLabel: "ㅑ + 딴이", voiceOverName: "얘, 얘기할때 얘 입니다."),
    BrailleLetterItem(name: "왜", letter: "왜", dotLabel: "ㅘ + 딴이", voiceOverName: "왜, 왜? 할때 왜 입니다."),
    BrailleLetterItem(name: "웨", letter: "웨", dotLabel: "ㅝ + 딴이", voiceOverName: "웨, 웨딩할때 웨 입니다."),
    BrailleLetterItem(name: "위", letter: "위", dotLabel: "ㅜ + 딴이"),
]

/// 실습2: 왜 vs 와애 비교
let day5SeparatorCompareItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "왜", letter: "왜", dotLabel: "ㅘ + 딴이", cellsPerLine: 2, voiceOverName: "왜, 이중 모음 2칸"),
    BrailleLetterItem(name: "와애", letter: "와애", dotLabel: "ㅘ + 붙임표 + ㅐ", cellsPerLine: 3, voiceOverName: "와애, 붙임표 포함 3칸"),
]
