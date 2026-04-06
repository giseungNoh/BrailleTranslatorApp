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
    
    /// 배경 그라디언트 (따뜻한 오렌지 테마)
    /// 여기서 색상을 변경하여 앱 전체의 분위기를 쉽게 바꿀 수 있습니다.
    /// 메시 그라디언트 컬러 (Light Gradient 05 컨셉)
    /// 여기서 색상을 변경하여 앱 전체의 분위기를 쉽게 바꿀 수 있습니다.
    static let meshColor1 = Color(hex: "DEFFFD") // Light Cyan
    static let meshColor2 = Color(hex: "00FF75") // Spring Green
    static let meshColor3 = Color(hex: "B9FF91") // Light Green
    static let meshColor4 = Color(hex: "00FFFF") // Cyan
}

// MARK: - Hex 컬러 지원
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
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
