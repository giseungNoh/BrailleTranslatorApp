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

    private var dynamicTypeSize: DynamicTypeSize {
        switch appFontSize {
        case -1: return .small
        case 0: return .large
        case 1: return .xLarge
        case 2: return .xxLarge
        default: return .large
        }
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            CirriculumView()
                .tag(0)
                .tabItem { Label("학습", systemImage: "dot.square") }
                .accessibilityLabel("학습 탭, 커리큘럼")

            TranslatorView()
                .tag(1)
                .tabItem { Label("점자번역", systemImage: "pencil") }
                .accessibilityLabel("점자번역 탭")

            QuizView()
                .tag(2)
                .tabItem { Label("퀴즈", systemImage: "questionmark") }
                .accessibilityLabel("퀴즈 탭")

            SettingView()
                .tag(3)
                .tabItem { Label("설정", systemImage: "gearshape") }
                .accessibilityLabel("설정 탭")
        }
        .dynamicTypeSize(dynamicTypeSize)
    }
}

#Preview {
    RootTabView()
}
