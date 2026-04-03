import SwiftUI

/// 18일차 시작하기 화면
struct Day18IntroView: View {
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
                Text("18일차")
                    .font(.title3.weight(.medium))
                    .foregroundColor(.appTextSubColor)

                Text("필수 문장 부호 익히기\n마침표부터 괄호까지")
                    .font(.largeTitle.bold())
                    .multilineTextAlignment(.center)
                    .foregroundColor(.appTextColor)

                Text("오늘의 목표")
                    .font(.headline)
                    .foregroundColor(.appTextSubColor)
                    .padding(.top, 12)

                Text("글의 의미를 명확하게 해주는\n기본 문장 부호와 쌍으로 이루어진\n묶음 부호의 재미있는 대칭 점형을\n손끝으로 익힙니다.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.appTextSubColor)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 20)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("18일차, 필수 문장 부호 익히기 마침표부터 괄호까지. 오늘의 목표: 글의 의미를 명확하게 해주는 기본 문장 부호와 쌍으로 이루어진 묶음 부호의 재미있는 대칭 점형을 손끝으로 익힙니다.")
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
    Day18IntroView(onStart: {}, onBack: {})
        .background(Color(.systemGroupedBackground))
}
