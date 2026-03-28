import Foundation

// MARK: - 12일차 학습 데이터

// MARK: 설명뷰 1 — 약자가 없는 글자 '라'와 '차'

let day12RaChaTitle = "약자가 없는 글자 '라'와 '차'"
let day12RaChaSubtitle = "라 · 차"
let day12RaChaDescription = "11일차에서 배운 'ㅏ' 생략 약자, 기억나시죠?\n\n그런데 '라'와 '차'만큼은 절대로 'ㅏ'를 생략할 수 없습니다. 왜냐하면 'ㄹ'과 'ㅊ'은 받침으로도 자주 쓰이기 때문에, 생략해 버리면 받침인지 약자인지 구분할 수 없거든요.\n\n그래서 '라'와 '차'는 항상 자음과 모음 'ㅏ'를 빠짐없이 적는 정자 형태로 적어야 합니다."

/// 설명뷰 1 아이템 — '라'와 '차' 정자
let day12RaChaItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "라, 리을과 아를 모두 적은 정자 형태", letter: "라", dotLabel: "ㄹ(5점) + ㅏ(1·2·6점)", cellsPerLine: 2),
    BrailleLetterItem(name: "차, 치읓과 아를 모두 적은 정자 형태", letter: "차", dotLabel: "ㅊ(5·6점) + ㅏ(1·2·6점)", cellsPerLine: 2),
]

// MARK: 실습뷰 1 — '라'와 '차' 정자 실습

let day12RaChaPracticeItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "라, 리을 다음에 아가 따라오는 두 칸 점형을 느껴보세요", letter: "라", dotLabel: "ㄹ(5점) + ㅏ(1·2·6점)", cellsPerLine: 2),
    BrailleLetterItem(name: "차, 치읓 다음에 아가 따라오는 두 칸 점형을 느껴보세요", letter: "차", dotLabel: "ㅊ(5·6점) + ㅏ(1·2·6점)", cellsPerLine: 2),
]

// MARK: 설명뷰 2 — 약자 뒤에 모음이 올 때 'ㅏ' 부활

let day12VowelExceptionTitle = "약자 뒤에 모음이 오면 'ㅏ' 부활!"
let day12VowelExceptionSubtitle = "나이 · 다음 · 바위"
let day12VowelExceptionDescription = "'나, 다, 마, 바, 자, 카, 타, 파, 하' 약자를 쓸 때 한 가지 더 조심해야 할 규칙이 있습니다.\n\n약자 바로 뒤에 모음으로 시작하는 글자가 이어지면, 생략했던 'ㅏ'를 반드시 살려 적어야 합니다.\n\n예를 들어 '나이'를 약자로 적으면 'ㄴ' + 'ㅣ'가 되어 '니'로 읽히고 맙니다. 그래서 'ㄴ' + 'ㅏ' + 'ㅣ' 세 칸으로 적어야 '나이'가 됩니다."

/// 설명뷰 2 아이템 — 약자 뒤 모음 예외
let day12VowelExceptionItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "나이, 약자 뒤에 모음 이가 오므로 ㅏ를 살려 세 칸으로 적습니다", letter: "나이", dotLabel: "ㄴ(1·4점) + ㅏ(1·2·6점) + ㅣ(1·3·5점)", cellsPerLine: 3),
    BrailleLetterItem(name: "니, 약자를 잘못 쓰면 이렇게 두 칸이 되어 니로 읽힙니다", letter: "니", dotLabel: "ㄴ(1·4점) + ㅣ(1·3·5점)", cellsPerLine: 2),
]

// MARK: 실습뷰 2 — '니'와 '나이' 촉각으로 구별하기

let day12VowelExceptionPracticeItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "니, 두 칸으로 이루어진 니의 점형을 느껴보세요", letter: "니", dotLabel: "ㄴ(1·4점) + ㅣ(1·3·5점)", cellsPerLine: 2),
    BrailleLetterItem(name: "나이, 세 칸으로 이루어진 나이의 점형을 느껴보세요. ㅏ가 살아 있습니다", letter: "나이", dotLabel: "ㄴ(1·4점) + ㅏ(1·2·6점) + ㅣ(1·3·5점)", cellsPerLine: 3),
]
