import Foundation

// MARK: - 8일차 학습 데이터

// MARK: 설명뷰 1 — 수표 (3-4-5-6점)

let day8NumberSignTitle = "숫자의 시작을 알리는 마법 기호"
let day8NumberSignSubtitle = "수표 (⠼)"
let day8NumberSignDescription = "점자는 6개의 점만 사용하다 보니 글자와 숫자의 모양이 똑같아서 구별이 필요합니다.\n\n그래서 숫자를 적을 때는 반드시 글자 앞에 \"지금부터 숫자입니다!\"라고 알려주는 기호,'수표(3-4-5-6점)'를 먼저 찍어주어야 합니다."

/// 설명뷰 1 아이템 — 수표
let day8NumberSignItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "수표, 3-4-5-6점", letter: "수표", dotLabel: "3·4·5·6점", rawDots: "3456"),
]

// MARK: 실습뷰 1 — 수표 만져보기

let day8NumberSignPracticeItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "수표, 3-4-5-6점. 오른쪽과 아래쪽으로 묵직하게 채워진 점의 위치를 느껴보세요", letter: "수표", dotLabel: "3·4·5·6점", rawDots: "3456"),
]

// MARK: 설명뷰 2 — 숫자 1~4 (0 포함)

let day8NumberTitle2 = "숫자 1부터 4까지의 점형"
let day8NumberSubtitle2 = "0 · 1 · 2 · 3 · 4 "
let day8NumberDescription2 = "숫자의 점형은 아주 재미있는 규칙을 가지고 있습니다.\n\n숫자 1부터 8까지는 모두 1점이 포함되어 있고, 9와 0은 2점이 포함되어 만들어집니다.\n\n특히 4는 'ㄱ' 모양과 비슷해서 외우기 쉽답니다!"

/// 설명뷰 2 아이템 — 숫자 1~4, 0
let day8NumberItems2: [BrailleLetterItem] = [
    BrailleLetterItem(name: "숫자 0, 2-4-5점", letter: "0", dotLabel: "2·4·5점"),
    BrailleLetterItem(name: "숫자 1, 1점", letter: "1", dotLabel: "1점"),
    BrailleLetterItem(name: "숫자 2, 1-2점", letter: "2", dotLabel: "1·2점"),
    BrailleLetterItem(name: "숫자 3, 1-4점", letter: "3", dotLabel: "1·4점"),
    BrailleLetterItem(name: "숫자 4, 기역 모양, 1-4-5점", letter: "4", dotLabel: "1·4·5점"),
]

// MARK: 실습뷰 2 — 숫자 1~4, 0 만져보기

let day8NumberPracticeItems2: [BrailleLetterItem] = [
    BrailleLetterItem(name: "숫자 0, 수표 뒤에 2-4-5점", letter: "0", dotLabel: "2·4·5점"),
    BrailleLetterItem(name: "숫자 1, 수표 뒤에 1점", letter: "1", dotLabel: "1점"),
    BrailleLetterItem(name: "숫자 2, 수표 뒤에 1-2점", letter: "2", dotLabel: "1·2점"),
    BrailleLetterItem(name: "숫자 3, 수표 뒤에 1-4점", letter: "3", dotLabel: "1·4점"),
    BrailleLetterItem(name: "숫자 4, 기역 모양, 수표 뒤에 1-4-5점", letter: "4", dotLabel: "1·4·5점"),
]

// MARK: 설명뷰 3 — 숫자 5~9

let day8NumberTitle3 = "숫자 5부터 9까지의 점형"
let day8NumberSubtitle3 = "5 · 6 · 7 · 8 · 9"
let day8NumberDescription3 = "5부터 9까지도 규칙이 있습니다.\n\n5~8은 모두 1점이 포함되어 있고,특히 8은 'ㄴ' 모양과 비슷합니다.\n\n9만 특별히 2-4점으로 1점 없이 만들어집니다."

/// 설명뷰 3 아이템 — 숫자 5~9
let day8NumberItems3: [BrailleLetterItem] = [
    BrailleLetterItem(name: "숫자 5, 1-5점", letter: "5", dotLabel: "1·5점"),
    BrailleLetterItem(name: "숫자 6, 1-2-4점", letter: "6", dotLabel: "1·2·4점"),
    BrailleLetterItem(name: "숫자 7, 1-2-4-5점", letter: "7", dotLabel: "1·2·4·5점"),
    BrailleLetterItem(name: "숫자 8, 니은 모양, 1-2-5점", letter: "8", dotLabel: "1·2·5점"),
    BrailleLetterItem(name: "숫자 9, 2-4점", letter: "9", dotLabel: "2·4점"),
]

// MARK: 실습뷰 3 — 숫자 5~9 만져보기

let day8NumberPracticeItems3: [BrailleLetterItem] = [
    BrailleLetterItem(name: "숫자 5, 수표 뒤에 1-5점", letter: "5", dotLabel: "1·5점"),
    BrailleLetterItem(name: "숫자 6, 수표 뒤에 1-2-4점", letter: "6", dotLabel: "1·2·4점"),
    BrailleLetterItem(name: "숫자 7, 수표 뒤에 1-2-4-5점", letter: "7", dotLabel: "1·2·4·5점"),
    BrailleLetterItem(name: "숫자 8, 니은 모양, 수표 뒤에 1-2-5점", letter: "8", dotLabel: "1·2·5점"),
    BrailleLetterItem(name: "숫자 9, 수표 뒤에 2-4점", letter: "9", dotLabel: "2·4점"),
]
