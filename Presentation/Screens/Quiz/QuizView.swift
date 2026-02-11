//
//  QuizView.swift
//  BrailleTranslatorApp
//
//  Created by juks86 on 2/6/26.
//

import SwiftUI

struct QuizView: View {
    var body: some View {
        VStack(spacing: 0) {
            CommonNavigationBar(title: "퀴즈")

            VStack {
                Spacer()
                Text("QuizView")
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemBackground))
        }
    }
}

#Preview {
    QuizView()
}
