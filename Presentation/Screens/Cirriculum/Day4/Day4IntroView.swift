import SwiftUI

/// ① 시작하기 화면 (Intro: 학습 목표)
struct Day4IntroView: View {
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
                Text("4일차")
                    .font(.title3.weight(.medium))
                    .foregroundColor(.appTextSubColor)

                Text("기본 모음")
                    .font(.largeTitle.bold())
                    .multilineTextAlignment(.center)
                    .foregroundColor(.appTextColor)

                Text("오늘의 목표")
                    .font(.headline)
                    .foregroundColor(.appTextSubColor)
                    .padding(.top, 12)

                Text("기본 모음 10개(ㅏ~ㅣ)의 점형을 익히고,\n거울처럼 서로 마주 보거나\n위아래가 뒤집히는 대칭의 조형 원리를\n직관적으로 이해합니다.\n\n기본 모음의 점형은\n모두 세 점으로 이루어져 있습니다.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.appTextSubColor)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 20)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("4일차, 기본 모음, 모음의 대칭 구조 이해. 오늘의 목표: 기본 모음 10개의 점형을 익히고, 거울처럼 서로 마주 보거나 위아래가 뒤집히는 대칭의 조형 원리를 직관적으로 이해합니다. 참고: 기본 모음의 점형은 모두 세 점으로 이루어져 있습니다.")
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
    Day4IntroView(onStart: {}, onBack: {})
        .background(Color(.systemGroupedBackground))
}
