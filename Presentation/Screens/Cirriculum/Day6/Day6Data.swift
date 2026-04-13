import Foundation

// MARK: - 6일차 학습 데이터

// MARK: 설명뷰 1 — 밀기 받침 (오른쪽→왼쪽)

let day6PushTitle = "옆으로 밀어서 만드는 받침"
let day6PushSubtitle = "ㄱ · ㄹ · ㅂ · ㅅ · ㅈ · ㅊ"
let day6PushDescription = "점자에서 홑받침글자를 만드는 첫 번째 핵심 원리는 옆으로 밀 수 있으면 밀어라 입니다.\n\n점자 칸의 오른쪽(4, 5, 6점)에 치우쳐 있어 왼쪽으로 빈 공간이 있는 'ㄱ, ㄹ, ㅂ, ㅅ, ㅈ, ㅊ'의 첫소리 점형은, 모양을 그대로 유지한 채 왼쪽으로 밀어서 홑받침글자를 만듭니다."

/// 설명뷰 1 아이템 — 첫소리 → 받침 변환을 다이어그램으로 표시
let day6PushItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "기역 받침", letter: "ㄱ", dotLabel: "1점", fromDotLabel: "4점"),
    BrailleLetterItem(name: "리을 받침", letter: "ㄹ", dotLabel: "2점", fromDotLabel: "5점"),
    BrailleLetterItem(name: "비읍 받침", letter: "ㅂ", dotLabel: "1·2점", fromDotLabel: "4·5점"),
    BrailleLetterItem(name: "시옷 받침", letter: "ㅅ", dotLabel: "3점", fromDotLabel: "6점"),
    BrailleLetterItem(name: "지읒 받침", letter: "ㅈ", dotLabel: "1·3점", fromDotLabel: "4·6점"),
    BrailleLetterItem(name: "치읓 받침", letter: "ㅊ", dotLabel: "2·3점", fromDotLabel: "5·6점"),
]

/// 실습뷰 1 — 밀기 받침 점형만 직접 터치
let day6PushPracticeItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "기역 받침", letter: "ㄱ", dotLabel: "1점", cellsPerLine: 1, rawDots: "1"),
    BrailleLetterItem(name: "리을 받침", letter: "ㄹ", dotLabel: "2점", cellsPerLine: 1, rawDots: "2"),
    BrailleLetterItem(name: "비읍 받침", letter: "ㅂ", dotLabel: "1·2점", cellsPerLine: 1, rawDots: "12"),
    BrailleLetterItem(name: "시옷 받침", letter: "ㅅ", dotLabel: "3점", cellsPerLine: 1, rawDots: "3"),
    BrailleLetterItem(name: "지읒 받침", letter: "ㅈ", dotLabel: "1·3점", cellsPerLine: 1, rawDots: "13"),
    BrailleLetterItem(name: "치읓 받침", letter: "ㅊ", dotLabel: "2·3점", cellsPerLine: 1, rawDots: "23"),
]

// MARK: 설명뷰 2 — 내리기 받침 (위→아래)

let day6DropTitle = "밀 수 없어서 아래로 내리는 받침"
let day6DropSubtitle = "ㄴ · ㄷ · ㅁ · ㅋ · ㅌ · ㅍ · ㅎ"
let day6DropDescription = "두 번째 핵심 원리는\n\"밀 수 없다면 아래로 내려라\"입니다.\n\n'ㄴ, ㄷ, ㅁ, ㅋ, ㅌ, ㅍ, ㅎ'은 이미 1점(왼쪽) 자리를 차지하고 있거나 위쪽에 매달려 있어 옆으로 밀 수 없습니다.\n\n이렇게 옆으로 밀 수 없는 글자들은 점형을 아래로 한 칸 내려서 홑받침글자를 만듭니다."

/// 설명뷰 2 아이템 — 첫소리 → 받침 변환을 다이어그램으로 표시
let day6DropItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "니은 받침", letter: "ㄴ", dotLabel: "2·5점", fromDotLabel: "1·4점"),
    BrailleLetterItem(name: "디귿 받침", letter: "ㄷ", dotLabel: "3·5점", fromDotLabel: "2·4점"),
    BrailleLetterItem(name: "미음 받침", letter: "ㅁ", dotLabel: "2·6점", fromDotLabel: "1·5점"),
    BrailleLetterItem(name: "키읔 받침", letter: "ㅋ", dotLabel: "2·3·5점", fromDotLabel: "1·2·4점"),
    BrailleLetterItem(name: "티읕 받침", letter: "ㅌ", dotLabel: "2·3·6점", fromDotLabel: "1·2·5점"),
    BrailleLetterItem(name: "피읖 받침", letter: "ㅍ", dotLabel: "2·5·6점", fromDotLabel: "1·4·5점"),
    BrailleLetterItem(name: "히읗 받침", letter: "ㅎ", dotLabel: "3·5·6점", fromDotLabel: "2·4·5점"),
]

/// 실습뷰 2 — 내리기 받침 점형만 직접 터치
let day6DropPracticeItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "니은 받침", letter: "ㄴ", dotLabel: "2·5점", cellsPerLine: 1, rawDots: "25"),
    BrailleLetterItem(name: "디귿 받침", letter: "ㄷ", dotLabel: "3·5점", cellsPerLine: 1, rawDots: "35"),
    BrailleLetterItem(name: "미음 받침", letter: "ㅁ", dotLabel: "2·6점", cellsPerLine: 1, rawDots: "26"),
    BrailleLetterItem(name: "키읔 받침", letter: "ㅋ", dotLabel: "2·3·5점", cellsPerLine: 1, rawDots: "235"),
    BrailleLetterItem(name: "티읕 받침", letter: "ㅌ", dotLabel: "2·3·6점", cellsPerLine: 1, rawDots: "236"),
    BrailleLetterItem(name: "피읖 받침", letter: "ㅍ", dotLabel: "2·5·6점", cellsPerLine: 1, rawDots: "256"),
    BrailleLetterItem(name: "히읗 받침", letter: "ㅎ", dotLabel: "3·5·6점", cellsPerLine: 1, rawDots: "356"),
]

// MARK: 설명뷰 3 — 받침 ㅇ

let day6IeungTitle = "드디어 소리가 나는 받침, 'ㅇ'"
let day6IeungSubtitle = "받침 ㅇ"
let day6IeungDescription = "앞서 첫소리에 오는 '이응(ㅇ)'은\n소리가 나지 않아\n점자로 아예 쓰지 않았습니다.\n\n하지만 받침으로 쓰이는 '이응(ㅇ)'은\n분명한 소리가 나기 때문에\n첫소리에서는 쓰지 않았던 점형\n'2·3·5·6점'을 사용하여\n꽉 찍어주어야 합니다."

/// 설명뷰 3 아이템 — 받침 ㅇ 점형
let day6IeungExplainItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "이응 받침", letter: "ㅇ", dotLabel: "2·3·5·6점"),
]

// MARK: 실습뷰 3 — 이응 비교

/// '아'(첫소리 ㅇ 생략)와 '앙'(받침 ㅇ 있음)을 비교 터치
let day6IeungPracticeItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "이응 받침", letter: "ㅇ", dotLabel: "2·3·5·6점", cellsPerLine: 1, rawDots: "2356", rawDotLabels: "이응 받침", voiceOverName: "이응 받침, 2·3·5·6점"),
    BrailleLetterItem(name: "아", letter: "아", dotLabel: "ㅏ(1·2·6점)", cellsPerLine: 1, voiceOverName: "아, 첫소리 이응은 생략"),
    BrailleLetterItem(name: "앙", letter: "앙", dotLabel: "ㅏ(1·2·6점) + ㅇ받침(2·3·5·6점)", cellsPerLine: 2, voiceOverName: "앙, 받침 이응 2·3·5·6점"),
]
