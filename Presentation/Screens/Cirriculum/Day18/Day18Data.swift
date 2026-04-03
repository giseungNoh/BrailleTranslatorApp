import Foundation

// MARK: - 18일차 학습 데이터

// MARK: 설명뷰 1 — 기본 문장 부호

let day18BasicPuncTitle = "문장을 끝내고 쉬어가는 기본 부호"
let day18BasicPuncSubtitle = "마침표 · 물음표 · 느낌표 · 쉼표"
let day18BasicPuncDescription = "마침표(2·5·6점), 물음표(2·3·6점), 느낌표(2·3·5점), 쉼표(5점)는 문장을 구성하는 가장 기본적인 부호입니다.\n\n이 부호들은 점자 칸의 중간과 아래쪽(2, 3, 5, 6점)에 치우쳐서 묵직하게 가라앉아 있는 듯한 모양을 띠며, 앞말에 빈칸 없이 바짝 붙여 적습니다."

/// 설명뷰 1 아이템
let day18BasicPuncItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "마침표, 문장의 끝을 나타내는 부호", letter: "마침표", dotLabel: "마침표(2·5·6점)", cellsPerLine: 1, rawDots: "256", rawDotLabels: "마침표"),
    BrailleLetterItem(name: "물음표, 의문문의 끝을 나타내는 부호", letter: "물음표", dotLabel: "물음표(2·3·6점)", cellsPerLine: 1, rawDots: "236", rawDotLabels: "물음표"),
    BrailleLetterItem(name: "느낌표, 감탄문의 끝을 나타내는 부호", letter: "느낌표", dotLabel: "느낌표(2·3·5점)", cellsPerLine: 1, rawDots: "235", rawDotLabels: "느낌표"),
    BrailleLetterItem(name: "쉼표, 문장 안에서 잠깐 쉬어가는 부호", letter: "쉼표", dotLabel: "쉼표(5점)", cellsPerLine: 1, rawDots: "5", rawDotLabels: "쉼표"),
]

// MARK: 실습뷰 1 — 기본 부호 촉각 훈련

let day18BasicPuncPracticeItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "마침표, 2·5·6점이 아래쪽에 묵직하게 놓인 점형을 느껴보세요", letter: "마침표", dotLabel: "마침표(2·5·6점)", cellsPerLine: 1, rawDots: "256", rawDotLabels: "마침표"),
    BrailleLetterItem(name: "물음표, 2·3·6점이 왼쪽 아래와 오른쪽에 걸친 점형을 느껴보세요", letter: "물음표", dotLabel: "물음표(2·3·6점)", cellsPerLine: 1, rawDots: "236", rawDotLabels: "물음표"),
    BrailleLetterItem(name: "느낌표, 2·3·5점이 왼쪽에 치우친 점형을 느껴보세요", letter: "느낌표", dotLabel: "느낌표(2·3·5점)", cellsPerLine: 1, rawDots: "235", rawDotLabels: "느낌표"),
    BrailleLetterItem(name: "쉼표, 5점 하나만 찍힌 가장 가벼운 부호를 느껴보세요", letter: "쉼표", dotLabel: "쉼표(5점)", cellsPerLine: 1, rawDots: "5", rawDotLabels: "쉼표"),
]

// MARK: 설명뷰 2 — 쌍으로 쓰이는 묶음 부호

let day18PairPuncTitle = "데칼코마니처럼 마주 보는 묶음 부호"
let day18PairPuncSubtitle = "큰따옴표 · 소괄호"
let day18PairPuncDescription = "큰따옴표(\u{201C} \u{201D})와 소괄호(( ))처럼 쌍으로 쓰이는 부호들은 아주 재미있는 대칭 구조를 가집니다.\n\n여는 부호는 뒷말에 붙여 쓰고, 닫는 부호는 앞말에 바짝 붙여 씁니다.\n\n특히 소괄호는 '여는 소괄호(2·3·6점, 3점)'와 '닫는 소괄호(6점, 3·5·6점)'처럼 두 칸씩 차지하여 글자를 감싸줍니다."

/// 설명뷰 2 아이템
let day18PairPuncItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "여는 큰따옴표, 인용 시작을 나타내는 부호", letter: "\u{201C}", dotLabel: "여는 큰따옴표(2·3·6점)", cellsPerLine: 1, rawDots: "236", rawDotLabels: "여는 큰따옴표"),
    BrailleLetterItem(name: "닫는 큰따옴표, 인용 끝을 나타내는 부호", letter: "\u{201D}", dotLabel: "닫는 큰따옴표(3·5·6점)", cellsPerLine: 1, rawDots: "356", rawDotLabels: "닫는 큰따옴표"),
    BrailleLetterItem(name: "여는 소괄호, 보충 설명 시작을 나타내는 두 칸짜리 부호", letter: "(", dotLabel: "여는 소괄호(2·3·6점) + (3점)", cellsPerLine: 2, rawDots: "236,3", rawDotLabels: "여는,소괄호"),
    BrailleLetterItem(name: "닫는 소괄호, 보충 설명 끝을 나타내는 두 칸짜리 부호", letter: ")", dotLabel: "닫는 소괄호(6점) + (3·5·6점)", cellsPerLine: 2, rawDots: "6,356", rawDotLabels: "닫는,소괄호"),
]

// MARK: 실습뷰 2 — 대칭 구조 훈련

let day18PairPuncPracticeItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "여는 큰따옴표, 2·3·6점의 왼쪽 아래와 오른쪽 위 점형을 느껴보세요", letter: "\u{201C}", dotLabel: "여는 큰따옴표(2·3·6점)", cellsPerLine: 1, rawDots: "236", rawDotLabels: "여는 큰따옴표"),
    BrailleLetterItem(name: "닫는 큰따옴표, 3·5·6점이 여는 따옴표와 거울처럼 대칭인 점형을 느껴보세요", letter: "\u{201D}", dotLabel: "닫는 큰따옴표(3·5·6점)", cellsPerLine: 1, rawDots: "356", rawDotLabels: "닫는 큰따옴표"),
    BrailleLetterItem(name: "여는 소괄호, 2·3·6점과 3점이 이어진 두 칸짜리 점형을 느껴보세요", letter: "(", dotLabel: "여는 소괄호(2·3·6점) + (3점)", cellsPerLine: 2, rawDots: "236,3", rawDotLabels: "여는,소괄호"),
    BrailleLetterItem(name: "닫는 소괄호, 6점과 3·5·6점이 이어진 두 칸짜리 점형을 느껴보세요", letter: ")", dotLabel: "닫는 소괄호(6점) + (3·5·6점)", cellsPerLine: 2, rawDots: "6,356", rawDotLabels: "닫는,소괄호"),
]
