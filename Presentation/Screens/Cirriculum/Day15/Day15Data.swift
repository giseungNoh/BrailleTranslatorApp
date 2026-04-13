import Foundation

// MARK: - 15일차 학습 데이터

// MARK: 설명뷰 1 — 7개 접속사 약어 소개

let day15AbbrIntroTitle = "무조건 1점으로 시작하는 7개의 약어"
let day15AbbrIntroSubtitle = "그래서 · 그러나 · 그러면 · 그러므로 · 그런데 · 그리고 · 그리하여"
let day15AbbrIntroDescription = "자주 쓰이는 접속사 7개(그래서, 그러나, 그러면, 그러므로, 그런데, 그리고, 그리하여)를 두 칸으로 줄여 쓰는 '약어'가 있습니다.\n\n이 7개 약어의 재미있는 공통점은 모두 첫 칸이 '1점'으로 시작한다는 것입니다.\n\n참고로 도화지에 그림을 '그리고'라고 쓸 때도 똑같은 '그리고' 약어를 사용합니다."

/// 설명뷰 1 아이템
let day15AbbrIntroItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "그래서", letter: "그래서", dotLabel: "1점 + 2·3·4점", cellsPerLine: 2),
    BrailleLetterItem(name: "그러나", letter: "그러나", dotLabel: "1점 + 1·4점", cellsPerLine: 2),
    BrailleLetterItem(name: "그러면", letter: "그러면", dotLabel: "1점 + 2·5점", cellsPerLine: 2),
    BrailleLetterItem(name: "그러므로", letter: "그러므로", dotLabel: "1점 + 2·6점", cellsPerLine: 2),
    BrailleLetterItem(name: "그런데", letter: "그런데", dotLabel: "1점 + 1·3·4·5점", cellsPerLine: 2),
    BrailleLetterItem(name: "그리고", letter: "그리고", dotLabel: "1점 + 1·3·6점", cellsPerLine: 2),
    BrailleLetterItem(name: "그리하여", letter: "그리하여", dotLabel: "1점 + 5·6점", cellsPerLine: 2),
]

// MARK: 실습뷰 1 — 7개 약어 촉각 훈련

let day15AbbrIntroPracticeItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "그래서, 1점으로 시작하는 약어 블록을 느껴보세요", letter: "그래서", dotLabel: "1점 + 2·3·4점", cellsPerLine: 2),
    BrailleLetterItem(name: "그러나, 1점 뒤에 이어지는 두 번째 칸을 느껴보세요", letter: "그러나", dotLabel: "1점 + 1·4점", cellsPerLine: 2),
    BrailleLetterItem(name: "그러면, 두 칸으로 압축된 약어를 느껴보세요", letter: "그러면", dotLabel: "1점 + 2·5점", cellsPerLine: 2),
    BrailleLetterItem(name: "그러므로, 두 칸으로 압축된 약어를 느껴보세요", letter: "그러므로", dotLabel: "1점 + 2·6점", cellsPerLine: 2),
    BrailleLetterItem(name: "그런데, 두 번째 칸이 묵직한 약어를 느껴보세요", letter: "그런데", dotLabel: "1점 + 1·3·4·5점", cellsPerLine: 2),
    BrailleLetterItem(name: "그리고, 1점으로 시작하는 약어 블록을 느껴보세요", letter: "그리고", dotLabel: "1점 + 1·3·6점", cellsPerLine: 2),
    BrailleLetterItem(name: "그리하여, 두 칸으로 압축된 약어를 느껴보세요", letter: "그리하여", dotLabel: "1점 + 5·6점", cellsPerLine: 2),
]

// MARK: 설명뷰 2 — 약어 뒤에 글자가 올 때

let day15AbbrTailTitle = "약어 꼬리에 글자 이어 붙이기"
let day15AbbrTailSubtitle = "그래서인지 · 그러면서 · 그런데도"
let day15AbbrTailDescription = "약어 바로 뒤에 빈칸 없이 다른 글자가 붙어 올 때는 약어의 모양을 그대로 사용할 수 있습니다.\n\n'그래서인지', '그러면서', '그런데도'처럼 문장이 자연스럽게 이어질 때는 걱정 없이 약어를 쓰고 이어서 적어주면 됩니다."

/// 설명뷰 2 아이템
let day15AbbrTailItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "그리고서, 그리고 약어 뒤에 서가 붙습니다", letter: "그리고서", dotLabel: "그리고(1점) + (1·3·6점) + ㅅ(6점) + ㅓ(2·3·4점)", cellsPerLine: 4),
    BrailleLetterItem(name: "그런데도, 그런데 약어 뒤에 도가 붙습니다", letter: "그런데도", dotLabel: "그런데(1점) + (1·3·4·5점) + ㄷ(2·4점) + ㅗ(1·3·6점)", cellsPerLine: 4),
]

// MARK: 실습뷰 2 — 약어 뒤 결합 훈련

let day15AbbrTailPracticeItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "그리고서, 약어 뒤에 글자가 이어지는 점형을 느껴보세요", letter: "그리고서", dotLabel: "그리고(1점) + (1·3·6점) + ㅅ(6점) + ㅓ(2·3·4점)", cellsPerLine: 4),
    BrailleLetterItem(name: "그런데도, 약어 뒤에 글자가 이어지는 점형을 느껴보세요", letter: "그런데도", dotLabel: "그런데(1점) + (1·3·4·5점) + ㄷ(2·4점) + ㅗ(1·3·6점)", cellsPerLine: 4),
]

// MARK: 설명뷰 3 — 약어 앞에 글자가 올 때 (함정!)

let day15AbbrTrapTitle = "약어 앞에 글자는 정자로"
let day15AbbrTrapSubtitle = "수그리고 · 찡그리고"
let day15AbbrTrapDescription = "약어 '앞'에 빈칸 없이 다른 글자가 붙을 때는 절대 약어를 쓸 수 없습니다.\n\n왜냐하면 약어의 시작인 '1점'이 홑받침 'ㄱ'과 모양이 완벽하게 똑같아서 잘못 읽힐 수 있기 때문입니다.\n\n따라서 '수그리고', '찡그리고'를 쓸 때는 '그리고' 약어를 쓰지 않고 모두 정자로 풀어 써야 합니다."

/// 설명뷰 3 아이템 — 약어 vs 정자 비교
let day15AbbrTrapItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "그리고 약어, 두 칸으로 짧게 압축", letter: "그리고", dotLabel: "그리고(1점) + (1·3·6점)", cellsPerLine: 2),
    BrailleLetterItem(name: "수그리고, 약어를 쓸 수 없어 정자로 풀어 씀", letter: "수그리고", dotLabel: "ㅅ(6점) + ㅜ(1·3·4점) + ㄱ(4점) + ㅡ(2·4·5점) + ㄹ(5점) + ㅣ(1·3·5점) + ㄱ(4점) + ㅗ(1·3·6점)", cellsPerLine: 8),
]

// MARK: 실습뷰 3 — 약어 앞 결합 예외 훈련

let day15AbbrTrapPracticeItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "그리고, 점자 두 칸으로 짧게 압축된 약어 점형을 느껴보세요", letter: "그리고", dotLabel: "그리고(1점) + (1·3·6점)", cellsPerLine: 2),
    BrailleLetterItem(name: "수그리고, 약어를 쓰지 못해 풀어쓴 정자 점형을 느껴보세요", letter: "수그리고", dotLabel: "ㅅ + ㅜ + ㄱ + ㅡ + ㄹ + ㅣ + ㄱ + ㅗ", cellsPerLine: 4),
]
