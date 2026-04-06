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
                ZStack {
                    // 1. 기본 유리 질감 (Material)
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(.ultraThinMaterial)
                    
                    // 2. 아쿠아 민트 색감 그라디언트 (meshColor4 사용)
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.white.opacity(0.9),        // 상단: 깨끗한 화이트
                                    Color.meshColor4.opacity(0.1)   // 하단: 선명한 아쿠아 민트
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    // 3. 상단 광택 효과
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.white.opacity(0.4),
                                    Color.white.opacity(0.0)
                                ]),
                                startPoint: .top,
                                endPoint: .center
                            )
                        )
                }
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
                // 사용자가 설정한 Shadow
                .shadow(
                    color: Color.meshColor4.opacity(0.2),
                    radius: 14,
                    x: 0,
                    y: 8
                )
            )
            .overlay(
                // 4. 매우 선명한 외곽선 (고대비 브라이트 민트 테두리)
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(
                        Color.white.opacity(0.8), // 가독성을 위해 아주 밝고 선명한 화이트/민트 경계선
                        lineWidth: 0.5
                    )
            )
            .overlay(
                // 5. 추가 하이라이트 (상단 왼쪽 엣지 강조)
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .trim(from: 0, to: 0.25) // 상단 왼쪽 정도만 강조
                    .stroke(Color.white, lineWidth: 0.7)
                    .blur(radius: 0.5)
            )
    }
}

#Preview {
    ZStack {
        // 배경을 함께 보여주어 유리 질감 확인 가능하게 함
        MeshBackground()
            .ignoresSafeArea()
        
        VStack(spacing: 20) {
            Text("카드 스타일 프리뷰")
                .font(.title2.bold())
                .foregroundColor(.appTextColor)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("유리 질감 카드 (기본)")
                    .font(.headline)
                Text("배경의 메시 그라디언트가 은은하게 비치는 스타일입니다.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding()
            .appCard(cornerRadius: 16)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("상태 표시")
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.orange.opacity(0.2))
                        .foregroundColor(.orange)
                        .cornerRadius(6)
                    
                    Text("커리큘럼 타이틀")
                        .font(.headline)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }
            .padding()
            .appCard(cornerRadius: 16)
        }
        .padding()
    }
}

extension View {
    /// 공통 카드 테두리/배경/그림자를 한 번에 적용하는 modifier
    func appCard(cornerRadius: CGFloat = 16) -> some View {
        modifier(AppCardStyle(cornerRadius: cornerRadius))
    }
}

