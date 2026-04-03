import SwiftUI

/// 20일차 시작하기 화면
struct Day20IntroView: View {
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
                Text("20일차")
                    .font(.title3.weight(.medium))
                    .foregroundColor(.appTextSubColor)

                Text("생활 속 점자 탐험과\n실전 해독")
                    .font(.largeTitle.bold())
                    .multilineTextAlignment(.center)
                    .foregroundColor(.appTextColor)

                Text("오늘의 목표")
                    .font(.headline)
                    .foregroundColor(.appTextSubColor)
                    .padding(.top, 12)

                Text("의약품, 가전제품 등 우리 주변의\n점자들을 읽어내며 자립 생활의\n기초를 다지고, 실생활 점자를 읽을 때\n흔히 실수하기 쉬운 점형의 함정들을\n파악하여 실전 점자 읽기 능력을\n완성합니다.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.appTextSubColor)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 20)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("20일차, 생활 속 점자 탐험과 실전 해독. 오늘의 목표: 의약품, 가전제품 등 우리 주변의 점자들을 읽어내며 자립 생활의 기초를 다지고, 실생활 점자를 읽을 때 흔히 실수하기 쉬운 점형의 함정들을 파악하여 실전 점자 읽기 능력을 완성합니다.")
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
    Day20IntroView(onStart: {}, onBack: {})
        .background(Color(.systemGroupedBackground))
}
