import SwiftUI
import SwiftData

/// ④ 정리하기 화면 (Summary & Quiz)
struct Day1SummaryView: View {
    @Bindable var item: LearningItem
    let onBack: () -> Void
    @Environment(\.dismiss) private var dismiss

    // 빈칸 정답 (Day1Learning2View의 패턴과 동기화)
    private let correctAnswer = 3
    private let choices = [1, 2, 3, 4]

    @State private var selectedAnswer: Int? = nil
    @State private var showResult = false
    @State private var isCorrect = false

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 24) {
                    Text("정리하기")
                        .font(.title2.bold())
                        .foregroundColor(.appTextColor)
                        .padding(.top, 20)

                    // 퀴즈 질문
                    Text("방금 손가락으로 선을 따라갈 때,\n점이 없는 빈칸은 모두 몇 개였을까요?")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.appTextSubColor)
                        .lineSpacing(4)
                        .padding(.horizontal, 20)

                    // 선택지 버튼들
                    VStack(spacing: 12) {
                        ForEach(choices, id: \.self) { choice in
                            Button(action: {
                                guard !showResult else { return }
                                answerSelected(choice)
                            }) {
                                HStack {
                                    Text("\(choice)개")
                                        .font(.title3.bold())
                                        .foregroundColor(buttonTextColor(for: choice))
                                    Spacer()
                                    if showResult && choice == correctAnswer {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.green)
                                    } else if showResult && choice == selectedAnswer && !isCorrect {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.red)
                                    }
                                }
                                .padding(.horizontal, 20)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(buttonBackground(for: choice))
                                .cornerRadius(14)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14)
                                        .stroke(buttonBorder(for: choice), lineWidth: 2)
                                )
                            }
                            .accessibilityLabel("\(choice)개")
                            .accessibilityHint("이중 탭하여 선택하세요")
                        }
                    }
                    .padding(.horizontal, 20)

                    // 결과 메시지
                    if showResult {
                        VStack(spacing: 12) {
                            if isCorrect {
                                Text("대단해요! 정답입니다.\n손끝 감각이 아주 훌륭하시네요!")
                                    .font(.body)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.green)
                                    .lineSpacing(4)
                            } else {
                                Text("아쉽네요. 정답은 \(correctAnswer)개입니다.\n다시 한번 만져볼까요?")
                                    .font(.body)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.orange)
                                    .lineSpacing(4)
                            }
                        }
                        .padding(.top, 8)
                    }

                    // 마무리 안내
                    if showResult && isCorrect {
                        Text("이것으로 1일차를 마칩니다.\n다음 시간에는 가장 쉬운 기본 자음\n'기역, 니은, 디귿, 리을'의 모양을 배웁니다.")
                            .font(.callout)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.appTextSubColor)
                            .lineSpacing(4)
                            .padding(.top, 16)
                    }
                }
            }

            // 하단 버튼
            if showResult {
                Button(action: {
                    TTSManager.shared.stop()
                    item.isCompleted = true
                    dismiss()
                }) {
                    Text("학습 완료")
                        .font(.title3.bold())
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.appSubColor)
                        .cornerRadius(16)
                }
                .padding(.horizontal, 20)
                .accessibilityLabel("학습 완료")
                .accessibilityHint("1일차 학습을 완료하고 커리큘럼으로 돌아갑니다")
            }

            // 이전으로 버튼 (퀴즈 결과 전에도 표시)
            Button(action: onBack) {
                Text("이전으로")
                    .font(.body)
                    .foregroundColor(.appTextSubColor)
            }
            .padding(.top, 12)
            .padding(.bottom, 40)
            .accessibilityLabel("이전으로")
            .accessibilityHint("촉각 훈련 화면으로 돌아갑니다")
        }
        .onAppear {
            TTSManager.shared.speak(
                "잘하셨습니다! " +
                "방금 손가락으로 선을 따라갈 때, " +
                "점이 없는 빈칸은 모두 몇 개였을까요? " +
                "화면을 쓸어 넘겨 정답을 찾아 두 번 탭 해보세요."
            )
        }
    }

    // MARK: - Actions

    private func answerSelected(_ choice: Int) {
        selectedAnswer = choice
        isCorrect = (choice == correctAnswer)
        showResult = true

        if isCorrect {
            HapticManager.shared.playGuideDotFeedback()
            TTSManager.shared.speak(
                "대단해요! 정답입니다. 손끝 감각이 아주 훌륭하시네요! " +
                "이것으로 1일차를 마칩니다. " +
                "다음 시간에는 가장 쉬운 기본 자음, " +
                "기역, 니은, 디귿, 리을의 모양을 배웁니다."
            )
        } else {
            HapticManager.shared.playSharpBorderFeedback()
            TTSManager.shared.speak(
                "아쉽네요. 정답은 \(correctAnswer)개입니다. 다시 한번 만져볼까요?"
            )
        }
    }

    // MARK: - Styling

    private func buttonTextColor(for choice: Int) -> Color {
        if !showResult { return .appTextColor }
        if choice == correctAnswer { return .green }
        if choice == selectedAnswer { return .red }
        return .appTextSubColor
    }

    private func buttonBackground(for choice: Int) -> Color {
        if !showResult { return .white }
        if choice == correctAnswer { return .green.opacity(0.08) }
        if choice == selectedAnswer && !isCorrect { return .red.opacity(0.08) }
        return .white
    }

    private func buttonBorder(for choice: Int) -> Color {
        if !showResult { return .gray.opacity(0.2) }
        if choice == correctAnswer { return .green }
        if choice == selectedAnswer && !isCorrect { return .red }
        return .gray.opacity(0.2)
    }
}
