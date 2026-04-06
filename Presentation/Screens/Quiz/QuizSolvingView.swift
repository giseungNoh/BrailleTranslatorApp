import SwiftUI

/// 퀴즈 문제 풀기 메인 컨테이너
struct QuizSolvingView: View {
    @ObservedObject var viewModel: QuizViewModel
    @Environment(\.modelContext) private var modelContext
    @AccessibilityFocusState private var isQuestionFocused: Bool

    var body: some View {
        VStack(spacing: 0) {
            // MARK: 상단 네비게이션
            CommonNavigationBar(title: "퀴즈") {
                Button {
                    viewModel.goTo(.categorySelection)
                } label: {
                    Image(systemName: "xmark")
                        .font(.title3)
                        .foregroundColor(.appTextColor)
                }
                .accessibilityLabel("퀴즈 그만두기")
                .accessibilityHint("카테고리 선택으로 돌아갑니다")
            } trailing: {
                Button {
                    viewModel.goToPreviousQuestion()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                        .foregroundColor(viewModel.isFirstQuestion ? .gray.opacity(0.3) : .appTextColor)
                }
                .disabled(viewModel.isFirstQuestion)
                .accessibilityLabel("이전 문제")
                .accessibilityHint(viewModel.isFirstQuestion ? "첫 번째 문제입니다" : "이전 문제로 돌아갑니다")
            }

            if let question = viewModel.currentQuestion {
                let isOXType = question.type == .oxQuestion

                // MARK: 진행률 (공통)
                progressBar
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel("\(viewModel.questions.count)문제 중 \(viewModel.currentQuestionIndex + 1)번째")

                if !isOXType {
                    // MARK: 객관식 전용 — 문제 텍스트 + 북마크
                    Text(question.questionText)
                        .font(.title3.bold())
                        .foregroundColor(.appTextColor)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 8)
                        .accessibilityFocused($isQuestionFocused)
                        .accessibilityLabel(question.questionText)

                    bookmarkButton
                }

                // MARK: 보기 영역
                switch question.type {
                case .multipleChoice:
                    QuizChoiceExplorerView(viewModel: viewModel)
                case .oxQuestion:
                    QuizOXView(viewModel: viewModel, modelContext: modelContext)
                }
            }
        }
        .background(Color(.systemBackground))
        .accessibilityAction(.escape) {
            viewModel.goTo(.categorySelection)
        }
        .onChange(of: viewModel.currentQuestionIndex) {
            viewModel.updateBookmarkStatus(context: modelContext)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                isQuestionFocused = true
            }
        }
        .onAppear {
            viewModel.updateBookmarkStatus(context: modelContext)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isQuestionFocused = true
            }
        }
        // MARK: 결과 시트
        .sheet(isPresented: $viewModel.showResult) {
            if let question = viewModel.currentQuestion {
                let isOX = question.type == .oxQuestion
                let letter: String = isOX
                    ? (question.isCorrectPairing == true ? "O" : "X")
                    : question.correctItem.letter
                let dotLabel: String = isOX
                    ? (question.isCorrectPairing == true ? "맞는 설명입니다" : "틀린 설명입니다")
                    : question.correctItem.dotLabel

                QuizResultSheet(
                    isCorrect: viewModel.isCurrentAnswerCorrect,
                    correctLetter: letter,
                    correctDotLabel: dotLabel,
                    explanation: question.explanation,
                    isLastQuestion: viewModel.isLastQuestion,
                    onNext: {
                        viewModel.proceedToNext(context: modelContext)
                    }
                )
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
                .interactiveDismissDisabled(false)
            }
        }
    }

    // MARK: - 진행률 바

    private var progressBar: some View {
        HStack {
            Text(viewModel.progress)
                .font(.subheadline.bold())
                .foregroundColor(.appSubColor)

            Spacer()

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 6)

                    Capsule()
                        .fill(Color.appSubColor)
                        .frame(
                            width: geo.size.width * CGFloat(viewModel.currentQuestionIndex + 1) / CGFloat(viewModel.questions.count),
                            height: 6
                        )
                }
            }
            .frame(height: 6)
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
    }

    // MARK: - 북마크 버튼

    private var bookmarkButton: some View {
        HStack {
            Spacer()
            Button {
                viewModel.bookmarkQuestion(context: modelContext)
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: viewModel.isBookmarked ? "bookmark.fill" : "bookmark")
                        .font(.subheadline)
                    Text(viewModel.isBookmarked ? "저장됨" : "저장")
                        .font(.caption.bold())
                }
                .foregroundColor(.appSubColor)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.appSubColor.opacity(0.1))
                .clipShape(Capsule())
            }
            .accessibilityLabel("오답 노트에 저장")
            .accessibilityHint("이 문제를 오답 노트에 저장합니다")
            .accessibilityValue(viewModel.isBookmarked ? "저장됨" : "저장 안 됨")
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 4)
    }
}
