import SwiftUI

/// 8일차 시작하기 화면
struct Day8IntroView: View {
    let onStart: () -> Void
    let onBack: () -> Void
    @State private var showBackAlert = false

    @AccessibilityFocusState private var focusedElement: AccessibilityFocus?

    enum AccessibilityFocus {
        case intro
    }

    var body: some View {
        VStack(spacing: 0) {
            Spacer(minLength: 40)

            VStack(spacing: 20) {
                Text("8일차")
                    .font(.title3.weight(.medium))
                    .foregroundColor(.appTextSubColor)

                Text("숫자 익히기 1\n수표와 0~9")
                    .font(.largeTitle.bold())
                    .multilineTextAlignment(.center)
                    .foregroundColor(.appTextColor)

                Text("오늘의 목표")
                    .font(.headline)
                    .foregroundColor(.appTextSubColor)
                    .padding(.top, 12)

                Text("숫자의 시작을 알리는 마법의 기호\n'수표(3·4·5·6점)'의 개념을 이해하고,\n0부터 9까지 한 자리 숫자의\n점형 규칙을 손끝으로 익힙니다.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.appTextSubColor)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 20)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("8일차, 숫자 익히기 1, 수표와 0~9. 오늘의 목표: 숫자의 시작을 알리는 마법의 기호 수표(3·4·5·6점)의 개념을 이해하고, 0부터 9까지 한 자리 숫자의 점형 규칙을 손끝으로 익힙니다.".toAccessibilityPronunciation())
            .accessibilityFocused($focusedElement, equals: .intro)

            Spacer(minLength: 40)

            LearningButtonSection(
                nextTitle: "시작하기",
                backTitle: "돌아가기",
                nextHint: "이중 탭하면 학습을 시작합니다",
                backHint: "커리큘럼 목록으로 돌아갑니다",
                onNext: onStart,
                onBack: { showBackAlert = true }
            )
        }
        .alert("돌아가기", isPresented: $showBackAlert) {
            Button("돌아가기", role: .destructive) { onBack() }
            Button("취소", role: .cancel) { }
        } message: {
            Text("커리큘럼 탭으로 돌아가시겠습니까?")
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                focusedElement = .intro
            }
        }
    }
}

#Preview {
    Day8IntroView(onStart: {}, onBack: {})
        .background(Color(.systemGroupedBackground))
}
