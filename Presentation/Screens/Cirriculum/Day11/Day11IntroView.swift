import SwiftUI

/// 11일차 시작하기 화면
struct Day11IntroView: View {
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
                Text("11일차")
                    .font(.title3.weight(.medium))
                    .foregroundColor(.appTextSubColor)

                Text("'약자' 1\n고유 약자와 'ㅏ' 생략")
                    .font(.largeTitle.bold())
                    .multilineTextAlignment(.center)
                    .foregroundColor(.appTextColor)

                Text("오늘의 목표")
                    .font(.headline)
                    .foregroundColor(.appTextSubColor)
                    .padding(.top, 12)

                Text("글자의 부피를 확 줄여주는 점자만의\n고유한 약자(가, 사, 까, 싸)를 익히고,\n모음 'ㅏ'를 과감히 생략하는\n마법의 약자 원리를 이해합니다.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.appTextSubColor)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 20)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("11일차, 마법의 줄임말 약자 1, 고유 약자와 ㅏ 생략. 오늘의 목표: 글자의 부피를 확 줄여주는 점자만의 고유한 약자 가, 사, 까, 싸를 익히고, 모음 ㅏ를 과감히 생략하는 마법의 약자 원리를 이해합니다.".toAccessibilityPronunciation())
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
    Day11IntroView(onStart: {}, onBack: {})
        .background(Color(.systemGroupedBackground))
}
