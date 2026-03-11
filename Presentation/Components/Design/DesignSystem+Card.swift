//
//  DesignSystem+Card.swift
//  BrailleTranslatorApp
//
//  Created by AI on 2/10/26.
//

import SwiftUI

/// 앱 전역에서 사용하는 공통 카드 스타일
struct AppCardStyle: ViewModifier {
    let cornerRadius: CGFloat

    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(Color.appCardColor)
                    .shadow(
                        color: Color.black.opacity(0.12),
                        radius: 10,
                        x: 0,
                        y: 6
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(Color.appCardBorder, lineWidth: 1)
            )
    }
}

extension View {
    /// 공통 카드 테두리/배경/그림자를 한 번에 적용하는 modifier
    func appCard(cornerRadius: CGFloat = 16) -> some View {
        modifier(AppCardStyle(cornerRadius: cornerRadius))
    }
}

