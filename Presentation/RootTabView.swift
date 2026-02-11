//
//  RootTabView.swift
//  BrailleTranslatorApp
//
//  Created by juks86 on 2/6/26.
//

import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            CirriculumView()
                .tabItem { Label("학습", systemImage: "dot.square") }	

            TranslatorView()
                .tabItem { Label("점자번역", systemImage: "pencil") }

            QuizView()
                .tabItem { Label("퀴즈", systemImage: "questionmark") }

            SettingView()
                .tabItem { Label("설정", systemImage: "gearshape") }
        }
    }
}

#Preview {
    RootTabView()
}
