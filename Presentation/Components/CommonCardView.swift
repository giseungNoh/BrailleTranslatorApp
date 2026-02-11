//
//  CommonCardView.swift
//  BrailleTranslatorApp
//
//  Created by AI on 2/10/26.
//

import SwiftUI

struct CommonCardView<Content: View>: View {
    let cornerRadius: CGFloat
    let padding: CGFloat
    let content: Content

    init(
        cornerRadius: CGFloat = 16,
        padding: CGFloat = 16,
        @ViewBuilder content: () -> Content
    ) {
        self.cornerRadius = cornerRadius
        self.padding = padding
        self.content = content()
    }

    var body: some View {
        content
            .padding(padding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .appCard(cornerRadius: cornerRadius)
        
    }
}

#Preview {
    ZStack {
        Color.appBackground.ignoresSafeArea()

        VStack(spacing: 16) {
            CommonCardView {
                VStack(alignment: .leading, spacing: 8) {
                    Text("점자 기초")
                        .font(.headline)
                        //.foregroundColor(.appTextPrimary)

                    Text("기초 점자를 학습해 보세요.")
                        .font(.subheadline)
                        //.foregroundColor(.appTextSecondary)
                }
            }

            CommonCardView(cornerRadius: 20) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("오늘의 퀴즈")
                            .font(.headline)
                            //.foregroundColor(.appTextPrimary)

                        Text("3개의 문제를 준비했어요.")
                            .font(.footnote)
                            //.foregroundColor(.appTextSecondary)
                    }

                    Spacer()

                    Image(systemName: "chevron.right")
                        //.foregroundColor(.appSecondary)
                }
            }
        }
        .padding()
    }
}

