import SwiftUI
import SwiftData

/// O/X 규칙 문제 오답 상세 화면
struct WrongAnswerOXDetailView: View {
    @ObservedObject var viewModel: QuizViewModel
    let attemptId: String
    @Environment(\.modelContext) private var modelContext
    @AccessibilityFocusState private var isHeaderFocused: Bool

    private var attempt: QuizAttempt? {
        let descriptor = FetchDescriptor<QuizAttempt>()
        let all = (try? modelContext.fetch(descriptor)) ?? []
        return all.first { $0.id.uuidString == attemptId }
    }

    /// 카테고리 정보
    private var category: QuizCategory? {
        guard let attempt = attempt else { return nil }
        return quizCategories.first { $0.id == attempt.categoryId }
    }

    var body: some View {
        VStack(spacing: 0) {
            CommonNavigationBar(title: "O/X 오답 복습") {
                Button {
                    viewModel.goTo(.wrongAnswerList)
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                        .foregroundColor(.appTextColor)
                }
                .accessibilityLabel("뒤로 가기".toAccessibilityPronunciation())
            } trailing: {
                if attempt != nil {
                    Button {
                        deleteAndGoBack()
                    } label: {
                        Image(systemName: "trash")
                            .font(.title3)
                            .foregroundColor(.gray)
                    }
                    .accessibilityLabel("삭제".toAccessibilityPronunciation())
                    .accessibilityHint("두번 탭하면 이 오답 기록이 삭제됩니다")
                }
            }

            if let attempt = attempt {
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {

                        // MARK: 카테고리 뱃지 + 문제 (그룹)
                        VStack(alignment: .leading, spacing: 0) {
                            if let category = category {
                                Text(category.title)
                                    .font(.caption.bold())
                                    .foregroundColor(.appAccentBlue)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 4)
                                    .background(Color.appAccentBlue.opacity(0.12))
                                    .clipShape(Capsule())
                                    .padding(.top, 16)
                                    .padding(.bottom, 8)
                            }

                            VStack(alignment: .leading, spacing: 8) {
                                Text("문제")
                                    .font(.caption.bold())
                                    .foregroundColor(.appTextSubColor)

                                Text(attempt.questionText)
                                    .font(.headline)
                                    .foregroundColor(.appTextColor)
                                    .lineSpacing(4)
                            }
                            .accessibilityElement(children: .combine)
                            .accessibilityFocused($isHeaderFocused)
                            .padding(.bottom, 16)
                        }
                        .padding(.horizontal, 20)


                        // MARK: 내 답 vs 정답
                        HStack(alignment: .top, spacing: 12) {
                            oxAnswerBox(
                                label: "내 답",
                                value: attempt.userSelectedLetter,
                                isCorrectSide: false
                            )
                            oxAnswerBox(
                                label: "정답",
                                value: attempt.correctLetter,
                                isCorrectSide: true
                            )
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 16)

                        // MARK: 해설
                        if let explanation = attempt.explanation, !explanation.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack(spacing: 6) {
                                    Image(systemName: "lightbulb.fill")
                                        .font(.caption)
                                        .foregroundColor(.appAccentBlue)
                                    Text("해설")
                                        .font(.caption.bold())
                                        .foregroundColor(.appAccentBlue)
                                }

                                Text(explanation)
                                    .font(.subheadline)
                                    .foregroundColor(.appTextColor)
                                    .lineSpacing(4)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(16)
                            .background(Color.appAccentBlue.opacity(0.08))
                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .strokeBorder(Color.appAccentBlue.opacity(0.2), lineWidth: 1)
                            )
                            .padding(.horizontal, 20)
                            .padding(.bottom, 16)
                            .accessibilityElement(children: .combine)
                        }

                        // MARK: 이전으로 버튼
                        Button {
                            viewModel.goTo(.wrongAnswerList)
                        } label: {
                            HStack{
                                Text("이전으로")
                                    .font(.title3.bold())
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.appSubColor)
                            .cornerRadius(16)
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 40)
                        .accessibilityLabel("이전으로".toAccessibilityPronunciation())
                        .accessibilityHint("오답 노트 목록 화면으로 돌아갑니다")
                    }
                }
            } else {
                Spacer()
                Text("데이터를 불러올 수 없습니다")
                    .foregroundColor(.appTextSubColor)
                Spacer()
            }
        }
        .meshBackground()
        .accessibilityAction(.escape) {
            viewModel.goTo(.wrongAnswerList)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isHeaderFocused = true
            }
        }
    }

    private func oxAnswerBox(label: String, value: String, isCorrectSide: Bool) -> some View {
        VStack(spacing: 8) {
            Text(label)
                .font(.caption.bold())
                .foregroundColor(isCorrectSide ? .appSubColor : .red)

            Text(value)
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(isCorrectSide ? .appSubColor : .red.opacity(0.7))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.vertical, 16)
        .background((isCorrectSide ? Color.appSubColor : Color.red).opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .strokeBorder((isCorrectSide ? Color.appSubColor : Color.red).opacity(0.15), lineWidth: 1)
        )
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(label): \(value)".toAccessibilityPronunciation())
    }

    private func deleteAndGoBack() {
        if let attempt = attempt {
            modelContext.delete(attempt)
            try? modelContext.save()
        }
        viewModel.goTo(.wrongAnswerList)
    }
}
