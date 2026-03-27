import Foundation

// MARK: - 3일차 학습 데이터

struct Day3LearningGroup {
    let title: String
    let subtitle: String
    let description: String
    let items: [BrailleLetterItem]
}

let day3ConsonantGroup = Day3LearningGroup(
    title: "1-2-4-5점 중심 글자",
    subtitle: "ㅋ · ㅌ · ㅍ · ㅎ",
    description: "1, 2, 4, 5점의 자리를 기준으로\n점이 이동하며 만들어지는 글자들입니다.\n\nㅋ은 1·2·4점, ㅌ은 1·2·5점,\nㅍ은 1·4·5점, ㅎ은 2·4·5점으로\n구성되어 있습니다.",
    items: [
        BrailleLetterItem(name: "키읔", letter: "ㅋ", dotLabel: "1·2·4점"),
        BrailleLetterItem(name: "티읕", letter: "ㅌ", dotLabel: "1·2·5점"),
        BrailleLetterItem(name: "피읖", letter: "ㅍ", dotLabel: "1·4·5점"),
        BrailleLetterItem(name: "히읗", letter: "ㅎ", dotLabel: "2·4·5점"),
    ]
)

let day3DoubleConsonantItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "쌍기역", letter: "ㄲ", dotLabel: "된소리표(6점) + 기역(4점)"),
    BrailleLetterItem(name: "쌍디귿", letter: "ㄸ", dotLabel: "된소리표(6점) + 디귿(3·5점)"),
    BrailleLetterItem(name: "쌍비읍", letter: "ㅃ", dotLabel: "된소리표(6점) + 비읍(4·5점)"),
    BrailleLetterItem(name: "쌍시옷", letter: "ㅆ", dotLabel: "된소리표(6점) + 시옷(6점)"),
    BrailleLetterItem(name: "쌍지읒", letter: "ㅉ", dotLabel: "된소리표(6점) + 지읒(4·6점)"),
]
