import Foundation

// MARK: - 16일차 학습 데이터

// MARK: 설명뷰 1 — 알파벳 a~e (숫자 1~5)

let day16AlphaAETitle = "숫자 1~5 = 알파벳 a~e (거저먹기!)"
let day16AlphaAESubtitle = "a · b · c · d · e"
let day16AlphaAEDescription = "아주 놀라운 비밀이 있습니다!\n\n영어 알파벳 'a'부터 'j'까지의 점형은 우리가 8일차에 배웠던 숫자 1부터 0까지의 점형과 완벽하게 똑같습니다.\n\n먼저 'a'부터 'e'까지를 살펴볼까요? 숫자 1(1점)은 'a', 숫자 2(1·2점)는 'b'가 됩니다. 숫자만 기억한다면 이미 외운 것이나 다름없습니다!"

/// 설명뷰 1 아이템
let day16AlphaAEItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "a, 숫자 1과 같은 점형", letter: "a", dotLabel: "1점", cellsPerLine: 1),
    BrailleLetterItem(name: "b, 숫자 2와 같은 점형", letter: "b", dotLabel: "1·2점", cellsPerLine: 1),
    BrailleLetterItem(name: "c, 숫자 3과 같은 점형", letter: "c", dotLabel: "1·4점", cellsPerLine: 1),
    BrailleLetterItem(name: "d, 숫자 4와 같은 점형", letter: "d", dotLabel: "1·4·5점", cellsPerLine: 1),
    BrailleLetterItem(name: "e, 숫자 5와 같은 점형", letter: "e", dotLabel: "1·5점", cellsPerLine: 1),
]

// MARK: 실습뷰 1 — a~e 촉각 훈련

let day16AlphaAEPracticeItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "a, 숫자 1과 완전히 같은 점형을 느껴보세요", letter: "a", dotLabel: "1점", cellsPerLine: 1),
    BrailleLetterItem(name: "b, 숫자 2와 완전히 같은 점형을 느껴보세요", letter: "b", dotLabel: "1·2점", cellsPerLine: 1),
    BrailleLetterItem(name: "c, 숫자 3과 완전히 같은 점형을 느껴보세요", letter: "c", dotLabel: "1·4점", cellsPerLine: 1),
    BrailleLetterItem(name: "d, 숫자 4와 완전히 같은 점형을 느껴보세요", letter: "d", dotLabel: "1·4·5점", cellsPerLine: 1),
    BrailleLetterItem(name: "e, 숫자 5와 완전히 같은 점형을 느껴보세요", letter: "e", dotLabel: "1·5점", cellsPerLine: 1),
]

// MARK: 설명뷰 2 — 알파벳 f~j (숫자 6~0)

let day16AlphaFJTitle = "숫자 6~0 = 알파벳 f~j"
let day16AlphaFJSubtitle = "f · g · h · i · j"
let day16AlphaFJDescription = "나머지 5개도 원리는 똑같습니다.\n\n숫자 6(1·2·4점)은 'f', 숫자 7(1·2·4·5점)은 'g', 숫자 8(1·2·5점)은 'h', 숫자 9(2·4점)은 'i', 그리고 숫자 0(2·4·5점)은 'j'가 됩니다.\n\n이렇게 숫자 10개만 알면 영어 알파벳 10개를 거저 먹는 셈입니다!"

/// 설명뷰 2 아이템
let day16AlphaFJItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "f, 숫자 6과 같은 점형", letter: "f", dotLabel: "1·2·4점", cellsPerLine: 1),
    BrailleLetterItem(name: "g, 숫자 7과 같은 점형", letter: "g", dotLabel: "1·2·4·5점", cellsPerLine: 1),
    BrailleLetterItem(name: "h, 숫자 8과 같은 점형", letter: "h", dotLabel: "1·2·5점", cellsPerLine: 1),
    BrailleLetterItem(name: "i, 숫자 9와 같은 점형", letter: "i", dotLabel: "2·4점", cellsPerLine: 1),
    BrailleLetterItem(name: "j, 숫자 0과 같은 점형", letter: "j", dotLabel: "2·4·5점", cellsPerLine: 1),
]

// MARK: 실습뷰 2 — f~j 촉각 훈련

let day16AlphaFJPracticeItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "f, 숫자 6과 완전히 같은 점형을 느껴보세요", letter: "f", dotLabel: "1·2·4점", cellsPerLine: 1),
    BrailleLetterItem(name: "g, 숫자 7과 완전히 같은 점형을 느껴보세요", letter: "g", dotLabel: "1·2·4·5점", cellsPerLine: 1),
    BrailleLetterItem(name: "h, 숫자 8과 완전히 같은 점형을 느껴보세요", letter: "h", dotLabel: "1·2·5점", cellsPerLine: 1),
    BrailleLetterItem(name: "i, 숫자 9와 완전히 같은 점형을 느껴보세요", letter: "i", dotLabel: "2·4점", cellsPerLine: 1),
    BrailleLetterItem(name: "j, 숫자 0과 완전히 같은 점형을 느껴보세요", letter: "j", dotLabel: "2·4·5점", cellsPerLine: 1),
]

// MARK: 설명뷰 3 — 로마자 시작표와 종료표

let day16RomanIndicatorTitle = "알파벳과 숫자를 구별하는 마법의 기호"
let day16RomanIndicatorSubtitle = "로마자표 · 로마자 종료표"
let day16RomanIndicatorDescription = "숫자와 점형이 똑같다면 어떻게 구별할까요?\n\n국어 문장 안에 영어가 나올 때는 반드시 앞에 \"지금부터 영어입니다!\"를 알리는 로마자표(3·5·6점)를 적고, 영어가 끝나면 로마자 종료표(2·5·6점)를 적어줍니다.\n\n단, 문단 전체가 영어로만 되어 있을 때는 이 로마자표를 생략할 수 있습니다."

/// 설명뷰 3 아이템
let day16RomanIndicatorItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "로마자표, 영어 시작을 알리는 기호", letter: "로마자표", dotLabel: "로마자표(3·5·6점)", cellsPerLine: 1, rawDots: "356", rawDotLabels: "로마자표"),
    BrailleLetterItem(name: "로마자 종료표, 영어 끝을 알리는 기호", letter: "종료표", dotLabel: "종료표(2·5·6점)", cellsPerLine: 1, rawDots: "256", rawDotLabels: "종료표"),
]

// MARK: 실습뷰 3 — 로마자표 촉각 훈련

let day16RomanIndicatorPracticeItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "알파벳 a, 로마자표 뒤에 1점이 오고 종료표로 끝나는 점형을 만져보세요", letter: "알파벳 a", dotLabel: "로마자표(3·5·6점) + a(1점) + 종료표(2·5·6점)", cellsPerLine: 3, rawDots: "356,1,256", rawDotLabels: "로마자표,a,종료표"),
    BrailleLetterItem(name: "알파벳 b, 로마자표 뒤에 1·2점이 오고 종료표로 끝나는 점형을 만져보세요", letter: "알파벳 b", dotLabel: "로마자표(3·5·6점) + b(1·2점) + 종료표(2·5·6점)", cellsPerLine: 3, rawDots: "356,12,256", rawDotLabels: "로마자표,b,종료표"),
    BrailleLetterItem(name: "알파벳 d, 로마자표 뒤에 1·4·5점이 오고 종료표로 끝나는 점형을 만져보세요", letter: "알파벳 d", dotLabel: "로마자표(3·5·6점) + d(1·4·5점) + 종료표(2·5·6점)", cellsPerLine: 3, rawDots: "356,145,256", rawDotLabels: "로마자표,d,종료표"),
]
