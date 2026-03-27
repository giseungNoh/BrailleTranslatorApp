import SwiftUI

/// 6일차 시작하기 화면
struct Day6IntroView: View {
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
                Text("6일차")
                    .font(.title3.weight(.medium))
                    .foregroundColor(.appTextSubColor)

                Text("홑받침소리 글자\n\"밀고 내리기\" 원리")
                    .font(.largeTitle.bold())
                    .multilineTextAlignment(.center)
                    .foregroundColor(.appTextColor)

                Text("오늘의 목표")
                    .font(.headline)
                    .foregroundColor(.appTextSubColor)
                    .padding(.top, 12)

                Text("첫소리의 점자 모양을 유지한 채,\n점을 옆으로 밀 수 있으면 밀어서 만들고,\n밀 수 없다면 아래로 내려서\n홑받침을 만드는 조형 원리를\n완벽히 이해합니다.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.appTextSubColor)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 20)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("6일차, 홑받침소리 글자 밀고 내리기 원리. 오늘의 목표: 첫소리의 점자 모양을 유지한 채, 점을 옆으로 밀 수 있으면 밀어서 만들고, 밀 수 없다면 아래로 내려서 홑받침을 만드는 조형 원리를 완벽히 이해합니다.")
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
    Day6IntroView(onStart: {}, onBack: {})
        .background(Color(.systemGroupedBackground))
}
