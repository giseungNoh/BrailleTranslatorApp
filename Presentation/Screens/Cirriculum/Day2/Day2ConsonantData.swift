import Foundation

// MARK: - 자음 그룹 데이터

struct Day2ConsonantGroup {
    let title: String
    let subtitle: String
    let description: String
    let items: [BrailleLetterItem]
}

let day2ConsonantGroups: [Day2ConsonantGroup] = [
    Day2ConsonantGroup(
        title: "4점 중심 자음",
        subtitle: "ㄱ · ㄴ · ㄷ",
        description: "오른쪽 맨 위 4점을 기준으로\n점이 하나씩 늘어나는 글자들입니다.\n\nㄱ은 4점, ㄴ은 1·4점,\nㄷ은 2·4점으로 구성되어 있습니다.",
        items: [
            BrailleLetterItem(name: "기역", letter: "ㄱ", dotLabel: "4점"),
            BrailleLetterItem(name: "니은", letter: "ㄴ", dotLabel: "1·4점"),
            BrailleLetterItem(name: "디귿", letter: "ㄷ", dotLabel: "2·4점"),
        ]
    ),
    Day2ConsonantGroup(
        title: "5점 중심 자음",
        subtitle: "ㄹ · ㅁ · ㅂ",
        description: "오른쪽 가운데 5점을 기준으로 하는\n리을, 미음, 비읍입니다.\n\nㄹ은 5점, ㅁ은 1·5점,\nㅂ은 4·5점으로 구성되어 있습니다.",
        items: [
            BrailleLetterItem(name: "리을", letter: "ㄹ", dotLabel: "5점"),
            BrailleLetterItem(name: "미음", letter: "ㅁ", dotLabel: "1·5점"),
            BrailleLetterItem(name: "비읍", letter: "ㅂ", dotLabel: "4·5점"),
        ]
    ),
    Day2ConsonantGroup(
        title: "6점 중심 자음",
        subtitle: "ㅅ · ㅈ · ㅊ",
        description: "오른쪽 맨 아래 6점을 기준으로 하는\n시옷, 지읒, 치읓입니다.\n\nㅅ은 6점, ㅈ은 4·6점,\nㅊ은 5·6점으로 구성되어 있습니다.",
        items: [
            BrailleLetterItem(name: "시옷", letter: "ㅅ", dotLabel: "6점"),
            BrailleLetterItem(name: "지읒", letter: "ㅈ", dotLabel: "4·6점"),
            BrailleLetterItem(name: "치읓", letter: "ㅊ", dotLabel: "5·6점"),
        ]
    ),
]
