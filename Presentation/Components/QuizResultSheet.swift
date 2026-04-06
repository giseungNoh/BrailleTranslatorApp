import SwiftUI

/// 퀴즈 정답/오답 플로팅 시트 공통 컴포넌트
struct QuizResultSheet: View {
    let isCorrect: Bool
    let correctLetter: String
    let correctDotLabel: String
    let explanation: String?
    let isLastQuestion: Bool
    let onNext: () -> Void

    @AccessibilityFocusState private var isResultFocused: Bool

    var body: some View {
        VStack(spacing: 20) {
            // 드래그 핸들
            Capsule()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 40, height: 5)
                .padding(.top, 8)
                .accessibilityHidden(true)

            if isCorrect {
                // MARK: 정답
                correctView
            } else {
                // MARK: 오답
                wrongView
            }

            Spacer()
        }
        .padding(.top, 8)
        .onAppear {
            if isCorrect {
                // 정답이면 잠깐 보여주고 자동 진행
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    isResultFocused = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    onNext()
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    isResultFocused = true
                }
            }
        }
    }

    // MARK: - 정답 뷰

    private var correctView: some View {
        VStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 56))
                .foregroundColor(.green)
                .accessibilityHidden(true)

            Text("정답입니다!")
                .font(.title2.bold())
                .foregroundColor(.appTextColor)

            Text(isLastQuestion ? "잠시 후 결과 화면으로 이동합니다" : "잠시 후 다음 문제로 넘어갑니다")
                .font(.subheadline)
                .foregroundColor(.appTextSubColor)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("정답입니다. \(isLastQuestion ? "잠시 후 결과 화면으로 이동합니다" : "잠시 후 다음 문제로 넘어갑니다")")
        .accessibilityFocused($isResultFocused)
    }

    // MARK: - 오답 뷰

    private var wrongView: some View {
        VStack(spacing: 16) {
            // 결과 텍스트
            VStack(spacing: 8) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 56))
                    .foregroundColor(.red)
                    .accessibilityHidden(true)

                Text("오답입니다")
                    .font(.title2.bold())
                    .foregroundColor(.appTextColor)
            }

            // 정답 정보
            VStack(spacing: 6) {
                Text("정답")
                    .font(.caption)
                    .foregroundColor(.appTextSubColor)

                HStack(spacing: 8) {
                    Text(correctLetter)
                        .font(.title.bold())
                        .foregroundColor(.appSubColor)

                    Text(correctDotLabel)
                        .font(.body)
                        .foregroundColor(.appTextSubColor)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background(Color.appSubColor.opacity(0.08))
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .padding(.horizontal, 20)

            // 해설
            if let explanation = explanation {
                Text(explanation)
                    .font(.subheadline)
                    .foregroundColor(.appTextSubColor)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
            }

            // 다음 버튼
            Button(action: onNext) {
                Text(isLastQuestion ? "결과 보기" : "다음 문제")
                    .font(.title3.bold())
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.appSubColor)
                    .cornerRadius(16)
            }
            .padding(.horizontal, 20)
            .accessibilityLabel(isLastQuestion ? "결과 보기" : "다음 문제")
            .accessibilityHint(isLastQuestion ? "퀴즈 결과 화면으로 이동합니다" : "다음 문제로 넘어갑니다")
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel({
            var label = "오답입니다. 정답은 \(correctLetter), \(correctDotLabel)입니다."
            if let explanation = explanation {
                label += " \(explanation)"
            }
            return label
        }())
        .accessibilityFocused($isResultFocused)
    }
}
