import Foundation

// MARK: - 4일차 학습 데이터

struct Day4VowelGroup {
    let title: String
    let subtitle: String
    let description: String
    let items: [BrailleLetterItem]
}

let day4VowelGroups: [Day4VowelGroup] = [
    // 좌우 대칭 1: ㅏ/ㅑ, ㅓ/ㅕ
    Day4VowelGroup(
        title: "좌우 대칭 모음 ①",
        subtitle: "ㅏ · ㅑ · ㅓ · ㅕ",
        description: "'아'와 '야', '어'와 '여'는 거울에 비춘 것처럼 서로 좌우가 뒤집힌 대칭 모양입니다.\nㅏ는 1·2·6점, ㅑ는 3·4·5점\nㅓ는 2·3·4점, ㅕ는 1·5·6점",
        items: [
            BrailleLetterItem(name: "아", letter: "ㅏ", dotLabel: "1·2·6점"),
            BrailleLetterItem(name: "야", letter: "ㅑ", dotLabel: "3·4·5점"),
            BrailleLetterItem(name: "어", letter: "ㅓ", dotLabel: "2·3·4점"),
            BrailleLetterItem(name: "여", letter: "ㅕ", dotLabel: "1·5·6점"),
        ]
    ),
    // 상하 대칭: ㅗ/ㅜ, ㅛ/ㅠ
    Day4VowelGroup(
        title: "상하 대칭 모음",
        subtitle: "ㅗ · ㅜ · ㅛ · ㅠ",
        description: "'오'와 '우', '요'와 '유'는 서로 위아래가 뒤집힌 상하 대칭 구조를 가집니다.\n\nㅗ는 1·3·6점, ㅜ는 1·3·4점\nㅛ는 3·4·6점, ㅠ는 1·4·6점",
        items: [
            BrailleLetterItem(name: "오", letter: "ㅗ", dotLabel: "1·3·6점"),
            BrailleLetterItem(name: "우", letter: "ㅜ", dotLabel: "1·3·4점"),
            BrailleLetterItem(name: "요", letter: "ㅛ", dotLabel: "3·4·6점"),
            BrailleLetterItem(name: "유", letter: "ㅠ", dotLabel: "1·4·6점"),
        ]
    ),
    // 좌우 대칭 2: ㅡ/ㅣ
    Day4VowelGroup(
        title: "좌우 대칭 모음 ②",
        subtitle: "ㅡ · ㅣ",
        description: "가로로 누운 '으'와 세로로 선 '이'는\n점자에서 서로 좌우가 뒤집힌 짝꿍 모양입니다.\n\nㅡ는 오른쪽 짝수 점(2·4·6점)\nㅣ는 왼쪽 홀수 점(1·3·5점)",
        items: [
            BrailleLetterItem(name: "으", letter: "ㅡ", dotLabel: "2·4·6점"),
            BrailleLetterItem(name: "이", letter: "ㅣ", dotLabel: "1·3·5점"),
        ]
    ),
]
