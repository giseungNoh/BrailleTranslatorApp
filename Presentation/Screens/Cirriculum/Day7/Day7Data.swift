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

// MARK: 실습뷰 2 — 쌍기역 vs 쌍시옷 비교 (번역기 + skipLeadingCells)

/// 쌍기역(2칸: 1점+1점), 쌍시옷(2칸: 3점+3점) — 약자 미적용
let day7DoublePracticeItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "쌍기역, 점자 두 칸 받침 기역 두 번", letter: "ㄲ", dotLabel: "ㄱ(1점) + ㄱ(1점), 2칸", cellsPerLine: 2),
    BrailleLetterItem(name: "쌍시옷, 점자 두 칸 받침 시옷 두 번", letter: "ㅆ", dotLabel: "ㅅ(3점) + ㅅ(3점), 2칸", cellsPerLine: 2),
]
