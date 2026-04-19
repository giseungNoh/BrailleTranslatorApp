import SwiftUI

/// 퀴즈 세션 완료 화면 — 점수 요약
struct QuizSessionCompleteView: View {
    @ObservedObject var viewModel: QuizViewModel
    @AccessibilityFocusState private var isResultFocused: Bool

    private var totalCount: Int { viewModel.questions.count }
    private var correctCount: Int { viewModel.correctCount }
    private var wrongCount: Int { totalCount - correctCount }

    private var scoreText: String {
        "\(totalCount)문제 중 \(correctCount)개 정답"
    }

    private var resultAccessibilityLabel: String {
        var label = "퀴즈 결과. \(scoreText)."
        if wrongCount > 0 {
            label += " 틀린 \(wrongCount)문제는 오답 노트에 저장되었습니다."
        } else {
            label += " 모두 정답입니다. 축하합니다!"
        }
        return label
    }

    var body: some View {
        VStack(spacing: 0) {
            CommonNavigationBar(title: "퀴즈 결과")

            Spacer()

            VStack(spacing: 24) {
                CircularProgressView(
                    current: correctCount,
                    total: totalCount,
                    size: 140,
                    lineWidth: 12
                )

                Text(scoreText)
                    .font(.title3.bold())
                    .foregroundColor(.appTextColor)

                if wrongCount > 0 {
                    Text("틀린 \(wrongCount)문제는 오답 노트에 저장되었습니다")
                        .font(.subheadline)
                        .foregroundColor(.appTextSubColor)
                        .multilineTextAlignment(.center)
                } else {
                    Text("모두 정답입니다!")
                        .font(.subheadline)
                        .foregroundColor(.appSubColor)
                }
            }
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(resultAccessibilityLabel.toAccessibilityPronunciation())
            .accessibilityFocused($isResultFocused)

            Spacer()

            LearningButtonSection(
                nextTitle: "다시 풀기",
                backTitle: "카테고리로 돌아가기",
                nextHint: "같은 카테고리를 다시 풀기합니다",
                backHint: "카테고리 선택 화면으로 돌아갑니다",
                onNext: {
                    viewModel.retryCategory()
                },
                onBack: {
                    viewModel.goTo(.categorySelection)
                }
            )
        }
        .meshBackground()
        .accessibilityAction(.escape) {
            viewModel.goTo(.categorySelection)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isResultFocused = true
            }
        }
    }
}
