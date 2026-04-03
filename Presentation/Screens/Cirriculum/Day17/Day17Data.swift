import Foundation

// MARK: - 17일차 학습 데이터

// MARK: 설명뷰 1 — k~t: 3점 추가의 마법

let day17KTTitle = "왼쪽 맨 아래 '3점'만 추가하면 k~t 완성!"
let day17KTSubtitle = "k · l · m · n · o · p · q · r · s · t"
let day17KTDescription = "16일차에 배운 'a~j' 점형의 왼쪽 맨 아래에 '3점'을 콕! 추가하면 순서대로 'k'부터 't'가 완성됩니다.\n\n예를 들어 'a(1점)'에 3점을 더하면 'k(1·3점)'가 되고, 'b(1·2점)'에 3점을 더하면 'l(1·2·3점)'이 되는 원리입니다."

/// 설명뷰 1 아이템
let day17KTItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "k, a에 3점을 추가한 점형", letter: "k", dotLabel: "k(1·3점)", cellsPerLine: 1),
    BrailleLetterItem(name: "l, b에 3점을 추가한 점형", letter: "l", dotLabel: "l(1·2·3점)", cellsPerLine: 1),
    BrailleLetterItem(name: "m, c에 3점을 추가한 점형", letter: "m", dotLabel: "m(1·3·4점)", cellsPerLine: 1),
    BrailleLetterItem(name: "n, d에 3점을 추가한 점형", letter: "n", dotLabel: "n(1·3·4·5점)", cellsPerLine: 1),
    BrailleLetterItem(name: "o, e에 3점을 추가한 점형", letter: "o", dotLabel: "o(1·3·5점)", cellsPerLine: 1),
    BrailleLetterItem(name: "p, f에 3점을 추가한 점형", letter: "p", dotLabel: "p(1·2·3·4점)", cellsPerLine: 1),
    BrailleLetterItem(name: "q, g에 3점을 추가한 점형", letter: "q", dotLabel: "q(1·2·3·4·5점)", cellsPerLine: 1),
    BrailleLetterItem(name: "r, h에 3점을 추가한 점형", letter: "r", dotLabel: "r(1·2·3·5점)", cellsPerLine: 1),
    BrailleLetterItem(name: "s, i에 3점을 추가한 점형", letter: "s", dotLabel: "s(2·3·4점)", cellsPerLine: 1),
    BrailleLetterItem(name: "t, j에 3점을 추가한 점형", letter: "t", dotLabel: "t(2·3·4·5점)", cellsPerLine: 1),
]

// MARK: 실습뷰 1 — k~t 촉각 훈련

let day17KTPracticeItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "k, a에 3점을 추가해서 만든 점형을 느껴보세요", letter: "k", dotLabel: "k(1·3점)", cellsPerLine: 1),
    BrailleLetterItem(name: "l, b에 3점을 추가해서 만든 점형을 느껴보세요", letter: "l", dotLabel: "l(1·2·3점)", cellsPerLine: 1),
    BrailleLetterItem(name: "m, c에 3점을 추가해서 만든 점형을 느껴보세요", letter: "m", dotLabel: "m(1·3·4점)", cellsPerLine: 1),
    BrailleLetterItem(name: "n, d에 3점을 추가해서 만든 점형을 느껴보세요", letter: "n", dotLabel: "n(1·3·4·5점)", cellsPerLine: 1),
    BrailleLetterItem(name: "o, e에 3점을 추가해서 만든 점형을 느껴보세요", letter: "o", dotLabel: "o(1·3·5점)", cellsPerLine: 1),
    BrailleLetterItem(name: "p, f에 3점을 추가해서 만든 점형을 느껴보세요", letter: "p", dotLabel: "p(1·2·3·4점)", cellsPerLine: 1),
    BrailleLetterItem(name: "q, g에 3점을 추가해서 만든 점형을 느껴보세요", letter: "q", dotLabel: "q(1·2·3·4·5점)", cellsPerLine: 1),
    BrailleLetterItem(name: "r, h에 3점을 추가해서 만든 점형을 느껴보세요", letter: "r", dotLabel: "r(1·2·3·5점)", cellsPerLine: 1),
    BrailleLetterItem(name: "s, i에 3점을 추가해서 만든 점형을 느껴보세요", letter: "s", dotLabel: "s(2·3·4점)", cellsPerLine: 1),
    BrailleLetterItem(name: "t, j에 3점을 추가해서 만든 점형을 느껴보세요", letter: "t", dotLabel: "t(2·3·4·5점)", cellsPerLine: 1),
]

// MARK: 설명뷰 2 — u~z: 3·6점 추가와 w의 예외

let day17UZTitle = "맨 아래 두 점 '3·6점' 추가하기 (w는 예외)"
let day17UZSubtitle = "u · v · x · y · z · w(예외)"
let day17UZDescription = "이번엔 맨 처음 배운 'a~e' 점형의 맨 아래 두 점 '3·6점'을 동시에 추가해 보세요. 순서대로 'u, v, x, y, z'가 완성됩니다.\n\n단, 프랑스어 점자를 처음 만들 당시 쓰이지 않았던 'w'만은 이 규칙에서 벗어나 숫자 0(2·4·5점)에 6점을 붙인 예외 모양(2·4·5·6점)을 가집니다."

/// 설명뷰 2 아이템
let day17UZItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "u, a에 3·6점을 추가한 점형", letter: "u", dotLabel: "u(1·3·6점)", cellsPerLine: 1),
    BrailleLetterItem(name: "v, b에 3·6점을 추가한 점형", letter: "v", dotLabel: "v(1·2·3·6점)", cellsPerLine: 1),
    BrailleLetterItem(name: "w, 예외 글자로 규칙에서 벗어난 점형", letter: "w", dotLabel: "w(2·4·5·6점)", cellsPerLine: 1),
    BrailleLetterItem(name: "x, c에 3·6점을 추가한 점형", letter: "x", dotLabel: "x(1·3·4·6점)", cellsPerLine: 1),
    BrailleLetterItem(name: "y, d에 3·6점을 추가한 점형", letter: "y", dotLabel: "y(1·3·4·5·6점)", cellsPerLine: 1),
    BrailleLetterItem(name: "z, e에 3·6점을 추가한 점형", letter: "z", dotLabel: "z(1·3·5·6점)", cellsPerLine: 1),
]

// MARK: 실습뷰 2 — u~z 촉각 훈련

let day17UZPracticeItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "u, a에 3·6점을 더해 만든 점형을 느껴보세요", letter: "u", dotLabel: "u(1·3·6점)", cellsPerLine: 1),
    BrailleLetterItem(name: "v, b에 3·6점을 더해 만든 점형을 느껴보세요", letter: "v", dotLabel: "v(1·2·3·6점)", cellsPerLine: 1),
    BrailleLetterItem(name: "w, 규칙에서 홀로 벗어난 예외 글자를 느껴보세요", letter: "w", dotLabel: "w(2·4·5·6점)", cellsPerLine: 1),
    BrailleLetterItem(name: "x, c에 3·6점을 더해 만든 점형을 느껴보세요", letter: "x", dotLabel: "x(1·3·4·6점)", cellsPerLine: 1),
    BrailleLetterItem(name: "y, d에 3·6점을 더해 만든 점형을 느껴보세요", letter: "y", dotLabel: "y(1·3·4·5·6점)", cellsPerLine: 1),
    BrailleLetterItem(name: "z, e에 3·6점을 더해 만든 점형을 느껴보세요", letter: "z", dotLabel: "z(1·3·5·6점)", cellsPerLine: 1),
]

// MARK: 설명뷰 3 — 대문자 기호표와 대문자 단어표

let day17CapitalTitle = "글자와 단어를 키우는 6점의 마법"
let day17CapitalSubtitle = "대문자 기호표 · 대문자 단어표"
let day17CapitalDescription = "점자 알파벳은 기본적으로 소문자입니다.\n\n한 글자만 대문자일 때는 해당 알파벳 바로 앞에 대문자 기호표(6점)를 한 번만 찍어줍니다.\n\n만약 'APPLE'처럼 단어 전체가 대문자이거나 두 글자 이상 연속해서 대문자일 때는, 단어 앞에 대문자 단어표(6·6점)를 두 번 연달아 찍어주면 전체가 대문자로 변신합니다."

/// 설명뷰 3 아이템
let day17CapitalItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "대문자 기호표, 한 글자를 대문자로 만드는 기호", letter: "기호표", dotLabel: "기호표(6점)", cellsPerLine: 1, rawDots: "6", rawDotLabels: "대문자 기호표"),
    BrailleLetterItem(name: "대문자 단어표, 단어 전체를 대문자로 만드는 기호", letter: "단어표", dotLabel: "단어표(6점) + (6점)", cellsPerLine: 2, rawDots: "6,6", rawDotLabels: "대문자,단어표"),
]

// MARK: 실습뷰 3 — 기호표와 단어표 훈련

let day17CapitalPracticeItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "apple, 기호 없이 쓰인 소문자 단어를 만져보세요", letter: "apple", dotLabel: "a + p + p + l + e", cellsPerLine: 4),
    BrailleLetterItem(name: "Apple, 6점이 한 개 붙어 첫 글자만 대문자인 단어를 만져보세요", letter: "Apple", dotLabel: "기호표(6점) + a + p + p + l + e", cellsPerLine: 4),
    BrailleLetterItem(name: "APPLE, 6점이 두 개 붙어 단어 전체가 대문자인 점형을 만져보세요", letter: "APPLE", dotLabel: "단어표(6점) + (6점) + a + p + p + l + e", cellsPerLine: 4),
]

// MARK: 설명뷰 4 — 대문자 구절표와 종료표

let day17PhraseTitle = "긴 대문자 문장 한 번에 묶기 (6, 6, 6)"
let day17PhraseSubtitle = "대문자 구절표 · 대문자 종료표"
let day17PhraseDescription = "'I AM A STUDENT'처럼 세 개 이상의 연속된 단어가 모두 대문자일 때는 아주 편리한 방법이 있습니다.\n\n맨 첫 단어 앞에 대문자 구절표(6·6·6점)를 세 번 찍고, 대문자가 끝나는 마지막 단어 바로 뒤에 대문자 종료표(6·3점)를 꽉 찍어 영역을 닫아주면 그 안의 모든 단어가 대문자로 읽힙니다."

/// 설명뷰 4 아이템
let day17PhraseItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "대문자 구절표, 세 단어 이상 대문자 시작 기호", letter: "구절표", dotLabel: "구절표(6점) + (6점) + (6점)", cellsPerLine: 3, rawDots: "6,6,6", rawDotLabels: "대문자,구절표,시작"),
    BrailleLetterItem(name: "대문자 종료표, 대문자 구간 끝을 알리는 기호", letter: "종료표", dotLabel: "종료표(6점) + (3점)", cellsPerLine: 2, rawDots: "6,3", rawDotLabels: "대문자,종료표"),
]

// MARK: 실습뷰 4 — 구절표 훈련

let day17PhrasePracticeItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "대문자 구절표, 6점이 세 번 연속된 점형을 만져보세요", letter: "구절표", dotLabel: "구절표(6점) + (6점) + (6점)", cellsPerLine: 3, rawDots: "6,6,6", rawDotLabels: "대문자,구절표,시작"),
    BrailleLetterItem(name: "대문자 종료표, 6점과 3점이 연속된 점형을 만져보세요", letter: "종료표", dotLabel: "종료표(6점) + (3점)", cellsPerLine: 2, rawDots: "6,3", rawDotLabels: "대문자,종료표"),
    BrailleLetterItem(name: "I AM A MAN, 구절표로 감싸진 대문자 문장 전체를 만져보세요", letter: "I AM A MAN", dotLabel: "구절표 + I AM A MAN + 종료표", cellsPerLine: 4),
]
