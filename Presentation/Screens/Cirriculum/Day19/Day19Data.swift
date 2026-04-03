import Foundation

// MARK: - 19일차 학습 데이터

// MARK: 설명뷰 1 — 연산 기호와 띄어쓰기

let day19MathTitle = "더하고 빼는 연산 기호의 띄어쓰기 마법"
let day19MathSubtitle = "덧셈 · 뺄셈 · 등호"
let day19MathDescription = "덧셈(+), 뺄셈(-), 등호(=) 같은 연산 기호는 점자에서 아주 중요한 띄어쓰기 규칙이 있습니다.\n\n숫자 사이에 올 때는 '5+7'처럼 빈칸 없이 바짝 붙여 적고, 한글 사이에 올 때는 '나 + 너'처럼 기호 앞뒤를 반드시 한 칸씩 띄어 써야 합니다."

/// 설명뷰 1 아이템
let day19MathItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "덧셈 기호, 더하기를 나타내는 부호", letter: "+", dotLabel: "덧셈(3·6점)", cellsPerLine: 1, rawDots: "36", rawDotLabels: "덧셈"),
    BrailleLetterItem(name: "뺄셈 기호, 빼기를 나타내는 부호", letter: "-", dotLabel: "뺄셈(3·5점)", cellsPerLine: 1, rawDots: "35", rawDotLabels: "뺄셈"),
    BrailleLetterItem(name: "등호, 같음을 나타내는 두 칸짜리 부호", letter: "=", dotLabel: "등호(2·5점) + (2·5점)", cellsPerLine: 2, rawDots: "25,25", rawDotLabels: "등호,등호"),
]

// MARK: 실습뷰 1 — 연산 기호 띄어쓰기 훈련

let day19MathPracticeItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "덧셈 기호, 3·6점으로 이루어진 더하기 부호를 만져보세요", letter: "+", dotLabel: "덧셈(3·6점)", cellsPerLine: 1, rawDots: "36", rawDotLabels: "덧셈"),
    BrailleLetterItem(name: "뺄셈 기호, 3·5점으로 이루어진 빼기 부호를 만져보세요", letter: "-", dotLabel: "뺄셈(3·5점)", cellsPerLine: 1, rawDots: "35", rawDotLabels: "뺄셈"),
    BrailleLetterItem(name: "등호, 2·5점이 두 번 반복되는 같음 부호를 만져보세요", letter: "=", dotLabel: "등호(2·5점) + (2·5점)", cellsPerLine: 2, rawDots: "25,25", rawDotLabels: "등호,등호"),
    BrailleLetterItem(name: "5+7, 숫자끼리 붙여 쓴 덧셈식을 만져보세요. 수표 뒤에 숫자와 기호가 빈칸 없이 이어집니다", letter: "5+7", dotLabel: "수표 + 5 + 덧셈 + 7", cellsPerLine: 4),
    BrailleLetterItem(name: "나 + 너, 한글 사이 연산 기호의 앞뒤로 빈칸이 있는 점형을 만져보세요", letter: "나 + 너", dotLabel: "나 + 빈칸 + 덧셈 + 빈칸 + 너", cellsPerLine: 4),
    BrailleLetterItem(name: "3=3, 숫자끼리 붙여 쓴 등호식을 만져보세요. 등호는 두 칸을 차지합니다", letter: "3=3", dotLabel: "수표 + 3 + 등호 + 등호 + 3", cellsPerLine: 5),
]

// MARK: 설명뷰 2 — 실전 문장 읽기 도입

let day19SentenceTitle = "배운 것을 모두 합쳐라! 실전 점자 읽기"
let day19SentenceSubtitle = "약자 · 숫자 · 부호 총동원"
let day19SentenceDescription = "이제 여러분은 한글 약자, 숫자, 문장 부호까지 기초 점자를 모두 마스터했습니다!\n\n실제 점자 문장을 읽을 때는 수표가 어디서 끝나는지, 어떤 약자가 숨어 있는지, 띄어쓰기는 어떻게 되어 있는지를 손끝으로 느끼며 퍼즐을 맞추듯 읽어 나갑니다."

// MARK: 실습뷰 2 — 실전 문장 읽어보기

let day19SentencePracticeItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "1 + 1 세일!, 숫자와 연산 기호, 한글, 느낌표가 모두 섞인 문장을 해독해 보세요", letter: "1 + 1 세일!", dotLabel: "숫자 + 연산 + 한글 + 부호 종합", cellsPerLine: 5),
]
