import SwiftUI

/// 19일차 시작하기 화면
struct Day19IntroView: View {
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
                Text("19일차")
                    .font(.title3.weight(.medium))
                    .foregroundColor(.appTextSubColor)

                Text("연산 기호와\n실전 문장 읽기")
                    .font(.largeTitle.bold())
                    .multilineTextAlignment(.center)
                    .foregroundColor(.appTextColor)

                Text("오늘의 목표")
                    .font(.headline)
                    .foregroundColor(.appTextSubColor)
                    .padding(.top, 12)

                Text("연산 기호의 마법 같은 띄어쓰기\n규칙을 이해하고, 지금까지 배운\n모든 점자를 총동원하여 짧은 문장과\n속담을 직접 해독해 내는\n실전 감각을 기릅니다.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.appTextSubColor)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 20)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("19일차, 연산 기호와 실전 문장 읽기. 오늘의 목표: 연산 기호의 마법 같은 띄어쓰기 규칙을 이해하고, 지금까지 배운 모든 점자를 총동원하여 짧은 문장과 속담을 직접 해독해 내는 실전 감각을 기릅니다.")
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
    Day19IntroView(onStart: {}, onBack: {})
        .background(Color(.systemGroupedBackground))
}
