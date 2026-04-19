import SwiftUI

/// 12일차 시작하기 화면
struct Day12IntroView: View {
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
                Text("12일차")
                    .font(.title3.weight(.medium))
                    .foregroundColor(.appTextSubColor)

                Text("'ㅏ' 생략 약자의\n예외 규칙")
                    .font(.largeTitle.bold())
                    .multilineTextAlignment(.center)
                    .foregroundColor(.appTextColor)

                Text("오늘의 목표")
                    .font(.headline)
                    .foregroundColor(.appTextSubColor)
                    .padding(.top, 12)

                Text("무조건 'ㅏ'를 살려 적어야 하는\n'라, 차'를 기억하고, 약자 바로 뒤에\n모음이 이어질 때 반드시 'ㅏ'를\n써야 하는 예외 규칙을\n완벽히 마스터합니다.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.appTextSubColor)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 20)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("12일차, ㅏ 생략 약자의 함정 피하기, 예외 규칙. 오늘의 목표: 무조건 ㅏ를 살려 적어야 하는 라, 차를 기억하고, 약자 바로 뒤에 모음이 이어질 때 반드시 ㅏ를 부활시켜야 하는 예외 규칙을 완벽히 마스터합니다.".toAccessibilityPronunciation())
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
    Day12IntroView(onStart: {}, onBack: {})
        .background(Color(.systemGroupedBackground))
}
