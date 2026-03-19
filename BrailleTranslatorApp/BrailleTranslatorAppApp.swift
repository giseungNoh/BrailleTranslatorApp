import SwiftUI
import SwiftData

@main
struct BrailleApp: App {
    let container: ModelContainer

    init() {
        do {
            let schema = Schema([
                LearningItem.self,
                SavedWord.self
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
    private static let curriculumVersion = 2

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
        (2,  "기본 자음 1 (ㄱ~ㅇ)",
             "초성 ㅇ은 소릿값 없어 생략하는 원리 이해"),
        (3,  "기본 자음 2 (ㅈ~ㅎ) 및 된소리",
             "된소리표(6점) 앞세워 ㄲ,ㄸ,ㅃ,ㅆ,ㅉ 표기"),
        (4,  "기본 모음 (대칭 구조의 이해)",
             "ㅏ~ㅣ 점형의 좌우·상하 대칭 원리"),
        (5,  "자모음 조합 및 1주차 복습",
             "받침 없는 기본 단어 읽어보기"),
        // 2주차: 받침, 복모음, 그리고 숫자
        (6,  "받침(종성) 자음의 원리",
             "초성과 모양은 같되 위치가 달라지는 원리"),
        (7,  "이중 모음(복모음) 익히기",
             "한 칸·두 칸 이중 모음 구별하기"),
        (8,  "숫자 익히기 (기본 원리)",
             "수표(3456점)와 1~0 숫자 나타내기"),
        (9,  "일상 속 숫자 점자 읽기",
             "엘리베이터·호실 번호 등 실생활 숫자 연습"),
        (10, "2주차 총정리",
             "자음+모음+받침 단어와 숫자 혼합 읽기"),
        // 3주차: 핵심 약자와 약어
        (11, "'ㅏ' 생략 약자",
             "가,나,다…하 적을 때 모음 ㅏ 생략 원리"),
        (12, "모음+받침 약자와 '것'",
             "억,언,얼,연,열,영 등 14개 약자 익히기"),
        (13, "7개 약어 및 기타 예외 규칙",
             "그래서,그러나,그러면 등 접속사 약어"),
        (14, "기본 문장 부호",
             "마침표(256점), 쉼표, 물음표 등"),
        (15, "3주차 실전 테스트",
             "약자·약어·부호 혼합 문장 읽기"),
        // 4주차: 영어 알파벳과 실생활
        (16, "영어 알파벳 기초 (A~J)",
             "a~j 점형이 숫자 1~0과 동일한 원리"),
        (17, "영어 알파벳 기초 2 (K~Z)",
             "나머지 알파벳과 대문자 기호표(6점)"),
        (18, "생활 속 융합 점자 읽기",
             "캔 음료·의약품·안내판 등 실생활 라벨"),
        (19, "짧은 문장 및 속담 읽기",
             "모든 규칙 종합 문장 유창하게 읽기"),
        (20, "최종 평가 및 점자 명함 만들기",
             "수료 테스트와 이름·전화번호 점자 쓰기"),
    ]
}
