import Foundation

// MARK: - 20일차 학습 데이터

// MARK: 설명뷰 1 — 엘리베이터 네 가지 버튼 (상·하·폐·개)

let day20ArrowTitle = "엘리베이터의 네 가지 버튼"
let day20ArrowSubtitle = "상(↑) · 하(↓) · 폐(닫힘) · 개(열림)"
let day20ArrowDescription = "엘리베이터 버튼에는 숫자뿐만 아니라 방향과 동작을 알려주는 한자도 점자로 적혀 있습니다.\n\n위로 가기 버튼에는 '상(上)'이 1·2·3점, 2·3·4·6점 두 칸으로, 아래로 가기 버튼에는 '하(下)'가 2·4·5점 한 칸으로 표기됩니다.\n\n닫힘 버튼에는 '폐(閉)'가 1·4·5점, 3·4점 두 칸으로, 열림 버튼에는 '개(開)'가 4점, 1·2·3·5점 두 칸으로 적혀 있습니다."

let day20ArrowItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "위로 가기 버튼, 한자 상을 뜻하는 두 칸짜리 점자", letter: "↑ 상", dotLabel: "상(1·2·3점) + (2·3·4·6점)", cellsPerLine: 2),
    BrailleLetterItem(name: "아래로 가기 버튼, 한자 하를 뜻하는 한 칸짜리 점자", letter: "↓ 하", dotLabel: "하(2·4·5점)", cellsPerLine: 1),
    BrailleLetterItem(name: "닫힘 버튼, 한자 폐를 뜻하는 두 칸짜리 점자", letter: "닫힘 폐", dotLabel: "폐(1·4·5점) + (3·4점)", cellsPerLine: 2),
    BrailleLetterItem(name: "열림 버튼, 한자 개를 뜻하는 두 칸짜리 점자", letter: "열림 개", dotLabel: "개(4점) + (1·2·3·5점)", cellsPerLine: 2),
]

// MARK: 실습뷰 1 — 엘리베이터 네 가지 버튼 촉각 훈련

let day20ArrowPracticeItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "위로 가기 버튼, 상(上)을 뜻하는 1·2·3점과 2·3·4·6점 두 칸 점자를 만져보세요", letter: "↑ 상", dotLabel: "1·2·3점 + 2·3·4·6점", cellsPerLine: 2, rawDots: "123,2346", rawDotLabels: "상"),
    BrailleLetterItem(name: "아래로 가기 버튼, 하(下)를 뜻하는 2·4·5점 한 칸 점자를 만져보세요", letter: "↓ 하", dotLabel: "2·4·5점", cellsPerLine: 1, rawDots: "245", rawDotLabels: "하"),
    BrailleLetterItem(name: "닫힘 버튼, 폐(閉)를 뜻하는 1·4·5점과 3·4점 두 칸 점자를 만져보세요", letter: "닫힘 폐", dotLabel: "1·4·5점 + 3·4점", cellsPerLine: 2, rawDots: "145,34", rawDotLabels: "폐"),
    BrailleLetterItem(name: "열림 버튼, 개(開)를 뜻하는 4점과 1·2·3·5점 두 칸 점자를 만져보세요", letter: "열림 개", dotLabel: "4점 + 1·2·3·5점", cellsPerLine: 2, rawDots: "4,1235", rawDotLabels: "개"),
]

// MARK: 설명뷰 2 — 캔 음료의 미스터리

let day20CanTitle = "이름표 없는 캔 음료의 미스터리"
let day20CanSubtitle = "탄산 · 음료"
let day20CanDescription = "실생활에서 점자를 읽을 때 가장 당황스러운 순간 중 하나는 캔 음료를 고를 때입니다.\n\n'콜라'나 '사이다'라는 정확한 이름 대신 점자로 단순히 '탄산' 또는 '음료'라고만 뭉뚱그려 적혀 있는 경우가 많아 소비자들이 원하는 음료를 고를 때 큰 혼란을 겪곤 합니다."

/// 설명뷰 2 아이템
let day20CanItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "탄산, 캔 음료에 뭉뚱그려 적힌 점자 예시. 타 약자와 사 약자가 모두 사용됩니다", letter: "탄산", dotLabel: "타(1·2·5점) + 받침 ㄴ(2·5점) + 사(1·2·3점) + 받침 ㄴ(2·5점)", cellsPerLine: 4),
    BrailleLetterItem(name: "음료, 캔 음료에 뭉뚱그려 적힌 점자 예시. 초성 이응은 생략됩니다", letter: "음료", dotLabel: "ㅡ(2·4·6점) + 받침 ㅁ(2·6점) + ㄹ(5점) + ㅛ(3·4·6점)", cellsPerLine: 4),
]

// MARK: 실습뷰 2 — 캔 음료 점자 구별 훈련

let day20CanPracticeItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "탄산, 타 약자와 사 약자가 쓰인 네 칸짜리 점자를 만져보세요", letter: "탄산", dotLabel: "타(1·2·5점) + 받침 ㄴ(2·5점) + 사(1·2·3점) + 받침 ㄴ(2·5점)", cellsPerLine: 4),
    BrailleLetterItem(name: "음료, 초성 이응이 생략된 네 칸짜리 점자를 만져보세요", letter: "음료", dotLabel: "ㅡ(2·4·6점) + 받침 ㅁ(2·6점) + ㄹ(5점) + ㅛ(3·4·6점)", cellsPerLine: 4),
]

// MARK: 설명뷰 3 — 물음표와 받침 ㅌ의 함정

let day20TrapTitle = "똑같이 생긴 '물음표(?)'와 '받침 ㅌ'"
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
