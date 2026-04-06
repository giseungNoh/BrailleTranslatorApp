import SwiftUI
import SwiftData

@main
struct BrailleApp: App {
    let container: ModelContainer

    init() {
        do {
            let schema = Schema([
                LearningItem.self,
                SavedWord.self,
                QuizAttempt.self
            ])
            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            container = try ModelContainer(for: schema, configurations: [modelConfiguration])

            checkAndSeedData()
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            RootTabView()
        }
        .modelContainer(container)
    }

    // 현재 커리큘럼 버전 (내용 변경 시 올리면 자동 업데이트)
    private static let curriculumVersion = 4

    @MainActor
    private func checkAndSeedData() {
        let context = container.mainContext

        do {
            let count = try context.fetchCount(FetchDescriptor<LearningItem>())
            if count == 0 {
                seedLearningItems(context: context)
            } else {
                // 기존 데이터가 있으면 내용 업데이트
                let savedVersion = UserDefaults.standard.integer(forKey: "curriculumVersion")
                if savedVersion < Self.curriculumVersion {
                    updateLearningItems(context: context)
                }
            }
        } catch {
            print("Failed to fetch LearningItem count: \(error)")
        }
    }

    @MainActor
    private func seedLearningItems(context: ModelContext) {
        for item in Self.curriculumData {
            let learningItem = LearningItem(day: item.day, title: item.title, subtitle: item.subtitle)
            context.insert(learningItem)
        }

        do {
            try context.save()
            UserDefaults.standard.set(Self.curriculumVersion, forKey: "curriculumVersion")
            print("Successfully seeded \(Self.curriculumData.count) items.")
        } catch {
            print("Failed to save seeded items: \(error)")
        }
    }

    @MainActor
    private func updateLearningItems(context: ModelContext) {
        do {
            let existing = try context.fetch(FetchDescriptor<LearningItem>())
            let existingByDay = Dictionary(uniqueKeysWithValues: existing.map { ($0.day, $0) })

            for data in Self.curriculumData {
                if let item = existingByDay[data.day] {
                    item.title = data.title
                    item.subtitle = data.subtitle
                } else {
                    let newItem = LearningItem(day: data.day, title: data.title, subtitle: data.subtitle)
                    context.insert(newItem)
                }
            }

            try context.save()
            UserDefaults.standard.set(Self.curriculumVersion, forKey: "curriculumVersion")
            print("Successfully updated curriculum to version \(Self.curriculumVersion).")
        } catch {
            print("Failed to update learning items: \(error)")
        }
    }

    // MARK: - 커리큘럼 데이터

    private static let curriculumData: [(day: Int, title: String, subtitle: String)] = [
        // 1주차: 점자의 기초와 기본 자모음
        (1,  "점자의 이해와 촉각 훈련",
             "6점 구조, 온표와 빈칸 구별, 가로선 따라가기"),
        (2,  "기본 자음 1 (점형의 규칙성과 'ㅇ'의 비밀)",
             "4점 중심: ㄱ, ㄴ, ㄷ / 5점 중심: ㄹ, ㅁ, ㅂ / 6점 중심: ㅅ, ㅈ, ㅊ"),
        (3,  "기본 자음 2 (나머지 자음과 된소리표)",
             "1-2-4-5점 중심: ㅋ, ㅌ, ㅍ, ㅎ,된소리표(6점) 앞세워 ㄲ,ㄸ,ㅃ,ㅆ,ㅉ 표기"),
        (4,  "기본 모음 (대칭 구조의 이해)",
             "ㅏ~ㅣ 점형의 좌우·상하 대칭 원리"),
        (5,  "이중 모음과'붙임표'",
             "이중 모음의 원리와 '딴이(1-2-3-5점)', 점자 충돌을 막는 '붙임표(3-6점)' 규칙"),
        // 2주차: 받침, 복모음, 그리고 숫자
        (6,  "홑받침소리 글자 (밀어라, 내려라 원리)",
             "첫소리 자음을 오른쪽으로 밀거나 한 칸 아래로 내려서 받침을 만드는 조형 원리 이해"),
        (7,  "겹받침소리 글자",
             "홑받침 두 개를 나란히 연달아 찍어 겹받침(ㄲ, ㄳ, ㄵ 등)을 만드는 원리"),
        (8,  "숫자 익히기 1 (수표와 1~0)",
             "숫자임을 알리는 수표(3-4-5-6점)의 개념 이해"),
        (9,  "숫자 익히기 2 (두 자리 이상과 수표의 효력)",
             "수표는 맨 앞에 한 번만 찍는다는 원리와, 띄어쓰기 등 수표의 효력이 끝나는 예외 조건 익히기"),
        (10, "2주차 총정리 (숫자와 한글 조합)",
             "자음+모음+받침 단어와 숫자 혼합 읽기"),
        // 3주차: 핵심 약자와 약어
        (11, "'ㅏ' 생략 약자",
             "고유 약자(가, 사, 까, 싸) 익히기"),
        (12, " 'ㅏ' 생략 약자의 예외 법칙",
             "무조건 'ㅏ'를 살려야 하는 '라, 차', 약자 뒤에 모음(ㅇ으로 시작하는 글자)이 올 때 혼동을 막기 위한 예외 규정"),
        (13, "모음+받침 약자 1 (억, 언, 얼, 연, 열, 영)",
             "'ㅓ, ㅕ' 계열의 묶음 약자 점형 익히기"),
        (14, "모음+받침 약자 2 및 특수 약자",
             "나머지 묶음 약자(옥, 온, 옹 / 운, 울 / 은, 을, 인)/것 익히기"),
        (15, "7개 약어 (접속사)",
             "모두 1점(⠁)으로 시작하는 7개 마법의 접속사(그래서, 그러나, 그러면, 그러므로, 그런데, 그리고, 그리하여) 익히기"),
        // 4주차: 영어 알파벳과 실생활
        (16, "영어 알파벳 기초 (A~J)",
             "a~j 점형이 숫자 1~0과 동일한 원리"),
        (17, "영어 알파벳 기초 2 (K~Z)",
             "나머지 알파벳과 대문자 기호표(6점)"),
        (18, "필수 문장 부호와 단위",
             "마침표, 쉼표, 물음표, 느낌표 등 글을 읽기 위한 기본 부호"),
        (19, "연산 기호와 실전 문장 읽기",
             "+, -, *, ÷ 등 간단한 연산 기호와 그 의미, 실생활 문장 구성"),
        (20, "실전 융합 점자 읽기 (생활 속 점자)",
             "여러가지 문장 조합으로 이루어진 실생활 점자 읽기"),
    ]
}
