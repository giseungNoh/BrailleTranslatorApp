import SwiftUI

/// ① 시작하기 화면 (Intro: 학습 목표)
struct Day3IntroView: View {
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
                Text("3일차")
                    .font(.title3.weight(.medium))
                    .foregroundColor(.appTextSubColor)

                Text("기본 자음 ②")
                    .font(.largeTitle.bold())
                    .multilineTextAlignment(.center)
                    .foregroundColor(.appTextColor)

                Text("오늘의 목표")
                    .font(.headline)
                    .foregroundColor(.appTextSubColor)
                    .padding(.top, 12)

                Text("1, 2, 4, 5점을 중심으로 만들어지는\n나머지 첫소리 글자(ㅋ, ㅌ, ㅍ, ㅎ)를 익히고,\n글자를 강하게 만드는 '된소리표(6점)'의\n원리를 이해합니다.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.appTextSubColor)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 20)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("3일차, 기본 자음 2. 오늘의 목표: 1, 2, 4, 5점을 중심으로 만들어지는 나머지 첫소리 글자 키읔, 티읕, 피읖, 히읗을 익히고, 글자를 강하게 만드는 된소리표 6점의 원리를 이해합니다.")
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
    Day3IntroView(onStart: {}, onBack: {})
        .background(Color(.systemGroupedBackground))
}
