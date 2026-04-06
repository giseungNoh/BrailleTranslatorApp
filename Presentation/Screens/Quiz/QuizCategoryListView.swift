import SwiftUI
import SwiftData

/// 퀴즈 카테고리 선택 리스트
struct QuizCategoryListView: View {
    @ObservedObject var viewModel: QuizViewModel
    @Query(filter: #Predicate<QuizAttempt> { !$0.isCorrect })
    private var wrongAnswers: [QuizAttempt]
    @Query(filter: #Predicate<QuizAttempt> { $0.isCorrect })
    private var correctAnswers: [QuizAttempt]
    @AccessibilityFocusState private var isTitleFocused: Bool

    /// 카테고리별 정답 수 (중복 글자 제외 — 고유 글자 기준)
    private func solvedCount(for categoryId: String) -> Int {
        let uniqueLetters = Set(
            correctAnswers
                .filter { $0.categoryId == categoryId }
                .map { $0.correctLetter }
        )
        return uniqueLetters.count
    }

    /// 전체 완료 진행률
    private var totalSolved: Int {
        quizCategories.reduce(0) { sum, cat in
            sum + min(solvedCount(for: cat.id), cat.questionCount)
        }
    }

    private var totalQuestions: Int {
        quizCategories.reduce(0) { $0 + $1.questionCount }
    }

    private var groupedCategories: [(section: Int, name: String, categories: [QuizCategory])] {
        let grouped = Dictionary(grouping: quizCategories) { $0.section }
        return grouped.keys.sorted().compactMap { section in
            guard let cats = grouped[section] else { return nil }
            let name = quizSectionNames[section] ?? ""
            return (section: section, name: name, categories: cats)
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            CommonNavigationBar(title: "퀴즈")

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {

                    // MARK: 전체 진행률
                    VStack(spacing: 8) {
                        HStack {
                            Text("완료한 퀴즈")
                                .font(.subheadline.bold())
                                .foregroundColor(.appTextColor)

                            Spacer()

                            Text("\(totalSolved) / \(totalQuestions)")
                                .font(.subheadline.bold())
                                .foregroundColor(.appSubColor)
                        }

                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                Capsule()
                                    .fill(Color.gray.opacity(0.15))
                                    .frame(height: 10)

                                Capsule()
                                    .fill(Color.appSubColor)
                                    .frame(
                                        width: totalQuestions > 0
                                            ? geo.size.width * CGFloat(totalSolved) / CGFloat(totalQuestions)
                                            : 0,
                                        height: 10
                                    )
                            }
                        }
                        .frame(height: 10)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 12)
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel("전체 진행률. \(totalQuestions)문제 중 \(totalSolved)문제 완료")

                    // MARK: 오답노트 카드
                    WrongAnswerNoteCard(wrongCount: wrongAnswers.count) {
                        viewModel.goTo(.wrongAnswerList)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 4)

                    // 구분선
                    Divider()
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)

                    // MARK: 섹션 헤더
                    VStack(alignment: .leading, spacing: 4) {
                        Text("퀴즈")
                            .font(.title2.bold())
                            .foregroundColor(.appTextColor)

                        Text("퀴즈테마를 선택하여 점자를 직접만지고 문제를 풀어보세요")
                            .font(.subheadline)
                            .foregroundColor(.appTextSubColor)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 12)
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel("퀴즈. 퀴즈테마를 선택하여 점자를 직접만지고 문제를 풀어보세요")

                    // MARK: 카테고리 카드 목록
                    VStack(spacing: 24) {
                        ForEach(groupedCategories, id: \.section) { group in
                            VStack(alignment: .leading, spacing: 10) {
                                Text(group.name)
                                    .font(.subheadline.bold())
                                    .foregroundColor(.appTextSubColor)
                                    .padding(.horizontal, 20)
                                    .accessibilityAddTraits(.isStaticText)

                                VStack(spacing: 12) {
                                    ForEach(group.categories) { category in
                                        QuizCategoryCard(
                                            category: category,
                                            solvedCount: solvedCount(for: category.id)
                                        ) {
                                            viewModel.handleCategoryTap(category: category)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(.bottom, 40)
                }
            }
        }
        .background(Color(.systemBackground))
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isTitleFocused = true
            }
        }
    }
}

// MARK: - 오답노트 카드

private struct WrongAnswerNoteCard: View {
    let wrongCount: Int
    let onTap: () -> Void

    @ScaledMetric(relativeTo: .title2) private var iconSize: CGFloat = 52

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 14) {
                Image(systemName: "bookmark.fill")
                    .font(.title2)
                    .foregroundColor(.appSubColor)
                    .frame(width: iconSize, height: iconSize)
                    .background(Color.appSubColor.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .accessibilityHidden(true)

                VStack(alignment: .leading, spacing: 5) {
                    Text("오답노트")
                        .font(.title3.bold())
                        .foregroundColor(.appTextColor)

                    Text("틀린 문제를 다시 복습하세요")
                        .font(.subheadline)
                        .foregroundColor(.appTextSubColor)
                }
                Spacer(minLength: 8)

                if wrongCount > 0 {
                    Text("\(wrongCount)")
                        .font(.subheadline.bold())
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color.appSubColor)
                        .clipShape(Capsule())
                }
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 18)
            .appCard(cornerRadius: 16)
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(
            wrongCount == 0
            ? "오답노트. 아직 틀린 문제가 없습니다"
            : "오답노트. 틀린 문제 \(wrongCount)개를 복습하세요"
        )
        .accessibilityHint("두번 탭하여 오답노트로 이동합니다")
        .accessibilityAddTraits(.isButton)
    }
}

// MARK: - 카테고리 카드

private struct QuizCategoryCard: View {
    let category: QuizCategory
    let solvedCount: Int
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 14) {
                BrailleThumbnail(letter: category.questionPool().first?.letter ?? "")
                    .accessibilityHidden(true)

                VStack(alignment: .leading, spacing: 4) {
                    Text(category.title)
                        .font(.headline.bold())
                        .foregroundColor(.appTextColor)
                        .lineLimit(1)

                    Text(category.subtitle)
                        .font(.caption)
                        .foregroundColor(.appTextSubColor)
                        .lineLimit(1)

                    HStack(spacing: 4) {
                        Image(systemName: "crown.fill")
                            .font(.caption2)
                            .foregroundColor(.appSubColor)

                        Text("\(category.questionCount)문제")
                            .font(.caption.bold())
                            .foregroundColor(.appSubColor)
                    }
                }

                Spacer(minLength: 8)

                CircularProgressView(
                    current: solvedCount,
                    total: category.questionCount,
                    size: 44
                )
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .appCard(cornerRadius: 16)
        }
        .padding(.horizontal, 20)
        .buttonStyle(.plain)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(category.title). \(category.subtitle). \(category.questionCount)문제. \(solvedCount)문제 정답")
        .accessibilityHint("두번 탭하여 퀴즈를 시작합니다")
        .accessibilityAddTraits(.isButton)
    }
}

// MARK: - 점자 썸네일 (간소화된 점자 아이콘)

private struct BrailleThumbnail: View {
    let letter: String

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color.appSubColor.opacity(0.07))
                .overlay(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .strokeBorder(Color.appSubColor.opacity(0.15), lineWidth: 0.5)
                )

            VStack(spacing: 2) {
                // 점자 6점 아이콘
                Image(systemName: "circle.grid.3x2.fill")
                    .font(.system(size: 16))
                    .foregroundColor(.appSubColor.opacity(0.5))

                Text(letter)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.appTextColor)
            }
        }
        .frame(width: 56, height: 56)
    }
}
