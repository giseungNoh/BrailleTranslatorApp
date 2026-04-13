import Foundation

// MARK: - 13일차 학습 데이터

// MARK: 설명뷰 1 — 'ㅓ' 계열 약자 (억, 언, 얼)

let day13EoSeriesTitle = "한 칸으로 쏙 줄어든 '억, 언, 얼'"
let day13EoSeriesSubtitle = "억 · 언 · 얼"
let day13EoSeriesDescription = "모음 'ㅓ'에 받침 'ㄱ, ㄴ, ㄹ'이 결합된 '억, 언, 얼'은 점자에서 자음과 모음을 따로 쓰지 않고 한 칸짜리 특별한 약자로 꽉 묶어서 표현합니다.\n\n글자의 길이가 훌쩍 줄어드는 편리함을 느껴보세요!"

/// 설명뷰 1 아이템 — 'ㅓ' 계열 약자
let day13EoSeriesItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "억", letter: "억", dotLabel: "1·4·5·6점", cellsPerLine: 1),
    BrailleLetterItem(name: "언", letter: "언", dotLabel: "2·3·4·5·6점", cellsPerLine: 1),
    BrailleLetterItem(name: "얼", letter: "얼", dotLabel: "2·3·4·5점", cellsPerLine: 1),
]

// MARK: 실습뷰 1 — '억, 언, 얼' 약자 훈련

let day13EoSeriesPracticeItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "억, 억 약자의 점형을 느껴보세요", letter: "억", dotLabel: "1·4·5·6점", cellsPerLine: 1),
    BrailleLetterItem(name: "언, 언 약자의 점형을 느껴보세요", letter: "언", dotLabel: "2·3·4·5·6점", cellsPerLine: 1),
    BrailleLetterItem(name: "얼, 얼 약자의 점형을 느껴보세요", letter: "얼", dotLabel: "2·3·4·5점", cellsPerLine: 1),
    BrailleLetterItem(name: "걱, 기억과 억 약자가 결합된 점형을 만져보세요", letter: "걱", dotLabel: "ㄱ(4점) + 억(1·4·5·6점)", cellsPerLine: 2, rawDots: "4,1456", rawDotLabels: "ㄱ,억"),
    BrailleLetterItem(name: "넌, 니은과 언 약자가 결합된 점형을 만져보세요", letter: "넌", dotLabel: "ㄴ(1·4점) + 언(2·3·4·5·6점)", cellsPerLine: 2, rawDots: "14,23456", rawDotLabels: "ㄴ,언"),
    BrailleLetterItem(name: "덜, 디귿과 얼 약자가 결합된 점형을 만져보세요", letter: "덜", dotLabel: "ㄷ(2·4점) + 얼(2·3·4·5점)", cellsPerLine: 2, rawDots: "24,2345", rawDotLabels: "ㄷ,얼"),
]

// MARK: 설명뷰 2 — 'ㅕ' 계열 약자 (연, 열, 영)

let day13YeoSeriesTitle = "한 칸으로 쏙 줄어든 '연, 열, 영'"
let day13YeoSeriesSubtitle = "연 · 열 · 영"
let day13YeoSeriesDescription = "이번엔 모음 'ㅕ'에 받침이 결합된 '연, 열, 영' 약자입니다.\n\n이 약자들 역시 한 칸으로 압축되어 있어, '연필', '열매', '영어' 같은 단어를 쓸 때 부피를 획기적으로 줄여줍니다."

/// 설명뷰 2 아이템 — 'ㅕ' 계열 약자
let day13YeoSeriesItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "연", letter: "연", dotLabel: "1·6점", cellsPerLine: 1),
    BrailleLetterItem(name: "열", letter: "열", dotLabel: "1·2·5·6점", cellsPerLine: 1),
    BrailleLetterItem(name: "영", letter: "영", dotLabel: "1·2·4·5·6점", cellsPerLine: 1),
]

// MARK: 실습뷰 2 — '연, 열, 영' 약자로 단어 만들기

let day13YeoSeriesPracticeItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "연, 연 약자의 점형을 느껴보세요", letter: "연", dotLabel: "ㅇ(1·2·4·6점) + 연(1·6점)", cellsPerLine: 1),
    BrailleLetterItem(name: "열, 열 약자의 점형을 느껴보세요", letter: "열", dotLabel: "ㅇ(1·2·4·6점) + 열(1·2·5·6점)", cellsPerLine: 1),
    BrailleLetterItem(name: "영, 영 약자의 점형을 느껴보세요", letter: "영", dotLabel: "영(1·2·4·5·6)", cellsPerLine: 1),
    BrailleLetterItem(name: "연필", letter: "자연", dotLabel: "ㅈ(4·6점) + ㅏ(1·2·6점) + 연(1·6점)", cellsPerLine: 3),
    BrailleLetterItem(name: "열매", letter: "열매", dotLabel: "열(1·2·5·6점) + ㅁ(1·5점) + ㅐ(1·2·3·5점)", cellsPerLine: 3),
    BrailleLetterItem(name: "영어", letter: "영어", dotLabel: "영(1·2·4·5·6점) + ㅓ(2·3·4점)", cellsPerLine: 2),
]

// MARK: 설명뷰 3 — '영' 약자의 마법 규칙 (엉으로 변신)

let day13YeongMagicTitle = "'영' 약자가 '엉'으로 변신하는 마법"
let day13YeongMagicSubtitle = "성 · 정 · 청"
let day13YeongMagicDescription = "아주 중요한 규칙입니다!\n\n'영(1·2·4·5·6점)' 약자 바로 앞에 'ㅅ, ㅈ, ㅊ, ㅆ, ㅉ'이 첫소리로 오면, 이 약자는 '영'이 아니라 '엉'으로 소리가 바뀝니다.\n\n따라서 '성, 정, 청, 썽, 쩡'을 쓸 때는 '엉' 약자를 따로 찾지 말고 무조건 '영' 약자를 붙여주면 됩니다."

/// 설명뷰 3 아이템 — '영/엉' 마법 규칙
let day13YeongMagicItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "정, 지읒 뒤에 영 약자가 붙어 정으로 읽힙니다", letter: "정", dotLabel: "ㅈ(4·6점) + 영(1·2·4·5·6점)", cellsPerLine: 2),
    BrailleLetterItem(name: "성, 시옷 뒤에 영 약자가 붙어 성으로 읽힙니다", letter: "성", dotLabel: "ㅅ(6점) + 영(1·2·4·5·6점)", cellsPerLine: 2),
]

// MARK: 실습뷰 3 — '정'과 '성' 촉각 구별 훈련

let day13YeongMagicPracticeItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "정, 지읒 뒤에 영 약자가 붙어 정으로 읽히는 점형을 느껴보세요", letter: "정", dotLabel: "ㅈ(4·6점) + 영(1·2·4·5·6점)", cellsPerLine: 2,  rawDots: "26,12456", rawDotLabels: "ㅈ,영"),
    BrailleLetterItem(name: "성, 시옷 뒤에 영 약자가 붙어 성으로 읽히는 점형을 느껴보세요", letter: "성", dotLabel: "ㅅ(6점) + 영(1·2·4·5·6점)", cellsPerLine: 2, rawDots: "6,12456", rawDotLabels: "ㅅ,영"),
]
