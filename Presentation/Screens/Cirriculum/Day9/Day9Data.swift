import Foundation

// MARK: - 9일차 학습 데이터

// MARK: 설명뷰 1 — 두 자리 이상 숫자 (수표는 한 번만)

let day9MultiDigitTitle = "두 자리 이상 숫자 나란히 적기"
let day9MultiDigitSubtitle = "수표는 한 번만!"
let day9MultiDigitDescription = "'12'나 '365'처럼 여러 자리 숫자를 쓸 때는 숫자를 쓸 때마다 수표를 붙일까요? 아닙니다!\n\n맨 앞에 수표를 딱 한 번만 적고,그 뒤에는 숫자 점형만 빈칸 없이 연달아 적어주면 하나의 긴 숫자가 완성됩니다."

/// 설명뷰 1 아이템 — 두 자리 이상 숫자 예시
let day9MultiDigitItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "숫자 12, 수표 뒤에 1점과 1·2점 나란히", letter: "12", dotLabel: "수표(3·4·5·6점) + 1(1점) + 2(1·2점)"),
    BrailleLetterItem(name: "숫자 365, 수표 뒤에 1·4점, 1·2·4점, 1·5점 나란히", letter: "365", dotLabel: "수표(3·4·5·6점) + 3(1·4점) + 6(1·2·4점) + 5(1·5점)"),
]

// MARK: 실습뷰 1 — 두 자리 숫자 만져보기

let day9MultiDigitPracticeItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "숫자 12, 수표 뒤에 1점과 1-2점이 나란히 붙어있습니다", letter: "12", dotLabel: "수표(3·4·5·6점) + 1(1점) + 2(1·2점)", cellsPerLine: 3),
    BrailleLetterItem(name: "숫자 365, 수표 뒤에 세 자리 숫자가 나란히 이어집니다", letter: "365", dotLabel: "수표(3·4·5·6점) + 3(1·4점) + 6(1·2·4점) + 5(1·5점)", cellsPerLine: 4),
]

// MARK: 설명뷰 2 — 수표의 효력이 끝나는 순간

let day9EffectEndTitle = "수표의 효력이 끝나는 순간"
let day9EffectEndSubtitle = "띄어쓰기 · 한글 · 혼동 초성"
let day9EffectEndDescription = "수표의 마법은 빈칸을 만나 띄어 쓰거나,\n뒤에 한글 같은 일반 문자가 오면 즉시 끝납니다.\n\n'1일'처럼 숫자 뒤에 곧바로 한글이 올 때는 수표를 다시 적지 않고 글자를 그대로 붙여 쓰면 됩니다.\n\n단, 숫자와 모양이 같은 초성 'ㄴ, ㄷ, ㅁ, ㅋ, ㅌ, ㅍ, ㅎ'이 숫자 바로 뒤에 올 때는 반드시 한 칸을 띄어야 오독을 막을 수 있습니다."

/// 설명뷰 2 아이템 — 수표 효력 예시
let day9EffectEndItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "1일, 이응은 혼동 초성이 아니므로 붙여 씁니다", letter: "1일", dotLabel: "수표(3·4·5·6점) + 1(1점) + 일"),
    BrailleLetterItem(name: "3명, 미음은 혼동 초성이므로 띄어 씁니다", letter: "3명", dotLabel: "수표(3·4·5·6점) + 3(1·4점) + 빈칸 + 명"),
    BrailleLetterItem(name: "5톤, 티읕은 혼동 초성이므로 띄어 씁니다", letter: "5톤", dotLabel: "수표(3·4·5·6점) + 5(1·5점) + 빈칸 + 톤"),
]

// MARK: 실습뷰 2 — 숫자+한글 띄어쓰기 비교 만져보기

let day9EffectEndPracticeItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "1일, 숫자 1과 일이 바짝 붙어있는 촘촘한 점형을 느껴보세요", letter: "1일", dotLabel: "수표(3·4·5·6점) + 1(1점) + 일",cellsPerLine: 4),
    BrailleLetterItem(name: "3명, 숫자 3과 명 사이에 방지턱처럼 빈칸이 뚫려있는 점형을 느껴보세요", letter: "3명", dotLabel: "수표(3·4·5·6점) + 3(1·4점) + 빈칸 + 명",cellsPerLine: 4),
    BrailleLetterItem(name: "2층, 숫자 2와 층은 붙여 씁니다. 치읓은 혼동 초성이 아닙니다", letter: "2층", dotLabel: "수표(3·4·5·6점) + 2(1·2점) + 층",cellsPerLine: 4),
    BrailleLetterItem(name: "5톤, 숫자 5와 톤 사이에 빈칸이 뚫려있는 점형을 느껴보세요", letter: "5톤", dotLabel: "수표(3·4·5·6점) + 5(1·5점) + 빈칸 + 톤",cellsPerLine: 4),
]
