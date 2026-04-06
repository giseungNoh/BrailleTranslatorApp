import SwiftUI
import SwiftData
import Combine

// MARK: - 퀴즈 네비게이션 상태

enum QuizStep: Equatable, Sendable {
    case categorySelection
    case solving
    case sessionComplete
    case wrongAnswerList
    case wrongAnswerDetail(String) // correctLetter로 식별

    static func == (lhs: QuizStep, rhs: QuizStep) -> Bool {
        switch (lhs, rhs) {
        case (.categorySelection, .categorySelection),
             (.solving, .solving),
             (.sessionComplete, .sessionComplete),
             (.wrongAnswerList, .wrongAnswerList):
            return true
        case (.wrongAnswerDetail(let a), .wrongAnswerDetail(let b)):
            return a == b
        default:
            return false
        }
    }
}

// MARK: - 세션 결과 (Sendable 경량 구조체)

struct QuizSessionResult: Sendable {
    let categoryId: String
    let questionText: String
    let correctLetter: String
    let correctDotLabel: String
    let correctRawDots: String?
    let userSelectedLetter: String
    let isCorrect: Bool
}

// MARK: - ViewModel

@MainActor
class QuizViewModel: ObservableObject {

    // MARK: 네비게이션
    @Published var currentStep: QuizStep = .categorySelection

    // MARK: 퀴즈 세션
    @Published var currentCategory: QuizCategory?
    @Published var questions: [QuizQuestion] = []
    @Published var currentQuestionIndex: Int = 0
    @Published var currentChoiceIndex: Int = 0
    @Published var showResult: Bool = false
    @Published var isCurrentAnswerCorrect: Bool = false
    @Published var sessionResults: [QuizSessionResult] = []
    @Published var isBookmarked: Bool = false

    // MARK: 이어풀기 Alert
    @Published var showResumeAlert: Bool = false
    @Published var pendingCategory: QuizCategory?

    var currentQuestion: QuizQuestion? {
        guard currentQuestionIndex < questions.count else { return nil }
        return questions[currentQuestionIndex]
    }

    var progress: String {
        "\(currentQuestionIndex + 1) / \(questions.count)"
    }

    var correctCount: Int {
        sessionResults.filter { $0.isCorrect }.count
    }

    var isLastQuestion: Bool {
        currentQuestionIndex >= questions.count - 1
    }

    var isFirstQuestion: Bool {
        currentQuestionIndex == 0
    }

    // MARK: - Actions

    func startQuiz(category: QuizCategory) {
        currentCategory = category
        questions = QuizGenerator.generateQuestions(for: category)
        currentQuestionIndex = 0
        currentChoiceIndex = 0
        sessionResults = []
        showResult = false
        isBookmarked = false
        goTo(.solving)
    }

    func selectCurrentChoice() {
        guard let question = currentQuestion else { return }
        let selectedItem = question.choices[currentChoiceIndex]
        let correct = selectedItem.letter == question.correctItem.letter

        recordAnswer(question: question, isCorrect: correct, userAnswer: selectedItem.letter)
    }

    func selectOX(_ answer: Bool) {
        guard let question = currentQuestion,
              let isCorrectPairing = question.isCorrectPairing else { return }
        let correct = (answer == isCorrectPairing)

        recordAnswer(question: question, isCorrect: correct, userAnswer: answer ? "O" : "X")
    }

    private func recordAnswer(question: QuizQuestion, isCorrect: Bool, userAnswer: String) {
        isCurrentAnswerCorrect = isCorrect
        showResult = true

        if isCorrect {
            HapticManager.shared.playHeavyDotFeedback()
        } else {
            HapticManager.shared.playSharpBorderFeedback()
        }

        let result = QuizSessionResult(
            categoryId: question.categoryId,
            questionText: question.questionText,
            correctLetter: question.correctItem.letter,
            correctDotLabel: question.correctItem.dotLabel,
            correctRawDots: question.correctItem.rawDots,
            userSelectedLetter: userAnswer,
            isCorrect: isCorrect
        )
        sessionResults.append(result)
    }

    func proceedToNext(context: ModelContext) {
        // 정답/오답 모두 SwiftData에 저장
        if let lastResult = sessionResults.last {
            let attempt = QuizAttempt(
                categoryId: lastResult.categoryId,
                questionText: lastResult.questionText,
                correctLetter: lastResult.correctLetter,
                correctDotLabel: lastResult.correctDotLabel,
                correctRawDots: lastResult.correctRawDots,
                userSelectedLetter: lastResult.userSelectedLetter,
                isCorrect: lastResult.isCorrect
            )
            context.insert(attempt)
        }

        showResult = false
        currentChoiceIndex = 0
        isBookmarked = false

        if isLastQuestion {
            try? context.save()
            goTo(.sessionComplete)
        } else {
            currentQuestionIndex += 1
            UIAccessibility.post(notification: .screenChanged, argument: nil)
        }
    }

    func goToPreviousQuestion() {
        guard currentQuestionIndex > 0 else { return }
        currentQuestionIndex -= 1
        currentChoiceIndex = 0
        showResult = false
        isBookmarked = false
        // 이전 문제 결과도 제거 (다시 풀 수 있도록)
        if !sessionResults.isEmpty {
            sessionResults.removeLast()
        }
        UIAccessibility.post(notification: .screenChanged, argument: nil)
    }

    /// 현재 문제의 북마크 상태를 SwiftData에서 확인하여 UI 동기화
    func updateBookmarkStatus(context: ModelContext) {
        guard let question = currentQuestion else {
            isBookmarked = false
            return
        }
        let letter = question.correctItem.letter
        let descriptor = FetchDescriptor<QuizAttempt>(
            predicate: #Predicate { $0.correctLetter == letter && $0.userSelectedLetter == "북마크" }
        )
        isBookmarked = ((try? context.fetch(descriptor))?.isEmpty == false)
    }

    func bookmarkQuestion(context: ModelContext) {
        guard let question = currentQuestion else { return }

        if isBookmarked {
            // 저장 해제 — SwiftData에서 해당 북마크 삭제
            let letter = question.correctItem.letter
            let descriptor = FetchDescriptor<QuizAttempt>(
                predicate: #Predicate { $0.correctLetter == letter && $0.userSelectedLetter == "북마크" }
            )
            if let existing = try? context.fetch(descriptor) {
                for item in existing {
                    context.delete(item)
                }
            }
            try? context.save()
            isBookmarked = false
            return
        }

        isBookmarked = true

        let attempt = QuizAttempt(
            categoryId: question.categoryId,
            questionText: question.questionText,
            correctLetter: question.correctItem.letter,
            correctDotLabel: question.correctItem.dotLabel,
            correctRawDots: question.correctItem.rawDots,
            userSelectedLetter: "북마크",
            isCorrect: false
        )
        context.insert(attempt)
        try? context.save()
    }

    /// 카테고리 탭 — 진행 중인 세션이 있으면 이어풀기 Alert 표시
    func handleCategoryTap(category: QuizCategory) {
        // 같은 카테고리에 아직 완료하지 않은 세션이 남아있는지 확인
        if let current = currentCategory,
           current.id == category.id,
           !questions.isEmpty,
           sessionResults.count < questions.count {
            pendingCategory = category
            showResumeAlert = true
        } else {
            startQuiz(category: category)
        }
    }

    /// 이어풀기 — 기존 세션 이어서 풀기
    func resumeQuiz() {
        showResumeAlert = false
        pendingCategory = nil
        goTo(.solving)
    }

    /// 새로 풀기 — 기존 세션 버리고 새로 시작
    func restartPendingCategory() {
        showResumeAlert = false
        if let category = pendingCategory {
            pendingCategory = nil
            startQuiz(category: category)
        }
    }

    func retryCategory() {
        guard let category = currentCategory else { return }
        startQuiz(category: category)
    }

    func goBack() {
        switch currentStep {
        case .solving:
            goTo(.categorySelection)
        case .sessionComplete:
            goTo(.categorySelection)
        case .wrongAnswerList:
            goTo(.categorySelection)
        case .wrongAnswerDetail:
            goTo(.wrongAnswerList)
        default:
            break
        }
    }

    func goTo(_ step: QuizStep) {
        var transaction = Transaction(animation: .easeInOut(duration: 0.25))
        transaction.disablesAnimations = false
        withTransaction(transaction) {
            currentStep = step
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            UIAccessibility.post(notification: .screenChanged, argument: nil)
        }
    }
}
