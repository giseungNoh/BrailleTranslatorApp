import SwiftUI

/// ① 시작하기 화면 (Intro: 학습 목표)
struct Day1IntroView: View {
    let onStart: () -> Void
    let onBack: () -> Void

    @AccessibilityFocusState private var focusedElement: AccessibilityFocus?

    enum AccessibilityFocus {
        case intro
    }

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

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
            .padding(.horizontal, 30)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("1일차, 점자의 기초와 촉각 훈련. 오늘의 목표, 점자의 6점 구조를 이해하고, 가로 선을 따라가며 빈칸을 구별하는 연습을 합니다.")
            .accessibilityFocused($focusedElement, equals: .intro)

            Spacer()

            // 시작하기 버튼
            Button(action: onStart) {
                Text("시작하기")
                    .font(.title2.bold())
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.appSubColor)
                    .cornerRadius(16)
            }
            .padding(.horizontal, 20)
            .accessibilityLabel("시작하기")
            .accessibilityHint("이중 탭하면 학습을 시작합니다")

            // 뒤로가기 버튼
            Button(action: onBack) {
                Text("돌아가기")
                    .font(.body)
                    .foregroundColor(.appTextSubColor)
            }
            .padding(.top, 12)
            .padding(.bottom, 40)
            .accessibilityLabel("돌아가기")
            .accessibilityHint("커리큘럼 목록으로 돌아갑니다")
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                focusedElement = .intro
            }
        }
    }
}
