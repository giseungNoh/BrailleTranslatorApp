//
//  SettingView.swift
//  BrailleTranslatorApp
//
//  Created by juks86 on 2/6/26.
//

import SwiftUI

struct TranslatorView: View {
    var body: some View {
        VStack(spacing: 0) {
            CommonNavigationBar(title: "점자 번역")

            // 실제 화면 컨텐츠
            VStack {
                Spacer()
                Text("TranslatorView")
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemBackground))
        }
    }
}

#Preview {
    TranslatorView()
}
