//
//  PracticeView.swift
//  BrailleTranslatorApp
//
//  Created by AI on 2/10/26.
//

import SwiftUI

struct PracticeView: View {
    let day: Int

    var body: some View {
        VStack(spacing: 0) {
            CommonNavigationBar(title: "연습 \(day)일차")

            VStack(alignment: .leading, spacing: 16) {
                Text("\(day)일차 연습 화면")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.appTextColor)

                Text("여기에 \(day)일차에 대한 연습 콘텐츠를 추가할 수 있습니다.")
                    .font(.body)
                    .foregroundColor(.appTextSubColor)

                Spacer()
            }
            .padding(20)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .background(Color.appMainColor)
        }
    }
}

#Preview {
    PracticeView(day: 1)
}

