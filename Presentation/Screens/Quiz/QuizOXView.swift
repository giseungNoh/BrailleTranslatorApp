import SwiftUI

/// O/X 퀴즈 뷰 — 규칙 문장을 읽고 O 또는 X 선택
struct QuizOXView: View {
    @ObservedObject var viewModel: QuizViewModel
    @AccessibilityFocusState private var isStatementFocused: Bool

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            // MARK: 문제 텍스트
            if let question = viewModel.currentQuestion {
                Text(question.questionText)
                    .font(.title2.bold())
                    .foregroundColor(.appTextColor)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                    .accessibilityFocused($isStatementFocused)
                    .accessibilityLabel(question.questionText)
            }

            Spacer()

            // MARK: O / X 버튼
            HStack(spacing: 20) {
                OXButton(type: .o) {
                    viewModel.selectOX(true)
                }

                OXButton(type: .x) {
                    viewModel.selectOX(false)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 32)
        }
        .disabled(viewModel.showResult)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isStatementFocused = true
            }
        }
    }
}

// MARK: - O/X 버튼

private enum OXType {
    case o, x
}

private struct OXButton: View {
    let type: OXType
    let onTap: () -> Void

    private var title: String { type == .o ? "O" : "X" }
    private var color: Color { type == .o ? .blue : .red }

    var body: some View {
        Button(action: onTap) {
            Text(title)
                .font(.system(size: 48, weight: .black))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(minHeight: 100)
                .background(color)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        }
        .accessibilityLabel(title)
        .accessibilityHint(type == .o ? "맞다고 답합니다" : "틀리다고 답합니다")
        .accessibilityAddTraits(.isButton)
    }
}
