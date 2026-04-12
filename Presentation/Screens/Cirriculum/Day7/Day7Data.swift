import Foundation

// MARK: - 7일차 학습 데이터

// MARK: 설명뷰 1 — 나란히 이어 붙이는 겹받침 (앞 5개)

let day7CompoundTitle1 = "나란히 이어 붙이는 겹받침"
let day7CompoundSubtitle1 = "ㄳ · ㄵ · ㄶ · ㄺ · ㄻ"
let day7CompoundDescription1 = "점자에서 겹받침을 만드는 방법은\n아주 쉽고 직관적입니다.\n어제 배운 홑받침 두 개를\n순서대로 나란히 이어 적기만 하면 됩니다.\n\n예를 들어 'ㄳ'은 홑받침 'ㄱ(1점)'과\n홑받침 'ㅅ(3점)'을 나란히 붙여서 적습니다."

/// 설명뷰 1 아이템 — 겹받침 앞 5개
let day7CompoundItems1: [BrailleLetterItem] = [
    BrailleLetterItem(name: "기역시옷", letter: "ㄳ", dotLabel: "ㄱ(1점) + ㅅ(3점)", cellsPerLine: 2),
    BrailleLetterItem(name: "니은지읒", letter: "ㄵ", dotLabel: "ㄴ(2·5점) + ㅈ(1·3점)", cellsPerLine: 2),
    BrailleLetterItem(name: "니은히읗", letter: "ㄶ", dotLabel: "ㄴ(2·5점) + ㅎ(3·5·6점)", cellsPerLine: 2),
    BrailleLetterItem(name: "리을기역", letter: "ㄺ", dotLabel: "ㄹ(2점) + ㄱ(1점)", cellsPerLine: 2),
    BrailleLetterItem(name: "리을미음", letter: "ㄻ", dotLabel: "ㄹ(2점) + ㅁ(2·6점)", cellsPerLine: 2),
]

// MARK: 설명뷰 2 — 나란히 이어 붙이는 겹받침 (뒤 6개)

let day7CompoundTitle2 = "나란히 이어 붙이는 겹받침"
let day7CompoundSubtitle2 = "ㄼ · ㄽ · ㄾ · ㄿ · ㅀ · ㅄ"
let day7CompoundDescription2 = "나머지 겹받침도 같은 원리입니다.\n홑받침 두 개를 순서대로\n나란히 이어 적으면 됩니다."

/// 설명뷰 2 아이템 — 겹받침 뒤 6개
let day7CompoundItems2: [BrailleLetterItem] = [
    BrailleLetterItem(name: "리을비읍", letter: "ㄼ", dotLabel: "ㄹ(2점) + ㅂ(1·2점)", cellsPerLine: 2),
    BrailleLetterItem(name: "리을시옷", letter: "ㄽ", dotLabel: "ㄹ(2점) + ㅅ(3점)", cellsPerLine: 2),
    BrailleLetterItem(name: "리을티읕", letter: "ㄾ", dotLabel: "ㄹ(2점) + ㅌ(2·3·6점)", cellsPerLine: 2),
    BrailleLetterItem(name: "리을피읖", letter: "ㄿ", dotLabel: "ㄹ(2점) + ㅍ(2·5·6점)", cellsPerLine: 2),
    BrailleLetterItem(name: "리을히읗", letter: "ㅀ", dotLabel: "ㄹ(2점) + ㅎ(3·5·6점)", cellsPerLine: 2),
    BrailleLetterItem(name: "비읍시옷", letter: "ㅄ", dotLabel: "ㅂ(1·2점) + ㅅ(3점)", cellsPerLine: 2),
]

/// 실습뷰 1 — 겹받침 조합 훈련 (번역기 + skipLeadingCells로 온표 제거)
let day7CompoundPracticeItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "기역시옷, 받침 기역과 받침 시옷 나란히", letter: "ㄳ", dotLabel: "ㄱ(1점) + ㅅ(3점)", cellsPerLine: 2),
    BrailleLetterItem(name: "니은지읒, 받침 니은과 받침 지읒 나란히", letter: "ㄵ", dotLabel: "ㄴ(2·5점) + ㅈ(1·3점)", cellsPerLine: 2),
    BrailleLetterItem(name: "니은히읗, 받침 니은과 받침 히읗 나란히", letter: "ㄶ", dotLabel: "ㄴ(2·5점) + ㅎ(3·5·6점)", cellsPerLine: 2),
    BrailleLetterItem(name: "리을기역, 받침 리을과 받침 기역 나란히", letter: "ㄺ", dotLabel: "ㄹ(2점) + ㄱ(1점)", cellsPerLine: 2),
    BrailleLetterItem(name: "리을미음, 받침 리을과 받침 미음 나란히", letter: "ㄻ", dotLabel: "ㄹ(2점) + ㅁ(2·6점)", cellsPerLine: 2),
]

// MARK: 설명뷰 3 — 쌍받침 규칙 + ㅆ 받침과 예의 충돌

let day7DoubleJongseongTitle = "쌍받침의 규칙"
let day7DoubleJongseongSubtitle = "ㄲ · ㅆ"
let day7DoubleJongseongDescription = "받침 쌍기역(ㄲ)은 받침 'ㄱ(1점)'을 두 번\n나란히 적어 두 칸으로 표기합니다.\n\n다만 쌍시옷(ㅆ) 받침은 예외로\n'3·4점' 한 칸으로 적습니다.\n\n그런데 이 점형은 이중 모음 'ㅖ(3·4점)'와똑같아 충돌이 생깁니다.'서예'처럼 모음 뒤에 '예'가 올 때는'섰'으로 잘못 읽히지 않도록 모음과 '예' 사이에 반드시 '구분표(3·6점)'를 적어야 합니다."

/// 설명뷰 3 아이템 — 쌍받침 점형
let day7DoubleJongseongItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "쌍기역 받침", letter: "ㄲ", dotLabel: "ㄱ(1점) + ㄱ(1점)", cellsPerLine: 2),
    BrailleLetterItem(name: "쌍시옷 받침", letter: "ㅆ", dotLabel: "3·4점"),
    BrailleLetterItem(name: "섰", letter: "섰", dotLabel: "ㅅ(6점) + ㅓ(2·3·4점) + ㅆ(3·4점)"),
    BrailleLetterItem(name: "서예", letter: "서예", dotLabel: "ㅅ(6점) + ㅓ(2·3·4점) + 붙임표(3·6점) + ㅆ(3·4점)")
]

// MARK: 실습뷰 2 — 쌍기역 vs 쌍시옷 비교

/// 쌍기역(2칸: 1점+1점), 쌍시옷(1칸: 3·4점) — 약자 미적용
let day7DoublePracticeItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "쌍기역 받침", letter: "ㄲ", dotLabel: "ㄱ(1점) + ㄱ(1점)", cellsPerLine: 2, rawDots: "1,1", rawDotLabels: "ㄲ"),
    BrailleLetterItem(name: "쌍시옷 받침", letter: "ㅆ", dotLabel: "3·4점", cellsPerLine: 1, rawDots: "34", rawDotLabels: "쌍시옷 받침"),
    BrailleLetterItem(name: "섰", letter: "섰", dotLabel: "ㅅ(6점) + ㅓ(2·3·4점) + ㅆ(3·4점)",cellsPerLine: 3),
    BrailleLetterItem(name: "서예", letter: "서예", dotLabel: "ㅅ(6점) + ㅓ(2·3·4점) + 붙임표(3·6점) + ㅆ(3·4점)",cellsPerLine: 4)
]
