import SwiftUI

/// 퀴즈 탭 루트 — State enum 기반 네비게이션
struct QuizView: View {
    var selectedTab: Int = 2

    @StateObject private var viewModel = QuizViewModel()
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        Group {
            switch viewModel.currentStep {
            case .categorySelection:
                QuizCategoryListView(viewModel: viewModel, selectedTab: selectedTab)

            case .solving:
                QuizSolvingView(viewModel: viewModel)

            case .sessionComplete:
                QuizSessionCompleteView(viewModel: viewModel)

            case .wrongAnswerList:
                WrongAnswerListView(viewModel: viewModel)

            case .wrongAnswerDetail(let letter):
                WrongAnswerDetailView(viewModel: viewModel, correctLetter: letter)

            case .wrongAnswerOXDetail(let attemptId):
                WrongAnswerOXDetailView(viewModel: viewModel, attemptId: attemptId)
            }
        }
        .accessibilityAction(.escape) {
            viewModel.goBack()
        }
        .alert("이어서 풀기", isPresented: $viewModel.showResumeAlert) {
            Button("이어서 풀기") {
                viewModel.resumeQuiz()
            }
            Button("처음부터", role: .destructive) {
                viewModel.restartPendingCategory()
            }
            Button("취소", role: .cancel) {
                viewModel.showResumeAlert = false
                viewModel.pendingCategory = nil
            }
        } message: {
            Text("풀던 문제가 있습니다. 이어서 푸시겠습니까?")
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("ResetQuizTab"))) { _ in
            viewModel.goTo(.categorySelection)
        }
    }
}

#Preview {
    QuizView()
}
