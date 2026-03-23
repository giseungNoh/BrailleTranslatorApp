//
//  DesignSystem+Color.swift
//  BrailleTranslatorApp
//
//  Created by AI on 2/10/26.
//

import SwiftUI

extension Color {
    /// 앱 메인 브랜드 컬러 (버튼, 포커스 등)
    static let appMainColor = Color(.systemBackground)

    /// 서브/보조 컬러
    static let appSubColor = Color(.appSecondary)

    /// 기본 배경 컬러
    static let appBackgroundColor = Color("AppBackground")

    /// 카드/콘텐츠 영역 배경
    static let appCardColor = Color(.white)

    /// 카드 테두리 컬러 (공통 카드 스타일에서 사용)
    static let appCardBorder = Color.black.opacity(0.1)

    /// 기본 텍스트 컬러
    static let appTextColor = Color(.label)

    /// 서브 텍스트 컬러
    static let appTextSubColor = Color(.label).opacity(0.7)
}

#Preview {
    ScrollView {
        VStack(spacing: 12) {
            Group {
                Color.appMainColor
                Color.appSubColor
                Color.appBackgroundColor
                Color.appCardColor
                Color.appTextColor
                Color.appTextSubColor
            }
            .frame(height: 60)
            .cornerRadius(8)
        }
        .padding()
    }
}
