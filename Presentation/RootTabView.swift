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
                if newTab == self.selectedTab && newTab == 2 {
                    NotificationCenter.default.post(name: Notification.Name("ResetQuizTab"), object: nil)
                }
                self.selectedTab = newTab
            }
        )
    }

    var body: some View {
        TabView(selection: tabSelectionBinding) {
            CirriculumView(selectedTab: selectedTab)
                .tag(0)
                .tabItem { Label("학습", systemImage: "dot.square") }

            TranslatorView(selectedTab: selectedTab)
                .tag(1)
                .tabItem { Label("점자변환", systemImage: "pencil") }

            QuizView(selectedTab: selectedTab)
                .tag(2)
                .tabItem { Label("퀴즈", systemImage: "questionmark") }

            SettingView(selectedTab: selectedTab)
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
