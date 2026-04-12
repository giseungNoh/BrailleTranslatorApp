import Foundation

// MARK: - 10일차 학습 데이터

// MARK: 설명뷰 1 — 받침 없는 글자 만들기

let day10NoJongTitle = "[복습] 받침 없는 글자 만들기"
let day10NoJongSubtitle = "자음 + 모음 = 글자"
let day10NoJongDescription = "자음과 모음을 빈칸 없이 합치면\n글자가 됩니다.\n\n점자의 가장 중요한 대원칙 기억나시죠?\n소리 나지 않는 첫소리 '이응(ㅇ)'은\n점자로 쓰지 않고 모음만 적습니다."

/// 설명뷰 1 아이템 — 받침 없는 글자
let day10NoJongItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "가, 기역과 아를 나란히", letter: "가", dotLabel: "ㄱ(4점) + ㅏ(1·2·6점)"),
    BrailleLetterItem(name: "우, 이응은 생략하고 모음만", letter: "우", dotLabel: "1·3·4점"),
    BrailleLetterItem(name: "나, 니은과 아를 나란히", letter: "나", dotLabel: "ㄴ(1·4점) + ㅏ(1·2·6점)"),
]

// MARK: 실습뷰 1 — 받침 없는 글자 조립 훈련

let day10NoJongPracticeItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "가, 첫소리 기역과 모음 아를 나란히 붙여 보세요", letter: "가", dotLabel: "ㄱ(4점) + ㅏ(1·2·6점)", cellsPerLine: 2),
    BrailleLetterItem(name: "우, 첫소리 이응은 비워두고 모음 우만 적습니다", letter: "우", dotLabel: "1·3·4점"),
    BrailleLetterItem(name: "나, 첫소리 니은과 모음 아를 나란히 붙여 보세요", letter: "나", dotLabel: "ㄴ(1·4점) + ㅏ(1·2·6점)", cellsPerLine: 2),
    BrailleLetterItem(name: "소, 첫소리 시옷과 모음 오를 나란히 붙여 보세요", letter: "소", dotLabel: "ㅅ(6점) + ㅗ(1·3·6점)", cellsPerLine: 2),
]

// MARK: 설명뷰 2 — 받침 있는 글자 만들기

let day10WithJongTitle = "[복습] 받침 있는 글자 만들기"
let day10WithJongSubtitle = "자음 + 모음 + 받침"
let day10WithJongDescription = "받침이 있는 글자는 자음과 모음 뒤에\n홑받침을 연달아 붙여 완성합니다.\n\n단, 첫소리와 달리 받침 '이응(ㅇ)'은\n소리가 나기 때문에 점자\n(2-3-5-6점)를 꼭 적어주어야\n한다는 점 잊지 마세요."

/// 설명뷰 2 아이템 — 받침 있는 글자
let day10WithJongItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "강, 기역 아 받침이응 나란히", letter: "강", dotLabel: "ㄱ(4점) + ㅏ(1·2·6점) + 받침ㅇ(2·3·5·6점)"),
    BrailleLetterItem(name: "산, 시옷 아 받침니은 나란히", letter: "산", dotLabel: "ㅅ(6점) + ㅏ(1·2·6점) + 받침ㄴ(2·5점)"),
    BrailleLetterItem(name: "물, 모음 우와 받침리을 나란히, 이응 생략", letter: "물", dotLabel: "ㅁ(1·5점) + ㅜ(1·3·4점) + 받침ㄹ(2점)"),
]

// MARK: 실습뷰 2 — 받침 있는 글자 조립 훈련

let day10WithJongPracticeItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "강, 자음 모음 받침이 하나의 덩어리로 합쳐지는 느낌을 기억하세요", letter: "강", dotLabel: "ㄱ(4점) + ㅏ(1·2·6점) + 받침ㅇ(2·3·5·6점)", cellsPerLine: 3),
    BrailleLetterItem(name: "산, 시옷 아 받침니은을 나란히 붙여 보세요", letter: "산", dotLabel: "ㅅ(6점) + ㅏ(1·2·6점) + 받침ㄴ(2·5점)", cellsPerLine: 3),
    BrailleLetterItem(name: "물, 미음 우 받침리을을 나란히 붙여 보세요", letter: "물", dotLabel: "ㅁ(1·5점) + ㅜ(1·3·4점) + 받침ㄹ(2점)", cellsPerLine: 3),
]

// MARK: 설명뷰 3 — 수표와 숫자+한글 띄어쓰기 복습

let day10NumberTitle = "[복습] 수표의 마법과 숫자+한글 띄어쓰기"
let day10NumberSubtitle = "붙여쓰기 vs 띄어쓰기"
let day10NumberDescription = "숫자를 쓸 때는 항상 맨 앞에 '수표(3-4-5-6점)'를 먼저 붙여야 합니다.\n\n수표를 붙인 숫자 바로 뒤에 한글이 올 때는 기본적으로 빈칸 없이 붙여 씁니다.\n\n 숫자와 똑같이 생긴 첫소리 'ㄴ, ㄷ, ㅁ, ㅋ, ㅌ, ㅍ, ㅎ'와 '운' 약자가 숫자 바로 뒤에 올 때는 한 칸 띄어 써야 합니다."

/// 설명뷰 3 아이템 — 숫자+한글 규칙 복습
let day10NumberItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "3층, 치읓은 혼동 초성이 아니므로 붙여 씁니다", letter: "3층", dotLabel: "수표(3·4·5·6점) + 3(1·4점) + 층"),
    BrailleLetterItem(name: "3명, 미음은 혼동 초성이므로 띄어 씁니다", letter: "3명", dotLabel: "수표(3·4·5·6점) + 3(1·4점) + 빈칸 + 명"),
    BrailleLetterItem(name: "5월, 이응은 혼동 초성이 아니므로 붙여 씁니다", letter: "5월", dotLabel: "수표(3·4·5·6점) + 5(1·5점) + 월"),
]

// MARK: 실습뷰 3 — 숫자+한글 예외 규칙 훈련

let day10NumberPracticeItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "3층, 수표 뒤에 바짝 붙여 쓰는 점형을 느껴보세요", letter: "3층", dotLabel: "수표(3·4·5·6점) + 3(1·4점) + 층", cellsPerLine: 4),
    BrailleLetterItem(name: "3명, 수표 뒤에 방지턱처럼 한 칸 띄워 쓰는 점형을 느껴보세요", letter: "3명", dotLabel: "수표(3·4·5·6점) + 3(1·4점) + 빈칸 + 명", cellsPerLine: 4),
    BrailleLetterItem(name: "5월, 수표 뒤에 바짝 붙여 쓰는 점형을 느껴보세요", letter: "5월", dotLabel: "수표(3·4·5·6점) + 5(1·5점) + 월", cellsPerLine: 4),
]
