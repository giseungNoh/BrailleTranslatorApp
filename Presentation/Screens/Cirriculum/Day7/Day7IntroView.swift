import SwiftUI

/// 7일차 시작하기 화면
struct Day7IntroView: View {
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
                Text("7일차")
                    .font(.title3.weight(.medium))
                    .foregroundColor(.appTextSubColor)

                Text("겹받침소리 글자\n나란히 이어 적기")
                    .font(.largeTitle.bold())
                    .multilineTextAlignment(.center)
                    .foregroundColor(.appTextColor)

                Text("오늘의 목표")
                    .font(.headline)
                    .foregroundColor(.appTextSubColor)
                    .padding(.top, 12)

                Text("두 개의 홑받침을 차례대로\n나란히 적어 겹받침을 만드는 원리를\n이해하고, 쌍받침의 특별한\n예외 규칙을 완벽히 익힙니다.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.appTextSubColor)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 20)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("7일차, 겹받침소리 글자, 나란히 이어 적기. 오늘의 목표: 두 개의 홑받침을 차례대로 나란히 적어 겹받침을 만드는 원리를 이해하고, 쌍받침의 특별한 예외 규칙을 완벽히 익힙니다.".toAccessibilityPronunciation())
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
    Day7IntroView(onStart: {}, onBack: {})
        .background(Color(.systemGroupedBackground))
}
