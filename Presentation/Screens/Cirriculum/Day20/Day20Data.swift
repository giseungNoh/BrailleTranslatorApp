import Foundation

// MARK: - 20일차 학습 데이터

// MARK: 설명뷰 1 — 생활 속 점자의 발견

let day20DailyTitle = "우리 주변에 숨어있는 점자들 (의약품과 가전제품)"
let day20DailySubtitle = "의약품 · 가전제품 · 생활용품"
let day20DailyDescription = "점자는 시각장애인의 독립적인 생활을 돕는 필수적인 문자입니다.\n\n의약품 상자에 적힌 점자를 읽고 '먹는 약'인지 '바르는 약'인지 쉽게 구별할 수 있으며, 세탁기 같은 가전제품에서도 '전원'이나 '동작' 버튼의 위치를 점자로 정확히 파악하여 사용할 수 있습니다."

/// 설명뷰 1은 아이템 없이 설명만 (실습에서 직접 해독)
let day20DailyItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "안약, 의약품 상자에 적힌 점자 예시", letter: "안약", dotLabel: "ㅇ + ㅏ + ㄴ + ㅇ + ㅑ + ㄱ", cellsPerLine: 4),
    BrailleLetterItem(name: "전원, 가전제품 버튼에 적힌 점자 예시", letter: "전원", dotLabel: "ㅈ + 언 + ㅇ + ㅝ + ㄴ", cellsPerLine: 4),
]

// MARK: 실습뷰 1 — 생활 속 점자 해독 훈련

let day20DailyPracticeItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "안약, 의약품 상자에 적힌 점자를 해독해 보세요", letter: "안약", dotLabel: "ㅇ + ㅏ + ㄴ + ㅇ + ㅑ + ㄱ", cellsPerLine: 4),
    BrailleLetterItem(name: "전원, 세탁기 버튼에 적힌 점자를 해독해 보세요", letter: "전원", dotLabel: "ㅈ + 언 + ㅇ + ㅝ + ㄴ", cellsPerLine: 4),
]

// MARK: 설명뷰 2 — 캔 음료의 미스터리

let day20CanTitle = "[실전 주의!] 이름표 없는 캔 음료의 미스터리"
let day20CanSubtitle = "탄산 · 음료"
let day20CanDescription = "실생활에서 점자를 읽을 때 가장 당황스러운 순간 중 하나는 캔 음료를 고를 때입니다.\n\n'콜라'나 '사이다'라는 정확한 이름 대신 점자로 단순히 '탄산' 또는 '음료'라고만 뭉뚱그려 적혀 있는 경우가 많아 소비자들이 원하는 음료를 고를 때 큰 혼란을 겪곤 합니다."

/// 설명뷰 2 아이템
let day20CanItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "탄산, 캔 음료에 뭉뚱그려 적힌 점자 예시", letter: "탄산", dotLabel: "ㅌ + ㅏ + ㄴ + ㅅ + ㅏ + ㄴ", cellsPerLine: 4),
    BrailleLetterItem(name: "음료, 캔 음료에 뭉뚱그려 적힌 점자 예시", letter: "음료", dotLabel: "ㅇ + ㅡ + ㅁ + ㄹ + ㅛ", cellsPerLine: 4),
]

// MARK: 실습뷰 2 — 캔 음료 점자 구별 훈련

let day20CanPracticeItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "탄산, 캔 뚜껑에 찍힌 점자를 해독해 보세요", letter: "탄산", dotLabel: "ㅌ + ㅏ + ㄴ + ㅅ + ㅏ + ㄴ", cellsPerLine: 4),
    BrailleLetterItem(name: "음료, 캔 뚜껑에 찍힌 점자를 해독해 보세요", letter: "음료", dotLabel: "ㅇ + ㅡ + ㅁ + ㄹ + ㅛ", cellsPerLine: 4),
]

// MARK: 설명뷰 3 — 물음표와 받침 ㅌ의 함정

let day20TrapTitle = "[실전 주의!] 똑같이 생긴 '물음표(?)'와 '받침 ㅌ'"
let day20TrapSubtitle = "물음표(2·3·6점) = 받침 ㅌ(2·3·6점)"
let day20TrapDescription = "점자 문장을 읽을 때 사람들이 정말 자주 하는 실수가 있습니다.\n\n바로 문장을 끝맺는 문장 부호 '물음표(?)'와 한글 받침 '티읕(ㅌ)'의 점자 모양이 2·3·6점으로 완벽하게 똑같다는 점입니다.\n\n문맥을 파악하지 않고 손끝의 점형에만 의존하면 글자의 받침인지 문장의 끝인지 오독하기 쉬우므로 혼동하지 않도록 몹시 유의해서 읽어야 합니다."

/// 설명뷰 3 아이템
let day20TrapItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "물음표, 2·3·6점으로 이루어진 문장 부호", letter: "물음표 ?", dotLabel: "물음표(2·3·6점)", cellsPerLine: 1, rawDots: "236", rawDotLabels: "물음표"),
    BrailleLetterItem(name: "받침 ㅌ, 물음표와 완벽하게 똑같은 2·3·6점", letter: "받침 ㅌ", dotLabel: "받침 ㅌ(2·3·6점)", cellsPerLine: 1, rawDots: "236", rawDotLabels: "받침 ㅌ"),
]

// MARK: 실습뷰 3 — 미세한 차이 구별 및 최종 수료 훈련

let day20TrapPracticeItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "끝, 받침 ㅌ이 사용된 글자를 만져보세요. 초성과 모음 뒤에 바짝 붙은 받침의 공간감을 느껴보세요", letter: "끝", dotLabel: "ㄲ + ㅡ + 받침ㅌ(2·3·6점)", cellsPerLine: 4),
    BrailleLetterItem(name: "누구?, 물음표가 사용된 문장을 만져보세요. 온전한 글자 뒤에 이어 나오는 물음표의 공간감을 느껴보세요", letter: "누구?", dotLabel: "ㄴ + ㅜ + ㄱ + ㅜ + 물음표(2·3·6점)", cellsPerLine: 5),
]
