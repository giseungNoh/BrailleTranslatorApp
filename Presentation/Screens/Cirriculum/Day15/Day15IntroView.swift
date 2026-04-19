import SwiftUI

/// 15일차 시작하기 화면
struct Day15IntroView: View {
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
                Text("15일차")
                    .font(.title3.weight(.medium))
                    .foregroundColor(.appTextSubColor)

                Text("접속사\n'약어' 7개")
                    .font(.largeTitle.bold())
                    .multilineTextAlignment(.center)
                    .foregroundColor(.appTextColor)

                Text("오늘의 목표")
                    .font(.headline)
                    .foregroundColor(.appTextSubColor)
                    .padding(.top, 12)

                Text("모두 1점으로 시작하는 7개의 약어\n(그래서, 그러나 등)를 익히고,\n약어 앞뒤에 다른 글자가 붙을 때의\n규칙을 완벽하게 마스터합니다.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.appTextSubColor)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 20)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("15일차, 마법의 접속사 약어 7개. 오늘의 목표: 모두 1점으로 시작하는 7개의 약어 그래서, 그러나 등을 익히고, 약어 앞뒤에 다른 글자가 붙을 때의 규칙을 완벽하게 마스터합니다.".toAccessibilityPronunciation())
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
    Day15IntroView(onStart: {}, onBack: {})
        .background(Color(.systemGroupedBackground))
}
