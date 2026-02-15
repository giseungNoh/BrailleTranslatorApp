//
//  BrailleTranslatorAppApp.swift
//  BrailleTranslatorApp
//
//  Created by juks86 on 2/6/26.
//

import SwiftUI
import SwiftData

//
//  BrailleTranslatorAppApp.swift
//  BrailleTranslatorApp
//
//  Created by juks86 on 2/6/26.
//

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
            
            // 데이터 초기화 (Seeding)
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
    
    @MainActor
    private func checkAndSeedData() {
        let context = container.mainContext
        
        do {
            let count = try context.fetchCount(FetchDescriptor<LearningItem>())
            if count == 0 {
                seedLearningItems(context: context)
            }
        } catch {
            print("Failed to fetch LearningItem count: \(error)")
        }
    }
    
    @MainActor
    private func seedLearningItems(context: ModelContext) {
        let items: [(day: Int, title: String, subtitle: String)] = [
            (1, "점자의 첫걸음", "구조 익히기"),
            (2, "손끝 길 트기", "가로 선 따라가기"),
            (3, "서로 다른 점 찾기", "점형 구별"),
            (4, "온점과 빈칸 느끼기", "감각 익히기"),
            (5, "자음 1", "'ㄱ~ㄹ'"),
            (6, "자음 2", "'ㅁ~ㅇ'"),
            (7, "[1주차 복습]", "점자 보물찾기 퀴즈"),
            (8, "자음 3", "'ㅈ~ㅎ'"),
            (9, "된소리 표기법", "쌍자음"),
            (10, "모음 1", "'ㅏ~ㅕ'"),
            (11, "모음 2", "'ㅗ~ㅣ'"),
            (12, "내려앉은 소리", "받침 자음의 원리"),
            (13, "두 칸의 어울림", "복모음 익히기"),
            (14, "[2주차 복습]", "글자 완성하기 퍼즐"),
            (15, "수표와 숫자", "123"),
            (16, "마침표와 물음표", "문장 부호"),
            (17, "약자 1", "'가~하'"),
            (18, "약자 2", "'것, 억, 언...'"),
            (19, "문장을 이어주는 말", "접속사 약어"),
            (20, "[수료]", "띄어쓰기와 문장 완성하기")
        ]
        
        for item in items {
            let learningItem = LearningItem(day: item.day, title: item.title, subtitle: item.subtitle)
            context.insert(learningItem)
        }
        
        do {
            try context.save()
            print("Successfully seeded \(items.count) items.")
        } catch {
            print("Failed to save seeded items: \(error)")
        }
    }
}
