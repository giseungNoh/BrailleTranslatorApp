import SwiftUI

/// 9일차 시작하기 화면
struct Day9IntroView: View {
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
                Text("9일차")
                    .font(.title3.weight(.medium))
                    .foregroundColor(.appTextSubColor)

                Text("숫자 익히기 2\n두 자리 이상의 숫자")
                    .font(.largeTitle.bold())
                    .multilineTextAlignment(.center)
                    .foregroundColor(.appTextColor)

                Text("오늘의 목표")
                    .font(.headline)
                    .foregroundColor(.appTextSubColor)
                    .padding(.top, 12)

                Text("두 자리 이상의 숫자를 적는 원리를\n배우고, 수표의 효력이 언제 유지되고\n언제 끝나는지 점자만의 세밀한\n규칙을 완벽하게 이해합니다.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.appTextSubColor)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 20)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("9일차, 숫자 익히기 2, 두 자리 이상과 수표의 효력. 오늘의 목표: 두 자리 이상의 숫자를 적는 원리를 배우고, 수표의 효력이 언제 유지되고 언제 끝나는지 점자만의 세밀한 규칙을 완벽하게 이해합니다.")
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
    Day9IntroView(onStart: {}, onBack: {})
        .background(Color(.systemGroupedBackground))
}
