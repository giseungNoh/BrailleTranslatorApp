//
//  DesignSystem+Card.swift
//  BrailleTranslatorApp
//
//  Created by AI on 2/10/26.
//

import SwiftUI

/// 앱 전역에서 사용하는 공통 카드 스타일
/// 이중 그림자로 깊이감 + 얇은 테두리로 경계 구분
struct AppCardStyle: ViewModifier {
    let cornerRadius: CGFloat

    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(Color.appCardColor)
                    // 넓은 배경 그림자 (부드러운 깊이감)
                    .shadow(
                        color: Color.black.opacity(0.06),
                        radius: 16,
                        x: 0,
                        y: 8
                    )
                    // 가까운 그림자 (선명한 가장자리)
                    .shadow(
                        color: Color.black.opacity(0.04),
                        radius: 2,
                        x: 0,
                        y: 1
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(Color.appCardBorder, lineWidth: 0.5)
            )
    }
}

extension View {
    /// 공통 카드 테두리/배경/그림자를 한 번에 적용하는 modifier
    func appCard(cornerRadius: CGFloat = 16) -> some View {
        modifier(AppCardStyle(cornerRadius: cornerRadius))
    }
}

