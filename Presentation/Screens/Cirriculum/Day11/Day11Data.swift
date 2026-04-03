import Foundation

// MARK: - 11일차 학습 데이터

// MARK: 설명뷰 1 — 고유 약자

let day11UniqueAbbrTitle = "특별한 모양을 가진 고유 약자"
let day11UniqueAbbrSubtitle = "가 · 사 · 까 · 싸"
let day11UniqueAbbrDescription = "점자에는 글자 수를 줄여 손가락이 읽는 속도를 높여주는 '약자'가 있습니다.\n\n그중 '가, 사, 까, 싸'는 첫소리 자음이나 모음과는 전혀 다른 모양으로, 그 글자만을 위해 특별하게 만들어진 독립적인 점형을 사용합니다."

/// 설명뷰 1 아이템 — 고유 약자
let day11UniqueAbbrItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "가 약자, 1·2·4·6점", letter: "가", dotLabel: "1·2·4·6점"),
    BrailleLetterItem(name: "사 약자, 1·2·3점", letter: "사", dotLabel: "1·2·3점"),
    BrailleLetterItem(name: "까 약자, 된소리표와 가 약자", letter: "까", dotLabel: "된소리표(6점) + 가(1·2·4·6점)"),
    BrailleLetterItem(name: "싸 약자, 된소리표와 사 약자", letter: "싸", dotLabel: "된소리표(6점) + 사(1·2·3점)"),
]

// MARK: 실습뷰 1 — 고유 약자 훈련

let day11UniqueAbbrPracticeItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "가 약자, 자음과 모음 두 칸이 하나로 압축된 점형을 느껴보세요", letter: "가", dotLabel: "1·2·4·6점"),
    BrailleLetterItem(name: "사 약자, 하나의 칸으로 압축된 점형을 느껴보세요", letter: "사", dotLabel: "1·2·3점"),
    BrailleLetterItem(name: "까 약자, 된소리표 뒤에 가 약자가 붙습니다", letter: "까", dotLabel: "된소리표(6점) + 가(1·2·4·6점)", cellsPerLine: 2),
    BrailleLetterItem(name: "싸 약자, 된소리표 뒤에 사 약자가 붙습니다", letter: "싸", dotLabel: "된소리표(6점) + 사(1·2·3점)", cellsPerLine: 2),
]

// MARK: 설명뷰 2 — 'ㅏ' 생략 약자

let day11AomitTitle = "모음 'ㅏ'를 생략하는 약자들"
let day11AomitSubtitle = "나 · 다 · 마 · 바 · 자 · 카 · 타 · 파 · 하"
let day11AomitDescription = "아주 재미있는 규칙입니다! '나, 다, 마, 바, 자, 카, 타, 파, 하' 그리고 '따, 빠, 짜'는 모음 'ㅏ'를 굳이 적지 않고 첫소리 자음만 적어두면, 그 자음이 통째로 'ㅏ'가 포함된 글자로 변신합니다.\n\n예를 들어 '바다'는 모음 없이 자음 'ㅂ'과 'ㄷ'만 연달아 적으면 완성됩니다!"

/// 설명뷰 2 아이템 — 'ㅏ' 생략 약자
let day11AomitItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "나 약자, 첫소리 니은만 적으면 나가 됩니다", letter: "나", dotLabel: "1·4점"),
    BrailleLetterItem(name: "다 약자, 첫소리 디귿만 적으면 다가 됩니다", letter: "다", dotLabel: "2·4점"),
    BrailleLetterItem(name: "마 약자, 첫소리 미음만 적으면 마가 됩니다", letter: "마", dotLabel: "1·5점"),
    BrailleLetterItem(name: "바 약자, 첫소리 비읍만 적으면 바가 됩니다", letter: "바", dotLabel: "4·5점"),
    BrailleLetterItem(name: "자 약자, 첫소리 지읒만 적으면 자가 됩니다", letter: "자", dotLabel: "4·6점"),
    BrailleLetterItem(name: "하 약자, 첫소리 히읗만 적으면 하가 됩니다", letter: "하", dotLabel: "2·4·5점"),
]

// MARK: 실습뷰 2 — 'ㅏ' 생략 약자로 단어 만들기

let day11AomitPracticeItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "바다, 바 약자와 다 약자 나란히, 모음 없이 자음만으로 단어가 완성됩니다", letter: "바다", dotLabel: "바(4·5점) + 다(2·4점)", cellsPerLine: 2),
    BrailleLetterItem(name: "마자, 마 약자와 자 약자 나란히", letter: "마자", dotLabel: "마(1·5점) + 자(4·6점)", cellsPerLine: 2),
    BrailleLetterItem(name: "하나, 하 약자와 나 약자 나란히", letter: "하나", dotLabel: "하(2·4·5점) + 나(1·4점)", cellsPerLine: 2),
    BrailleLetterItem(name: "카타, 카 약자와 타 약자 나란히", letter: "카타", dotLabel: "카(1·2·4점) + 타(1·2·5점)", cellsPerLine: 2),
]
