import SwiftUI

/// ① 시작하기 화면 (Intro: 학습 목표)
struct Day1IntroView: View {
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
                Text("1일차")
                    .font(.title3.weight(.medium))
                    .foregroundColor(.appTextSubColor)

                Text("점자의 기초와\n촉각 훈련")
                    .font(.largeTitle.bold())
                    .multilineTextAlignment(.center)
                    .foregroundColor(.appTextColor)

                Text("오늘의 목표")
                    .font(.headline)
                    .foregroundColor(.appTextSubColor)
                    .padding(.top, 12)

                Text("점자의 6점 구조를 이해하고,\n가로 선을 따라가며 빈칸을 구별하는\n연습을 합니다.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.appTextSubColor)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 20)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("1일차, 점자의 기초와 촉각 훈련. 오늘의 목표, 점자의 6점 구조를 이해하고, 가로 선을 따라가며 빈칸을 구별하는 연습을 합니다.".toAccessibilityPronunciation())
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
