import Foundation

// MARK: - 14일차 학습 데이터

// MARK: 설명뷰 1a — 'ㅗ' 계열 묶음 약자 (옥, 온, 옹)

let day14AbbrOhTitle = "'ㅗ' 계열 묶음 약자"
let day14AbbrOhSubtitle = "옥 · 온 · 옹"
let day14AbbrOhDescription = "'옥, 온, 옹'은 모음 'ㅗ'에 받침 'ㄱ, ㄴ, ㅇ'이 결합된 묶음 약자입니다.\n\n이 약자들은 한 칸으로 압축되어 있어 '온도', '옹기' 같은 단어를 쓸 때 부피를 확 줄여줍니다."

/// 설명뷰 1a 아이템
let day14AbbrOhItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "옥", letter: "옥", dotLabel: "옥(1·3·4·6점)", cellsPerLine: 1),
    BrailleLetterItem(name: "온", letter: "온", dotLabel: "온(1·2·3·5·6점)", cellsPerLine: 1),
    BrailleLetterItem(name: "옹", letter: "옹", dotLabel: "옹(1·2·3·4·5·6점)", cellsPerLine: 1),
]

// MARK: 설명뷰 1b — 'ㅜ, ㅡ, ㅣ' 계열 묶음 약자 + 운 함정

let day14AbbrUEuInTitle = "'ㅜ, ㅡ, ㅣ' 계열 묶음 약자와 '운'"
let day14AbbrUEuInSubtitle = "운 · 울 · 은 · 을 · 인"
let day14AbbrUEuInDescription = "'운, 울', '은, 을', '인' 역시 한 칸으로 압축해 쓰는 편리한 묶음 약자들입니다.\n\n여기서 '운' 약자는 숫자 '7'과 점자 모양이 똑같습니다. 따라서 '7운'처럼 숫자 바로 뒤에 '운'이 올 때는 숫자로 잘못 읽히지 않도록 반드시 숫자와 약자 사이를 한 칸 띄어 써야 합니다."

/// 설명뷰 1b 아이템
let day14AbbrUEuInItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "운", letter: "운", dotLabel: "운(1·2·4·5점)", cellsPerLine: 1),
    BrailleLetterItem(name: "울", letter: "울", dotLabel: "울(1·2·3·4·6점)", cellsPerLine: 1),
    BrailleLetterItem(name: "은", letter: "은", dotLabel: "은(1·3·5·6점)", cellsPerLine: 1),
    BrailleLetterItem(name: "을", letter: "을", dotLabel: "을(2·3·4·6점)", cellsPerLine: 1),
    BrailleLetterItem(name: "인", letter: "인", dotLabel: "인(1·2·3·4·5점)", cellsPerLine: 1),
]

// MARK: 실습뷰 1a — 'ㅗ' 계열 묶음 약자 훈련

let day14AbbrOhPracticeItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "옥, 약자의 점형을 손끝으로 느껴보세요", letter: "옥", dotLabel: "옥(1·3·4·6점)", cellsPerLine: 1),
    BrailleLetterItem(name: "온, 묵직한 약자 블록을 느껴보세요", letter: "온", dotLabel: "온(1·2·3·5·6점)", cellsPerLine: 1),
    BrailleLetterItem(name: "옹, 여섯 점이 모두 채워진 묵직한 점형을 느껴보세요", letter: "옹", dotLabel: "옹(1·2·3·4·5·6점)", cellsPerLine: 1),
]

// MARK: 실습뷰 1b — 'ㅜ, ㅡ, ㅣ' 계열 묶음 약자 + 띄어쓰기 구별 훈련

let day14AbbrUEuInPracticeItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "운, 약자의 점형을 손끝으로 느껴보세요", letter: "운", dotLabel: "운(1·2·4·5점)", cellsPerLine: 1),
    BrailleLetterItem(name: "울, 약자의 점형을 손끝으로 기억해 보세요", letter: "울", dotLabel: "울(1·2·3·4·6점)", cellsPerLine: 1),
    BrailleLetterItem(name: "인, 약자의 점형을 손끝으로 기억해 보세요", letter: "인", dotLabel: "인(1·2·3·4·5점)", cellsPerLine: 1),
    BrailleLetterItem(name: "5월, 수표 뒤에 숫자와 글자가 바짝 붙어있는 점형을 느껴보세요", letter: "5월", dotLabel: "수표 + 5 + 월", cellsPerLine: 4),
    BrailleLetterItem(name: "7운, 숫자와 운 약자 사이에 빈칸이 뚫려있는 방지턱 공간을 느껴보세요", letter: "7운", dotLabel: "수표 + 7 + 빈칸 + 운 약자", cellsPerLine: 4),
]

// MARK: 설명뷰 2 — 특수 약자 '것'과 '받침 ㅆ'

let day14SpecialAbbrTitle = "두 칸 약자 '것'과 한 칸 약자 '받침 ㅆ'"
let day14SpecialAbbrSubtitle = "것 · 받침 ㅆ"
let day14SpecialAbbrDescription = "의존 명사 '것'은 유일하게 점자 두 칸을 차지하는 특별한 약자입니다.\n\n반면,'쌍시옷(ㅆ) 받침'은 한 칸짜리 약자(3·4점)로 만들어 사용한다는 사실을 다시 한번 복습하며 넘어갑니다."

/// 설명뷰 2 아이템 — '것' 약자와 '받침 ㅆ' 약자
let day14SpecialAbbrItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "것 약자, 유일한 두 칸짜리 약자", letter: "것", dotLabel: "것(4·5·6점) + (2·3·4점)", cellsPerLine: 2),
    BrailleLetterItem(name: "받침 쌍시옷 약자, 한 칸으로 압축된 받침", letter: "ㅆ받침", dotLabel: "받침ㅆ(3·4점)", rawDots: "34"),
]

// MARK: 실습뷰 2 — 특수 약자 형태 훈련

let day14SpecialAbbrPracticeItems: [BrailleLetterItem] = [
    BrailleLetterItem(name: "것, 두 칸으로 넓게 자리 잡은 것 약자의 점형을 느껴보세요", letter: "것", dotLabel: "것(4·5·6점) + (2·3·4점)", cellsPerLine: 2),
    BrailleLetterItem(name: "받침ㅆ, 갔의 받침 부분 쌍시옷 약자를 느껴보세요", letter: "ㅆ", dotLabel: "받침ㅆ(3·4점)", rawDots: "34",rawDotLabels: "받침ㅆ"),
]
