import SwiftUI

/// 13일차 시작하기 화면
struct Day13IntroView: View {
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
                Text("13일차")
                    .font(.title3.weight(.medium))
                    .foregroundColor(.appTextSubColor)

                Text("묶음 약자 1\n(억, 언, 얼, 연, 열, 영)")
                    .font(.largeTitle.bold())
                    .multilineTextAlignment(.center)
                    .foregroundColor(.appTextColor)

                Text("오늘의 목표")
                    .font(.headline)
                    .foregroundColor(.appTextSubColor)
                    .padding(.top, 12)

                Text("'ㅓ'와 'ㅕ' 계열의 모음과 받침이\n하나로 합쳐진 묶음 약자를 익히고,\n특정 자음 뒤에서 '영'이 '엉'으로\n소리가 바뀌는 점자만의 신기한\n마법 규칙을 이해합니다.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.appTextSubColor)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 20)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("13일차, 묶음 약자 1, 억, 언, 얼, 연, 열, 영. 오늘의 목표: ㅓ와 ㅕ 계열의 모음과 받침이 하나로 합쳐진 묶음 약자를 익히고, 특정 자음 뒤에서 영이 엉으로 소리가 바뀌는 점자만의 신기한 마법 규칙을 이해합니다.".toAccessibilityPronunciation())
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
    Day13IntroView(onStart: {}, onBack: {})
        .background(Color(.systemGroupedBackground))
}
