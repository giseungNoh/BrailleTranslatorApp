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
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    isResultFocused = true
                }
                // VoiceOver ON: 사용자가 직접 "다음 문제" 버튼을 눌러 진행
                if !UIAccessibility.isVoiceOverRunning {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        onNext()
                    }
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    isResultFocused = true
                }
            }
        }
    }

    // MARK: - 정답 뷰

    private var correctView: some View {
        let isVO = UIAccessibility.isVoiceOverRunning
        let statusText = isVO
            ? (isLastQuestion ? "결과 보기 버튼을 눌러 주세요" : "다음 문제 버튼을 눌러 주세요")
            : (isLastQuestion ? "잠시 후 결과 화면으로 이동합니다" : "잠시 후 다음 문제로 넘어갑니다")

        return VStack(spacing: 16) {
            VStack(spacing: 12) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 56))
                    .foregroundColor(.green)
                    .accessibilityHidden(true)

                Text("정답입니다!")
                    .font(.title2.bold())
                    .foregroundColor(.appTextColor)

                Text(statusText)
                    .font(.subheadline)
                    .foregroundColor(.appTextSubColor)
            }
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("정답입니다. \(statusText)")
            .accessibilityFocused($isResultFocused)

            if isVO {
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
        }
    }

    // MARK: - 오답 뷰

    private var wrongView: some View {
        VStack(spacing: 16) {
            // 결과 블록 (아이콘 + "오답입니다" + 정답 정보 + 해설) — 단일 그룹
            VStack(spacing: 16) {
                VStack(spacing: 8) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 56))
                        .foregroundColor(.red)
                        .accessibilityHidden(true)

                    Text("오답입니다")
                        .font(.title2.bold())
                        .foregroundColor(.appTextColor)
                }

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
                    if let explanation = explanation {
                        Text(explanation)
                            .font(.subheadline)
                            .foregroundColor(.appTextSubColor)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 24)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                .background(Color.appSubColor.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .padding(.horizontal, 20)


            }
            .accessibilityElement(children: .ignore)
            .accessibilityLabel({
                var label = "오답입니다. 정답은 \(correctLetter), \(correctDotLabel)입니다."
                if let explanation = explanation {
                    label += " \(explanation)"
                }
                return label.toAccessibilityPronunciation()
            }())
            .accessibilityFocused($isResultFocused)

            // 다음 버튼 (그룹 밖 — 독립 포커스 대상)
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
    }
}
