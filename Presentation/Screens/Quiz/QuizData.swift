import Foundation

// MARK: - 퀴즈 카테고리 정의

let quizCategories: [QuizCategory] = [
    // MARK: 섹션 1: 자음과 모음
    QuizCategory(
        id: "consonant_basic",
        title: "기본 자음",
        subtitle: "ㄱ·ㄴ·ㄷ·ㄹ·ㅁ·ㅂ·ㅅ·ㅈ·ㅊ",
        section: 1,
        questionPool: { day2ConsonantGroups.flatMap { $0.items } }
    ),
    QuizCategory(
        id: "consonant_extra",
        title: "거센소리·된소리",
        subtitle: "ㅋ·ㅌ·ㅍ·ㅎ·ㄲ·ㄸ·ㅃ·ㅆ·ㅉ",
        section: 1,
        questionPool: { day3ConsonantGroup.items + day3DoubleConsonantItems }
    ),
    QuizCategory(
        id: "vowel_basic",
        title: "기본 모음",
        subtitle: "ㅏ·ㅑ·ㅓ·ㅕ·ㅗ·ㅜ·ㅛ·ㅠ·ㅡ·ㅣ",
        section: 1,
        questionPool: { day4VowelGroups.flatMap { $0.items } }
    ),
    QuizCategory(
        id: "vowel_double",
        title: "이중 모음",
        subtitle: "ㅐ·ㅔ·ㅖ·ㅘ·ㅚ·ㅝ·ㅢ",
        section: 1,
        questionPool: { day5SingleCellVowelItems }
    ),
    QuizCategory(
        id: "jongseong_push",
        title: "밀기 받침",
        subtitle: "ㄱ·ㄹ·ㅂ·ㅅ·ㅈ·ㅊ",
        section: 1,
        questionPool: { day6PushItems }
    ),
    QuizCategory(
        id: "jongseong_drop",
        title: "내리기 받침",
        subtitle: "ㄴ·ㄷ·ㅁ·ㅋ·ㅌ·ㅍ·ㅎ",
        section: 1,
        questionPool: { day6DropItems }
    ),
    QuizCategory(
        id: "jongseong_compound",
        title: "겹받침",
        subtitle: "ㄳ·ㄵ·ㄶ·ㄺ·ㄻ·ㄼ·ㄽ·ㄾ·ㄿ·ㅀ·ㅄ",
        section: 1,
        questionPool: { day7CompoundItems1 + day7CompoundItems2 }
    ),

    // MARK: 섹션 2: 약자와 약어
    QuizCategory(
        id: "abbr_a_omit",
        title: "ㅏ 생략 약자",
        subtitle: "나·다·마·바·자·하",
        section: 2,
        questionPool: { day11AomitItems }
    ),
    QuizCategory(
        id: "abbreviations",
        title: "묶음 약자",
        subtitle: "억·언·얼·연·열·영·옥·온·옹 외",
        section: 2,
        questionPool: {
            day13EoSeriesItems + day13YeoSeriesItems
            + day14AbbrOhItems + day14AbbrUEuInItems
            + day14SpecialAbbrItems
        }
    ),
    QuizCategory(
        id: "abbr_conjunction",
        title: "접속사 약어",
        subtitle: "그래서·그러나·그러면·그러므로 외",
        section: 2,
        questionPool: { day15AbbrIntroItems }
    ),

    // MARK: 섹션 3: 숫자와 연산 기호
    QuizCategory(
        id: "numbers",
        title: "숫자와 연산 기호",
        subtitle: "0~9·더하기·빼기·등호",
        section: 3,
        questionPool: { day8NumberItems2 + day8NumberItems3 + day19MathItems }
    ),

    // MARK: 섹션 4: 영어 알파벳
    QuizCategory(
        id: "alpha_aj",
        title: "영어 a~j",
        subtitle: "a·b·c·d·e·f·g·h·i·j",
        section: 4,
        questionPool: { day16AlphaAEItems + day16AlphaFJItems }
    ),
    QuizCategory(
        id: "alpha_kz",
        title: "영어 k~z",
        subtitle: "k·l·m·n·o·p·q·r·s·t·u·v·w·x·y·z",
        section: 4,
        questionPool: { day17KTItems + day17UZItems }
    ),

    // MARK: 섹션 5: 문장 부호
    QuizCategory(
        id: "punctuation",
        title: "문장 부호",
        subtitle: "마침표·물음표·느낌표·쉼표·따옴표·괄호",
        section: 5,
        questionPool: { day18BasicPuncItems + day18PairPuncItems }
    ),
]

// MARK: - 섹션 이름

let quizSectionNames: [Int: String] = [
    1: "자음과 모음",
    2: "약자와 약어",
    3: "숫자와 연산 기호",
    4: "영어 알파벳",
    5: "문장 부호",
]

// MARK: - O/X 규칙 문장 (카테고리별)

struct OXRule: Sendable {
    let statement: String
    let isTrue: Bool
    let explanation: String
}

let quizOXRules: [String: [OXRule]] = [
    "consonant_basic": [
        OXRule(statement: "한글 점자의 자음은 1·2·4·5점 영역만 사용한다", isTrue: true,
               explanation: "자음은 윗칸(1·2점)과 가운뎃칸(4·5점)만 사용하고, 아랫칸(3·6점)은 모음 영역입니다."),
        OXRule(statement: "점자에서 초성과 받침의 점형은 동일하다", isTrue: false,
               explanation: "초성과 받침은 점형이 다릅니다. 받침은 초성을 밀거나 내려서 만듭니다."),
    ],
    "consonant_extra": [
        OXRule(statement: "된소리는 해당 자음 앞에 된소리표(6점)를 붙인다", isTrue: true,
               explanation: "된소리(ㄲ·ㄸ·ㅃ·ㅆ·ㅉ)는 6점을 자음 앞에 붙여 표현합니다."),
        OXRule(statement: "거센소리(ㅋ·ㅌ·ㅍ·ㅎ)도 된소리표를 사용한다", isTrue: false,
               explanation: "거센소리는 된소리표 없이 각각 고유한 점형을 가집니다."),
    ],
    "vowel_basic": [
        OXRule(statement: "모음은 2·3·5·6점 영역을 사용한다", isTrue: true,
               explanation: "모음은 가운뎃칸(2·5점)과 아랫칸(3·6점)을 사용합니다."),
        OXRule(statement: "ㅗ와 ㅜ는 같은 점형이다", isTrue: false,
               explanation: "ㅗ는 상하 대칭, ㅜ는 좌우 대칭으로 서로 다른 점형입니다."),
    ],
    "vowel_double": [
        OXRule(statement: "ㅘ, ㅝ 등 이중 모음도 한 칸으로 표현할 수 있다", isTrue: true,
               explanation: "ㅘ·ㅝ 등 일부 이중 모음은 한 칸 점형으로 표현됩니다."),
        OXRule(statement: "이중 모음은 항상 두 칸을 차지한다", isTrue: false,
               explanation: "ㅐ·ㅔ·ㅖ·ㅘ·ㅚ·ㅝ·ㅢ는 한 칸으로 표현할 수 있습니다."),
    ],
    "jongseong_push": [
        OXRule(statement: "밀기 받침은 초성 점형을 오른쪽으로 한 칸 민 것이다", isTrue: true,
               explanation: "밀기 받침은 초성의 왼쪽 점들을 오른쪽으로 이동시켜 만듭니다."),
        OXRule(statement: "모든 받침은 밀기 방식으로 만든다", isTrue: false,
               explanation: "받침에는 밀기 방식과 내리기 방식 두 가지가 있습니다."),
    ],
    "jongseong_drop": [
        OXRule(statement: "내리기 받침은 초성 점형을 아래로 내린 것이다", isTrue: true,
               explanation: "내리기 받침은 초성의 윗칸 점들을 아랫칸으로 이동시킵니다."),
        OXRule(statement: "밀기 받침과 내리기 받침의 구분 기준은 획수이다", isTrue: false,
               explanation: "구분 기준은 획수가 아니라, 자음의 점형 구조에 따라 정해집니다."),
    ],
    "jongseong_compound": [
        OXRule(statement: "겹받침은 두 개의 홑받침을 연달아 쓴다", isTrue: true,
               explanation: "겹받침은 두 홑받침을 순서대로 나란히 씁니다 (예: ㄳ = ㄱ받침 + ㅅ받침)."),
        OXRule(statement: "겹받침 ㄳ은 한 칸으로 표현한다", isTrue: false,
               explanation: "겹받침은 두 칸을 차지합니다. 각 홑받침이 한 칸씩입니다."),
    ],
    "abbr_a_omit": [
        OXRule(statement: "ㅏ 생략 약자는 자음만 써서 '가, 나, 다' 등을 표현한다", isTrue: true,
               explanation: "ㅏ를 생략하고 자음만 써서 '가·나·다·마·바·자·하' 등을 표현합니다."),
        OXRule(statement: "ㄹ과 ㅊ도 ㅏ 생략 약자로 쓸 수 있다", isTrue: false,
               explanation: "ㄹ과 ㅊ은 받침으로 자주 쓰여 혼동이 생기므로 ㅏ 생략이 불가합니다."),
    ],
    "abbreviations": [
        OXRule(statement: "'영' 약자는 받침 위치에서 '엉'으로 읽힌다", isTrue: true,
               explanation: "'영' 약자가 받침 뒤에 오면 '엉'으로 바뀝니다 (예: 성, 정)."),
        OXRule(statement: "약자 '것'은 두 칸을 차지한다", isTrue: false,
               explanation: "'것' 약자는 한 칸(4·5·6점)으로 표현합니다."),
    ],
    "abbr_conjunction": [
        OXRule(statement: "접속사 약어는 모두 1점으로 시작한다", isTrue: true,
               explanation: "그래서·그러나·그러면 등 7개 접속사 약어는 모두 첫 칸이 1점입니다."),
        OXRule(statement: "접속사 약어는 문장 중간에서만 사용할 수 있다", isTrue: false,
               explanation: "접속사 약어는 문장 시작이나 중간 어디서든 사용할 수 있습니다."),
    ],
    "numbers": [
        OXRule(statement: "숫자 앞에는 수표(3·4·5·6점)를 붙인다", isTrue: true,
               explanation: "숫자임을 알리기 위해 맨 앞에 수표를 한 번 붙입니다."),
        OXRule(statement: "두 자리 이상 숫자에서는 각 숫자마다 수표를 붙인다", isTrue: false,
               explanation: "수표는 맨 앞에 한 번만 붙이고, 이후 숫자들은 수표 없이 이어 씁니다."),
    ],
    "alpha_aj": [
        OXRule(statement: "영어 a~j의 점형은 숫자 1~0과 동일하다", isTrue: true,
               explanation: "영어 a~j와 숫자 1~0은 같은 점형이며, 수표/로마자표로 구별합니다."),
        OXRule(statement: "영어를 쓸 때는 로마자표 없이 바로 알파벳을 쓴다", isTrue: false,
               explanation: "영어는 로마자표를 앞에 붙여야 한글과 구별할 수 있습니다."),
    ],
    "alpha_kz": [
        OXRule(statement: "영어 대문자는 대문자 기호표(6점)를 앞에 붙인다", isTrue: true,
               explanation: "대문자 한 글자는 6점을, 단어 전체는 6·6점을 앞에 붙입니다."),
        OXRule(statement: "영어 w는 다른 알파벳과 같은 규칙으로 만들어진다", isTrue: false,
               explanation: "w는 예외적인 점형을 가집니다. 프랑스어에 w가 없어 나중에 추가되었기 때문입니다."),
    ],
    "punctuation": [
        OXRule(statement: "점자 마침표(2·5·6점)와 받침 ㅌ은 점형이 다르다", isTrue: false,
               explanation: "마침표와 받침 ㅌ은 같은 점형(2·3·6점)입니다. 문맥으로 구별해야 합니다."),
        OXRule(statement: "묶음 부호(괄호, 따옴표)는 여는 기호와 닫는 기호가 서로 다르다", isTrue: true,
               explanation: "여는 부호와 닫는 부호는 좌우 대칭 형태의 서로 다른 점형을 사용합니다."),
    ],
]

// MARK: - 문제 생성

enum QuizGenerator {

    /// 카테고리의 전체 아이템으로 객관식 + O/X 문제 생성
    static func generateQuestions(for category: QuizCategory) -> [QuizQuestion] {
        let pool = category.questionPool()
        guard pool.count >= 3 else { return [] }

        // 1) 객관식 문제 생성
        var questions: [QuizQuestion] = pool.shuffled().map { correctItem in
            let distractors = pool
                .filter { $0.letter != correctItem.letter }
                .shuffled()
                .prefix(2)

            var choices = [correctItem] + Array(distractors)
            choices.shuffle()

            return QuizQuestion.multipleChoice(
                questionText: "'\(correctItem.name)'의 점자를 고르세요",
                correctItem: correctItem,
                choices: choices,
                categoryId: category.id
            )
        }

        // 2) O/X 규칙 문제 추가 (카테고리에 해당하는 규칙이 있으면)
        if let rules = quizOXRules[category.id] {
            let dummyItem = pool[0] // correctItem 용도 (O/X는 규칙 판별이므로 대표 아이템 사용)
            let oxQuestions = rules.map { rule in
                QuizQuestion.ox(
                    questionText: rule.statement,
                    correctItem: dummyItem,
                    displayedItem: dummyItem,
                    isCorrectPairing: rule.isTrue,
                    explanation: rule.explanation,
                    categoryId: category.id
                )
            }
            questions.append(contentsOf: oxQuestions)
        }

        // 3) 전체 셔플
        questions.shuffle()
        return questions
    }
}
