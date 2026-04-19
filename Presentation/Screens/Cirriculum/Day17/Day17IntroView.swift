import SwiftUI

/// 17일차 시작하기 화면
struct Day17IntroView: View {
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
                Text("17일차")
                    .font(.title3.weight(.medium))
                    .foregroundColor(.appTextSubColor)

                Text("알파벳 점 추가 원리\n(k~z)와 대문자 기호")
                    .font(.largeTitle.bold())
                    .multilineTextAlignment(.center)
                    .foregroundColor(.appTextColor)

                Text("오늘의 목표")
                    .font(.headline)
                    .foregroundColor(.appTextSubColor)
                    .padding(.top, 12)

                Text("어제 배운 a~j 점형에 특정 점을\n추가하여 나머지 알파벳을 만드는\n원리를 두 단계로 나누어 깨우치고,\n대문자를 표기하는 3가지 마법의 기호를\n완벽히 마스터합니다.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.appTextSubColor)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 20)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("17일차, 알파벳 점 추가 원리 k부터 z와 대문자 기호. 오늘의 목표: 어제 배운 a부터 j 점형에 특정 점을 추가하여 나머지 알파벳을 만드는 원리를 두 단계로 나누어 깨우치고, 대문자를 표기하는 3가지 마법의 기호 6점, 6 6점, 6 6 6점을 완벽히 마스터합니다.".toAccessibilityPronunciation())
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
    Day17IntroView(onStart: {}, onBack: {})
        .background(Color(.systemGroupedBackground))
}
