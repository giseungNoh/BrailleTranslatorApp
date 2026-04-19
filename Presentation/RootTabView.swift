//
//  RootTabView.swift
//  BrailleTranslatorApp
//
//  Created by juks86 on 2/6/26.
//

import SwiftUI

struct RootTabView: View {
    @AppStorage("appFontSize") private var appFontSize: Int = 0
    @State private var selectedTab: Int = 0

    private var dynamicTypeSize: DynamicTypeSize? {
        switch appFontSize {
        case -1: return .small
        case 1: return .xLarge
        case 2: return .xxLarge
        default: return nil
        }
    }

    var tabSelectionBinding: Binding<Int> {
        Binding(
            get: { self.selectedTab },
            set: { newTab in
                print("🔵 [RootTabView] binding.set called: oldTab=\(self.selectedTab), newTab=\(newTab)")
                if newTab == self.selectedTab && newTab == 2 {
                    print("🔵 [RootTabView] posting ResetQuizTab")
                    NotificationCenter.default.post(name: Notification.Name("ResetQuizTab"), object: nil)
                }
                let isActualSwitch = newTab != self.selectedTab
                self.selectedTab = newTab
                if isActualSwitch {
                    print("🔵 [RootTabView] posting TabSwitched(object: \(newTab))")
                    NotificationCenter.default.post(
                        name: Notification.Name("TabSwitched"),
                        object: newTab
                    )
                }
            }
        )
    }

    var body: some View {
        TabView(selection: tabSelectionBinding) {
            CirriculumView()
                .tag(0)
                .tabItem { Label("학습", systemImage: "dot.square") }

            TranslatorView()
                .tag(1)
                .tabItem { Label("점자번역", systemImage: "pencil") }

            QuizView()
                .tag(2)
                .tabItem { Label("퀴즈", systemImage: "questionmark") }

            SettingView()
                .tag(3)
                .tabItem { Label("설정", systemImage: "gearshape") }
        }
        .modifier(DynamicTypeModifier(size: dynamicTypeSize))
    }
}

struct DynamicTypeModifier: ViewModifier {
    let size: DynamicTypeSize?
    
    func body(content: Content) -> some View {
        if let size = size {
            content.dynamicTypeSize(size)
        } else {
            content // 기본값이면 시스템 설정(iOS 사용 설정)을 무시하지 않고 그대로 따릅니다.
        }
    }
}

#Preview {
    RootTabView()
}
