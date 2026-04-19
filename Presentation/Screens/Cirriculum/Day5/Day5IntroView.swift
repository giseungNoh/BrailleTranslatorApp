import SwiftUI

/// 5일차 시작하기 화면
struct Day5IntroView: View {
    let onStart: () -> Void
    let onBack: () -> Void

    @AccessibilityFocusState private var focusedElement: AccessibilityFocus?

    enum AccessibilityFocus {
        case intro
    }

    var body: some View {
        VStack(spacing: 0) {
            Spacer(minLength: 40)

            VStack(spacing: 20) {
                Text("5일차")
                    .font(.title3.weight(.medium))
                    .foregroundColor(.appTextSubColor)

                Text("이중 모음과 '붙임표'")
                    .font(.largeTitle.bold())
                    .multilineTextAlignment(.center)
                    .foregroundColor(.appTextColor)

                Text("오늘의 목표")
                    .font(.headline)
                    .foregroundColor(.appTextSubColor)
                    .padding(.top, 12)

                Text("한 칸과 두 칸으로 이루어진\n이중 모음의 원리를 익히고,\n점자의 충돌을 막아주는\n'딴이'와 '붙임표'의 핵심 규칙을\n완벽하게 이해합니다.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.appTextSubColor)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 20)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("5일차, 이중 모음과 붙임표. 오늘의 목표: 한 칸과 두 칸으로 이루어진 이중 모음의 원리를 익히고, 점자의 충돌을 막아주는 딴이와 붙임표의 핵심 규칙을 완벽하게 이해합니다.".toAccessibilityPronunciation())
            .accessibilityFocused($focusedElement, equals: .intro)

            Spacer(minLength: 40)

            LearningButtonSection(
                nextTitle: "시작하기",
                backTitle: "돌아가기",
                nextHint: "이중 탭하면 학습을 시작합니다",
                backHint: "커리큘럼 목록으로 돌아갑니다",
                onNext: onStart,
                onBack: onBack
            )
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                focusedElement = .intro
            }
        }
    }
}

#Preview {
    Day5IntroView(onStart: {}, onBack: {})
        .background(Color(.systemGroupedBackground))
}
