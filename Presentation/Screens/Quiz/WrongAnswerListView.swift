import SwiftUI
import SwiftData

/// 오답 노트 목록 — 카테고리별 그룹핑
struct WrongAnswerListView: View {
    @ObservedObject var viewModel: QuizViewModel
    @Environment(\.modelContext) private var modelContext
    @Query(
        filter: #Predicate<QuizAttempt> {
            !$0.isCorrect
            && $0.userSelectedLetter != "북마크"
            && $0.userSelectedLetter != "O"
            && $0.userSelectedLetter != "X"
        },
        sort: \QuizAttempt.timestamp,
        order: .reverse
    ) private var wrongAnswers: [QuizAttempt]
    @AccessibilityFocusState private var isTitleFocused: Bool

    /// 카테고리별로 그룹핑 (quizCategories 순서 유지)
    private var groupedWrongAnswers: [(category: QuizCategory, attempts: [QuizAttempt])] {
        let byCategory = Dictionary(grouping: wrongAnswers) { $0.categoryId }
        return quizCategories.compactMap { category in
            guard let attempts = byCategory[category.id], !attempts.isEmpty else { return nil }
            return (category: category, attempts: attempts)
        }
    }

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
                emptyView
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // 상단 요약
                        HStack {
                            Text("총 \(wrongAnswers.count)개의 틀린 문제")
                                .font(.subheadline)
                                .foregroundColor(.appTextSubColor)
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 12)

                        // 카테고리별 섹션
                        ForEach(groupedWrongAnswers, id: \.category.id) { group in
                            VStack(alignment: .leading, spacing: 10) {
                                // 섹션 헤더
                                HStack(spacing: 8) {
                                    Text(group.category.title)
                                        .font(.subheadline.bold())
                                        .foregroundColor(.appTextSubColor)

                                    Text("\(group.attempts.count)")
                                        .font(.caption2.bold())
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 7)
                                        .padding(.vertical, 2)
                                        .background(Color.appSubColor)
                                        .clipShape(Capsule())
                                }
                                .padding(.horizontal, 20)
                                .accessibilityElement(children: .ignore)
                                .accessibilityLabel("\(group.category.title), 틀린 문제 \(group.attempts.count)개")

                                // 카드 목록
                                VStack(spacing: 8) {
                                    ForEach(group.attempts, id: \.id) { attempt in
                                        WrongAnswerCard(attempt: attempt) {
                                            viewModel.goTo(.wrongAnswerDetail(attempt.correctLetter))
                                        } onDelete: {
                                            modelContext.delete(attempt)
                                            try? modelContext.save()
                                        }
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                    }
                    .padding(.bottom, 40)
                }
            }
        }
        .meshBackground()
        .accessibilityAction(.escape) {
            viewModel.goTo(.categorySelection)
        }
        .onAppear {
            viewModel.cleanUpWrongAnswers(context: modelContext)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isTitleFocused = true
            }
        }
    }

    // MARK: - 빈 상태

    private var emptyView: some View {
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
    }
}

// MARK: - 오답 카드

private struct WrongAnswerCard: View {
    let attempt: QuizAttempt
    let onTap: () -> Void
    let onDelete: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 14) {
                // 정답 글자
                Text(attempt.correctLetter)
                    .font(.title2.bold())
                    .foregroundColor(.appTextColor)
                    .frame(width: 44, height: 44)
                    .background(Color.appSubColor.opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

                VStack(alignment: .leading, spacing: 3) {
                    Text(attempt.correctDotLabel)
                        .font(.subheadline)
                        .foregroundColor(.appTextColor)
                        .lineLimit(1)

                    HStack(spacing: 4) {
                        Text("내 답:")
                            .font(.caption)
                            .foregroundColor(.appTextSubColor)

                        Text(attempt.userSelectedLetter)
                            .font(.caption.bold())
                            .foregroundColor(.red.opacity(0.7))
                    }
                }

                Spacer(minLength: 8)

                // 삭제 버튼
                Button {
                    onDelete()
                } label: {
                    Image(systemName: "trash")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .frame(width: 36, height: 36)
                }
                .accessibilityLabel("삭제")
                .accessibilityHint("\(attempt.correctLetter) 오답 기록을 삭제합니다")

                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.gray.opacity(0.5))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .appCard(cornerRadius: 14)
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("정답: \(attempt.correctLetter), \(attempt.correctDotLabel). 내 답: \(attempt.userSelectedLetter)")
        .accessibilityHint("두번 탭하여 점자를 복습합니다")
        .accessibilityAddTraits(.isButton)
    }
}
