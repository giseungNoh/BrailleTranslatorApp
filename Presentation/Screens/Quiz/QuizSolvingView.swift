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
                //(왼쪽 배치)
                Button {
                    viewModel.goToPreviousQuestion()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                        .foregroundColor(viewModel.isFirstQuestion ? .gray.opacity(0.3) : .appTextColor)
                }
                .disabled(viewModel.isFirstQuestion)
                .accessibilityLabel("이전 문제".toAccessibilityPronunciation())
                .accessibilityHint(viewModel.isFirstQuestion ? "첫 번째 문제입니다" : "이전 문제로 돌아갑니다")

            } trailing: {
                Button {
                    viewModel.goTo(.categorySelection)
                } label: {
                    Image(systemName: "xmark")
                        .font(.title3)
                        .foregroundColor(.appTextColor)
                }
                .accessibilityLabel("퀴즈 그만두기".toAccessibilityPronunciation())
                .accessibilityHint("카테고리 선택으로 돌아갑니다")
            }

            if let question = viewModel.currentQuestion {
                let isOXType = question.type == .oxQuestion

                if !isOXType {
                    // MARK: 객관식 — 진행률 + 문제 텍스트 그룹
                    VStack(spacing: 8) {
                        progressBar
                        Text(question.questionText)
                            .font(.title3.bold())
                            .foregroundColor(.appTextColor)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 8)
                    }
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel("\(viewModel.questions.count)문제 중 \(viewModel.currentQuestionIndex + 1)번째. \(question.questionText)".toAccessibilityPronunciation())
                    .accessibilityHint("화면 중간에 있는 보기를 두손가락으로 스와이프하여 보기를 선택하세요")
                    .accessibilityFocused($isQuestionFocused)
                } else {
                    // MARK: OX — 진행률만 (문제 텍스트는 QuizOXView가 포커스 관리)
                    progressBar
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel("\(viewModel.questions.count)문제 중 \(viewModel.currentQuestionIndex + 1)번째".toAccessibilityPronunciation())
                }

                // MARK: 보기 영역
                switch question.type {
                case .multipleChoice:
                    QuizChoiceExplorerView(viewModel: viewModel)
                case .oxQuestion:
                    QuizOXView(viewModel: viewModel)
                }
            }
        }
        .meshBackground()
        .accessibilityAction(.escape) {
            viewModel.goTo(.categorySelection)
        }
        .onChange(of: viewModel.currentQuestionIndex) {
            // OX 문제는 QuizOXView가 포커스 관리
            guard viewModel.currentQuestion?.type != .oxQuestion else { return }
            isQuestionFocused = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                isQuestionFocused = true
            }
        }
        .onAppear {
            // OX 문제는 QuizOXView.onAppear가 포커스 관리
            guard viewModel.currentQuestion?.type != .oxQuestion else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
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
                    ? (question.isCorrectPairing == true ? "맞는 설명" : "틀린 설명")
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
}
