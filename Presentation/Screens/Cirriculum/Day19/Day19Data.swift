import Foundation

// MARK: - 19일차 학습 데이터

// MARK: 설명뷰 1 — 5대 연산 기호

let day19OperatorsTitle = "연산 기호"
let day19OperatorsSubtitle = "+ · − · × · ÷ · ="
let day19OperatorsDescription = "점자에서도 수학 기호를 그대로 사용합니다. 가장 많이 쓰이는 5가지 기호의 점형을 외워볼까요?\n\n더하기(+)는 2·6점, 빼기(−)는 3·5점, 곱하기(×)는 1·6점입니다. 나누기(÷)는 3·4점이 두 번 반복되고, 등호(=)는 2·5점이 두 번 반복되어 각각 두 칸을 차지합니다."

let day19OperatorsItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "덧셈 기호, 더하기를 나타내는 부호", letter: "+", dotLabel: "2·6점", cellsPerLine: 1, rawDots: "26", rawDotLabels: "덧셈"),
    BrailleLetterItem(name: "뺄셈 기호, 빼기를 나타내는 부호", letter: "−", dotLabel: "3·5점", cellsPerLine: 1, rawDots: "35", rawDotLabels: "뺄셈"),
    BrailleLetterItem(name: "곱셈 기호, 곱하기를 나타내는 부호", letter: "×", dotLabel: "1·6점", cellsPerLine: 1, rawDots: "16", rawDotLabels: "곱셈"),
    BrailleLetterItem(name: "나눗셈 기호, 나누기를 나타내는 두 칸짜리 부호", letter: "÷", dotLabel: "3·4점 + 3·4점", cellsPerLine: 2, rawDots: "34,34", rawDotLabels: "나눗셈"),
    BrailleLetterItem(name: "등호, 같음을 나타내는 두 칸짜리 부호", letter: "=", dotLabel: "2·5점 + 2·5점", cellsPerLine: 2, rawDots: "25,25", rawDotLabels: "등호"),
]

// MARK: 실습뷰 1 — 5가지 연산 기호 촉각 훈련

let day19OperatorsPracticeItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "덧셈 기호, 2·6점으로 이루어진 더하기 부호를 만져보세요", letter: "+", dotLabel: "2·6점", cellsPerLine: 1, rawDots: "26", rawDotLabels: "덧셈"),
    BrailleLetterItem(name: "뺄셈 기호, 3·5점으로 이루어진 빼기 부호를 만져보세요", letter: "−", dotLabel: "3·5점", cellsPerLine: 1, rawDots: "35", rawDotLabels: "뺄셈"),
    BrailleLetterItem(name: "곱셈 기호, 1·6점으로 이루어진 곱하기 부호를 만져보세요", letter: "×", dotLabel: "1·6점", cellsPerLine: 1, rawDots: "16", rawDotLabels: "곱셈"),
    BrailleLetterItem(name: "나눗셈 기호, 3·4점이 두 번 반복되는 나누기 부호를 만져보세요", letter: "÷", dotLabel: "3·4점 + 3·4점", cellsPerLine: 2, rawDots: "34,34", rawDotLabels: "나눗셈"),
    BrailleLetterItem(name: "등호, 2·5점이 두 번 반복되는 같음 부호를 만져보세요", letter: "=", dotLabel: "2·5점 + 2·5점", cellsPerLine: 2, rawDots: "25,25", rawDotLabels: "등호"),
]

// MARK: 설명뷰 2 — 연산 기호 띄어쓰기 규칙

let day19SpacingTitle = "연산 기호에서의 띄어쓰기"
let day19SpacingSubtitle = "숫자 사이 붙임 · 글자 사이 띄움"
let day19SpacingDescription = "연산 기호는 앞뒤에 어떤 글자가 오느냐에 따라 띄어쓰기가 달라지는 중요한 원칙이 있습니다.\n\n숫자 사이에 올 때는 '5+7'처럼 빈칸 없이 바짝 붙여 적고, 한글 사이에 올 때는 '나 + 너'처럼 기호 앞뒤를 반드시 한 칸씩 띄어 써야 합니다.\n\n또한 연산 기호 앞뒤로 숫자가 올 때는 양쪽 숫자 모두 수표(3·4·5·6점)를 꼭 붙여 줘야 합니다."

let day19SpacingItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "5+7, 숫자 사이 더하기 부호는 빈칸 없이 붙여 씁니다", letter: "5+7", dotLabel: "수표(3·4·5·6점) + 5(1·5점) + 더하기(2·6점) + 수표(3·4·5·6점) + 7(1·2·4·5점)", cellsPerLine: 5),
    BrailleLetterItem(name: "나 + 너, 한글 사이 더하기 부호는 앞뒤로 한 칸씩 띄어 씁니다", letter: "나 + 너", dotLabel: "ㄴ(1·4점) + ㅏ(1·2·6점) + 빈칸 + 더하기(2·6점) + 빈칸 + ㄴ(1·4점) + ㅓ(2·3·4점)", cellsPerLine: 7),
]

// MARK: 실습뷰 2 — 붙임 vs 띄움 공간감 훈련

let day19SpacingPracticeItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "5+7, 숫자끼리 붙여 쓴 덧셈식을 만져보세요. 수표 뒤에 숫자와 기호가 빈칸 없이 이어집니다", letter: "5+7", dotLabel: "수표+5+덧셈+수표+7", cellsPerLine: 4),
    BrailleLetterItem(name: "3=3, 숫자끼리 등호로 이은 식을 만져보세요. 등호는 두 칸을 차지합니다", letter: "3=3", dotLabel: "수표+3+등호+등호+수표+3", cellsPerLine: 4),
    BrailleLetterItem(name: "나 + 너, 한글 사이 연산 기호 앞뒤로 빈칸이 있는 점형을 만져보세요", letter: "나 + 너", dotLabel: "나+빈칸+덧셈+빈칸+너", cellsPerLine: 4),
]

// MARK: 설명뷰 3 — 단독 자음 표기 규칙 (온표)

let day19OntpTitle = "자음이 홀로 쓰일 때 (온표)"
let day19OntpSubtitle = "온표 + 받침 자음"
let day19OntpDescription = "'ㄱ. 1+1'처럼 한글 자음 하나가 번호처럼 단독으로 쓰일 때가 있습니다.\n\n점자에서는 초성과 모음 없이 자음만 덩그러니 있으면 읽기 어렵기 때문에, 반드시 자음 앞에 6개의 점이 꽉 찬 '온표(1·2·3·4·5·6점)'를 먼저 찍어 줍니다.\n\n또한 이때의 자음은 첫소리 모양이 아니라 반드시 '받침 모양'으로 적어야 합니다."

let day19OntpItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "온표, 6개의 점이 모두 채워진 마법의 부호", letter: "온표", dotLabel: "온표(1·2·3·4·5·6점)", cellsPerLine: 1, rawDots: "123456", rawDotLabels: "온표"),
    BrailleLetterItem(name: "단독 자음 기역, 온표 뒤에 받침 모양으로 적습니다", letter: "ㄱ", dotLabel: "온표(1·2·3·4·5·6점) + 받침 기역(1점)", cellsPerLine: 2, rawDots: "123456,1", rawDotLabels: "온표,받침 기역"),
]

// MARK: 실습뷰 3 — 실전 융합 해독 훈련

let day19OntpPracticeItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "온표, 6개의 점이 모두 채워진 마법의 부호를 만져보세요", letter: "온표", dotLabel: "온표(1·2·3·4·5·6점)", cellsPerLine: 1, rawDots: "123456", rawDotLabels: "온표"),
    BrailleLetterItem(name: "단독 자음 기역, 온표 뒤에 받침 모양의 기역이 오는 점형을 만져보세요", letter: "ㄱ", dotLabel: "온표(1·2·3·4·5·6점) + 받침 기역(1점)", cellsPerLine: 2, rawDots: "123456,1", rawDotLabels: "온표,받침 기역"),
    BrailleLetterItem(name: "ㄱ. 1+1, 단독 자음 번호와 연산 기호 규칙이 섞인 실전 문장을 해독해 보세요", letter: "ㄱ. 1+1", dotLabel: "온표+받침ㄱ+마침표+빈칸+수표+1+덧셈+수표+1", cellsPerLine: 4),
]
