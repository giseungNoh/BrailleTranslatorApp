import SwiftUI

/// 칠판 스타일의 공통 설명 카드 컴포넌트
/// 시각장애인 접근성을 고려하여 고대비 그린 배경(다크모드 느낌)과 다이나믹 폰트를 적용함
struct ExplanationChalkboardCard: View {
    let description: String
    var isCompact: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            let sections = description.components(separatedBy: "\n\n")

            ForEach(0..<sections.count, id: \.self) { index in
                if index > 0 {
                    Divider()
                        .background(Color.white.opacity(0.3))
                        .padding(.horizontal, 10)
                }

                HStack(alignment: .top, spacing: 14) {
                    // 첫 번째 섹션은 강조 아이콘, 나머지는 일반 정보 아이콘
                    Image(systemName: index == 0 ? "exclamationmark.circle.fill" : "lightbulb.fill")
                        .font(isCompact ? .body : .title3)
                        .foregroundColor(.white.opacity(0.9))
                        .padding(.top, 2)
                        .accessibilityHidden(true)

                    highlightedText(sections[index].trimmingCharacters(in: .whitespacesAndNewlines))
                        .font(isCompact ? .callout : .body) // 다이나믹 폰트
                        .fontWeight(.bold) // 고대비 확보
                        .lineSpacing(isCompact ? 4 : 6)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.vertical, isCompact ? 12 : 16)
                .padding(.horizontal, 16)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(
                    sections[index]
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                        .replacingOccurrences(of: "\n", with: " ")
                        .toAccessibilityPronunciation()
                )
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(.green) // Chalkboard Green
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color.white.opacity(0.6), lineWidth: 1.5)
        )
    }

    /// 작은따옴표(')로 감싸진 텍스트를 강조(노란색)하여 반환
    private func highlightedText(_ text: String) -> Text {
        let parts = text.components(separatedBy: "'")
        var result = Text("")

        for (index, part) in parts.enumerated() {
            if index % 2 == 1 {
                // 강조 텍스트 (작은따옴표 포함)
                result = result + Text("'\(part)'").foregroundColor(Color(hex: "FFF59D"))
            } else {
                // 일반 텍스트
                result = result + Text(part).foregroundColor(.white)
            }
        }
        return result
    }
}
