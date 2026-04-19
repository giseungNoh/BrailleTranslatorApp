import SwiftUI

/// 16일차 시작하기 화면
struct Day16IntroView: View {
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
                Text("16일차")
                    .font(.title3.weight(.medium))
                    .foregroundColor(.appTextSubColor)

                Text("영어 알파벳 1\na~j")
                    .font(.largeTitle.bold())
                    .multilineTextAlignment(.center)
                    .foregroundColor(.appTextColor)

                Text("오늘의 목표")
                    .font(.headline)
                    .foregroundColor(.appTextSubColor)
                    .padding(.top, 12)

                Text("영어 알파벳 a부터 j까지의 점형이\n숫자 0~9와 완벽하게 똑같다는\n놀라운 비밀을 이해하고,\n가장 쉽게 영어 점자에 입문합니다.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.appTextSubColor)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 20)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("16일차, 영어 알파벳 1 a부터 j. 오늘의 목표: 영어 알파벳 a부터 j까지의 점형이 숫자 0에서 9까지 완벽하게 똑같다는 놀라운 비밀을 이해하고, 가장 쉽게 영어 점자에 입문합니다.".toAccessibilityPronunciation())
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
    Day16IntroView(onStart: {}, onBack: {})
        .background(Color(.systemGroupedBackground))
}
