import SwiftUI
import SwiftData

/// 오답 노트 목록
struct WrongAnswerListView: View {
    @ObservedObject var viewModel: QuizViewModel
    @Environment(\.modelContext) private var modelContext
    @Query(
        filter: #Predicate<QuizAttempt> { !$0.isCorrect },
        sort: \QuizAttempt.timestamp,
        order: .reverse
    ) private var wrongAnswers: [QuizAttempt]
    @AccessibilityFocusState private var isTitleFocused: Bool

    var body: some View {
        VStack(spacing: 0) {
            CommonNavigationBar(title: "오답 노트") {
                Button {
                    viewModel.goTo(.categorySelection)
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                        .foregroundColor(.appTextColor)
                }
                .accessibilityLabel("뒤로 가기")
                .accessibilityHint("카테고리 선택으로 돌아갑니다")
            }

            if wrongAnswers.isEmpty {
                VStack(spacing: 12) {
                    Spacer()
                    Image(systemName: "checkmark.circle")
                        .font(.system(size: 48))
                        .foregroundColor(.gray.opacity(0.4))

                    Text("틀린 문제가 없습니다")
                        .font(.title3)
                        .foregroundColor(.appTextSubColor)
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .accessibilityLabel("틀린 문제가 없습니다")
            } else {
                List {
                    ForEach(wrongAnswers, id: \.id) { attempt in
                        Button {
                            viewModel.goTo(.wrongAnswerDetail(attempt.correctLetter))
                        } label: {
                            HStack(spacing: 12) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(attempt.correctLetter)
                                        .font(.title2.bold())
                                        .foregroundColor(.appTextColor)

                                    Text(attempt.correctDotLabel)
                                        .font(.caption)
                                        .foregroundColor(.appTextSubColor)
                                }

                                Spacer()

                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .padding(.vertical, 4)
                        }
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel("\(attempt.correctLetter), \(attempt.correctDotLabel)")
                        .accessibilityHint("두번 탭하여 점자를 복습합니다")
                        .accessibilityAddTraits(.isButton)
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            let attempt = wrongAnswers[index]
                            modelContext.delete(attempt)
                        }
                        try? modelContext.save()
                    }
                }
                .listStyle(.plain)
            }
        }
        .background(Color(.systemBackground))
        .accessibilityAction(.escape) {
            viewModel.goTo(.categorySelection)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isTitleFocused = true
            }
        }
    }
}
