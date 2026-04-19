import SwiftUI
import SwiftData

/// 오답 상세 복습 화면
struct WrongAnswerDetailView: View {
    @ObservedObject var viewModel: QuizViewModel
    let correctLetter: String
    @Environment(\.modelContext) private var modelContext
    @State private var showTouchView = false
    @AccessibilityFocusState private var isHeaderFocused: Bool

    private var attempt: QuizAttempt? {
        let letter = correctLetter
        let descriptor = FetchDescriptor<QuizAttempt>(
            predicate: #Predicate {
                $0.correctLetter == letter
                && !$0.isCorrect
            },
            sortBy: [SortDescriptor(\.timestamp, order: .reverse)]
        )
        return try? modelContext.fetch(descriptor).first
    }

    /// 카테고리 정보
    private var category: QuizCategory? {
        guard let attempt = attempt else { return nil }
        return quizCategories.first { $0.id == attempt.categoryId }
    }

    /// 정답 아이템 (dotLabel 조회용)
    private var correctItem: BrailleLetterItem? {
        guard let attempt = attempt else { return nil }
        return category?.questionPool().first { $0.letter == attempt.correctLetter }
    }

    /// 내 답 아이템 (dotLabel 조회용)
    private var userItem: BrailleLetterItem? {
        guard let attempt = attempt else { return nil }
        return category?.questionPool().first { $0.letter == attempt.userSelectedLetter }
    }

    /// 해설
    private var explanation: String {
        guard let attempt = attempt else { return "" }
        return QuizExplanationProvider.explanation(
            for: attempt.correctLetter,
            categoryId: attempt.categoryId
        )
    }

    var body: some View {
        if showTouchView, let attempt = attempt {
            WrongAnswerTouchView(
                attempt: attempt,
                correctItem: correctItem,
                userItem: userItem,
                category: category
            ) {
                showTouchView = false
            }
        } else {
            infoView
        }
    }

    // MARK: - 정보 화면

    private var infoView: some View {
        VStack(spacing: 0) {
            CommonNavigationBar(title: "오답 복습") {
                Button {
                    viewModel.goTo(.wrongAnswerList)
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                        .foregroundColor(.appTextColor)
                }
                .accessibilityLabel("뒤로 가기".toAccessibilityPronunciation())
                .accessibilityHint("오답 노트 목록으로 돌아갑니다")
            } trailing: {
                if attempt != nil {
                    Button {
                        deleteAndGoBack()
                    } label: {
                        Image(systemName: "trash")
                            .font(.title3)
                            .foregroundColor(.gray)
                    }
                    .accessibilityLabel("오답 기록 삭제".toAccessibilityPronunciation())
                    .accessibilityHint("두번 탭하면 이 오답 기록이 삭제됩니다")
                }
            }

            if let attempt = attempt {
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {

                        // MARK: 카테고리 뱃지 + 글자
                        VStack(alignment: .leading, spacing: 6) {
                            if let category = category {
                                Text(category.title)
                                    .font(.caption.bold())
                                    .foregroundColor(.appAccentBlue)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 4)
                                    .background(Color.appAccentBlue.opacity(0.12))
                                    .clipShape(Capsule())
                            }

                            Text(attempt.correctLetter)
                                .font(.title.bold())
                                .foregroundColor(.appTextColor)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                        .padding(.bottom, 16)
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel("\(category?.title ?? "".toAccessibilityPronunciation()), 정답: \(attempt.correctLetter)".toAccessibilityPronunciation())


                        // MARK: 문제
                        VStack(alignment: .leading, spacing: 8) {
                            Text("문제")
                                .font(.caption.bold())
                                .foregroundColor(.appTextSubColor)

                            Text(attempt.questionText)
                                .font(.subheadline)
                                .foregroundColor(.appTextColor)
                        }
                        .accessibilityElement(children: .combine)
                        .accessibilityFocused($isHeaderFocused)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 16)

                        // MARK: 내 답 vs 정답
                        HStack(alignment: .top, spacing: 12) {
                            answerBox(
                                label: "내가 선택한 답",
                                letter: attempt.userSelectedLetter,
                                dotLabel: userItem?.dotLabel,
                                color: .red
                            )
                            answerBox(
                                label: "정답",
                                letter: attempt.correctLetter,
                                dotLabel: correctItem?.dotLabel ?? attempt.correctDotLabel,
                                color: .appAccentBlue
                            )
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 16)

                        // MARK: 해설
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

                        // MARK: 만져보기 버튼
                        Button {
                            withAnimation(.easeInOut(duration: 0.25)) {
                                showTouchView = true
                            }
                        } label: {
                            HStack {
                                Text("점자 비교하며 만져보기")
                                    .font(.title3.bold())
                            }
                            .foregroundColor(.appSubColor)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.appSubColor, lineWidth: 1.5)
                            )
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 12)
                        .accessibilityLabel("점자 비교하며 만져보기".toAccessibilityPronunciation())
                        .accessibilityHint("정답과 내 답의 점자를 직접 만져볼 수 있습니다")

                        // MARK: 이전으로 버튼 (추가됨)
                        Button {
                            viewModel.goTo(.wrongAnswerList)
                        } label: {
                            HStack {
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

    // MARK: - 답 비교 박스

    private func answerBox(label: String, letter: String, dotLabel: String?, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.caption.bold())
                .foregroundColor(color)

            Text(letter)
                .font(.title3.bold())
                .foregroundColor(.appTextColor)

            Text(dotLabel ?? " ")
                .font(.caption)
                .foregroundColor(dotLabel != nil ? .appTextSubColor : .clear)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(14)
        .background(color.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .strokeBorder(color.opacity(0.15), lineWidth: 1)
        )
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(label): \(letter)\(dotLabel.map { ", \($0)" } ?? "".toAccessibilityPronunciation())".toAccessibilityPronunciation())
    }

    // MARK: - 삭제

    private func deleteAndGoBack() {
        if let attempt = attempt {
            modelContext.delete(attempt)
            try? modelContext.save()
        }
        viewModel.goTo(.wrongAnswerList)
    }
}

// MARK: - 점자 만져보기 화면

private struct WrongAnswerTouchView: View {
    let attempt: QuizAttempt
    let correctItem: BrailleLetterItem?
    let userItem: BrailleLetterItem?
    let category: QuizCategory?
    let onBack: () -> Void

    /// true: 정답 점자 표시, false: 내 답 점자 표시
    @State private var showingCorrect = true
    @State private var isInteracting = false
    @AccessibilityFocusState private var isLabelFocused: Bool

    private static let jongseongCategories: Set<String> = [
        "jongseong_push", "jongseong_drop", "jongseong_compound"
    ]
    private static let abbrCategories: Set<String> = [
        "abbr_a_omit", "abbreviations", "abbr_conjunction"
    ]
    private static let numberCategories: Set<String> = ["numbers"]

    private var currentLetter: String {
        showingCorrect ? attempt.correctLetter : attempt.userSelectedLetter
    }

    private var currentItem: BrailleLetterItem? {
        showingCorrect ? correctItem : userItem
    }

    private var currentDotLabel: String {
        if showingCorrect {
            return correctItem?.dotLabel ?? attempt.correctDotLabel
        }
        return userItem?.dotLabel ?? attempt.userSelectedLetter
    }

    private var displayCellCount: Int {
        let categoryId = attempt.categoryId
        let item = currentItem

        if Self.numberCategories.contains(categoryId) {
            return min(item?.cellsPerLine ?? 2, 4)
        }
        return min(item?.cellsPerLine ?? 1, 4)
    }

    /// 내 답이 점자로 표시 가능한지 (O/X 답이면 불가)
    private var canShowUserBraille: Bool {
        let answer = attempt.userSelectedLetter
        return answer != "O" && answer != "X" && userItem != nil
    }

    var body: some View {
        VStack(spacing: 0) {
            // 상단 바
            CommonNavigationBar(title: showingCorrect ? "정답 점자" : "내 오답 점자") {
                Button {
                    onBack()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                        .foregroundColor(.appTextColor)
                } 
                .accessibilityLabel("뒤로 가기".toAccessibilityPronunciation())
                .accessibilityHint("오답 복습으로 돌아갑니다")
            }  trailing: {
                // Trailing: 비어있어도 Spacer를 주거나 아주 작은 공간을 줍니다.
                // 이렇게 하면 왼쪽 버튼이 왼쪽 끝으로 밀착됩니다.
                Spacer().frame(width: 24)
            }

            // 현재 표시 중인 글자 정보
            VStack(spacing: 4) {
                Text(showingCorrect ? "정답" : "내 답")
                    .font(.caption.bold())
                    .foregroundColor(showingCorrect ? .appSubColor : .red)

                Text("\(currentLetter)  (\(currentDotLabel))")
                    .font(.title3.bold())
                    .foregroundColor(.appTextColor)
                    .multilineTextAlignment(.center)
            }
            .padding(.vertical, 8)
            .accessibilityFocused($isLabelFocused)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("\(showingCorrect ? "정답" : "내 답".toAccessibilityPronunciation()): \(currentLetter), \(currentDotLabel)".toAccessibilityPronunciation())

            // 점자 캔버스
            let isJongseong = Self.jongseongCategories.contains(attempt.categoryId)
            let isAbbr = Self.abbrCategories.contains(attempt.categoryId)

            BrailleCanvasView(
                text: currentLetter,
                useAbbreviations: isAbbr,
                cellsPerLineOverride: displayCellCount,
                useChosungForm: !isJongseong,
                isInteracting: $isInteracting,
                maxCellWidth: 120,
                accessibilityLabelOverride: "\(showingCorrect ? "정답" : "내 답") \(currentLetter) 점자 터치 영역",
                hideLabels: false,
                enableOneFingerSwipe: false,
                rawDotPatterns: currentItem?.rawDots.map { dotsStr in
                    let dotParts = dotsStr.split(separator: ",")
                    let labels = currentItem?.rawDotLabels?.split(separator: ",").map(String.init)
                    return dotParts.enumerated().map { idx, dots in
                        let label = (labels != nil && idx < labels!.count) ? labels![idx] : currentLetter
                        return (dots: String(dots), label: label)
                    }
                },
                skipLeadingCells: isJongseong ? 1 : 0,
                centerVertically: true,
                onSwipeNext: {
                    if UIAccessibility.isVoiceOverRunning {
                        toggleShowingCorrect()
                    }
                },
                onSwipePrevious: {
                    if UIAccessibility.isVoiceOverRunning {
                        toggleShowingCorrect()
                    }
                }
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, 20)
            .id("touch-\(showingCorrect ? "correct" : "user")")

            // MARK: 하단 버튼 영역
            VStack(spacing: 12) {
                if canShowUserBraille {
                    // 보조 버튼 (정답/내 답 전환)
                    Button(action: {
                        toggleShowingCorrect()
                    }) {
                        Text(showingCorrect ? "내 오답 점자 보기" : "정답 점자 보기")
                            .font(.title3.bold())
                            .foregroundColor(.appSubColor)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.appSubColor, lineWidth: 1.5)
                            )
                    }
                    .accessibilityLabel(showingCorrect ? "내 답 점자 보기" : "정답 점자 보기")
                    .accessibilityHint(showingCorrect ? "내가 선택한 답의 점자를 만져봅니다" : "정답 점자를 만져봅니다")
                }

                // 주 버튼 (돌아가기)
                Button(action: {
                    onBack()
                }) {
                    Text("돌아가기")
                        .font(.title3.bold())
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.appSubColor)
                        .cornerRadius(16)
                }
                .accessibilityLabel("돌아가기".toAccessibilityPronunciation())
                .accessibilityHint("오답 복습 화면으로 돌아갑니다")
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
        }
        .meshBackground()
        .accessibilityAction(.escape) {
            onBack()
        }
        .onChange(of: showingCorrect) {
            UIAccessibility.post(notification: .screenChanged, argument: nil)
        }
    }

    private func toggleShowingCorrect() {
        guard canShowUserBraille else { return }
        withAnimation(.easeInOut(duration: 0.2)) {
            showingCorrect.toggle()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            isLabelFocused = true
        }
    }
}
