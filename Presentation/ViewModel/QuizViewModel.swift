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
    case wrongAnswerOXDetail(String) // O/X 오답 id로 식별

    static func == (lhs: QuizStep, rhs: QuizStep) -> Bool {
        switch (lhs, rhs) {
        case (.categorySelection, .categorySelection),
             (.solving, .solving),
             (.sessionComplete, .sessionComplete),
             (.wrongAnswerList, .wrongAnswerList):
            return true
        case (.wrongAnswerDetail(let a), .wrongAnswerDetail(let b)):
            return a == b
        case (.wrongAnswerOXDetail(let a), .wrongAnswerOXDetail(let b)):
            return a == b
        default:
            return false
        }
    }
}

// MARK: - 세션 결과 (Sendable + Codable)

struct QuizSessionResult: Sendable, Codable {
    let categoryId: String
    let questionText: String
    let correctLetter: String
    let correctDotLabel: String
    let correctRawDots: String?
    let userSelectedLetter: String
    let isCorrect: Bool
    let isOXQuestion: Bool
    let explanation: String?
}

// MARK: - 저장용 세션 데이터

struct SavedQuizSession: Codable {
    let categoryId: String
    let questions: [QuizQuestion]
    let currentQuestionIndex: Int
    let sessionResults: [QuizSessionResult]
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

    private static let sessionKey = "savedQuizSession"

    // MARK: - Computed

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

    var hasActiveSession: Bool {
        currentCategory != nil
        && !questions.isEmpty
        && sessionResults.count < questions.count
    }

    var activeSessionProgress: Double {
        guard !questions.isEmpty else { return 0 }
        return Double(sessionResults.count) / Double(questions.count)
    }

    var isFirstQuestion: Bool {
        currentQuestionIndex == 0
    }

    // MARK: - Init (저장된 세션 복원)

    init() {
        loadSavedSession()
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
        saveSession()
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

        let isOX = question.type == .oxQuestion

        let result = QuizSessionResult(
            categoryId: question.categoryId,
            questionText: question.questionText,
            correctLetter: isOX
                ? (question.isCorrectPairing == true ? "O" : "X")
                : question.correctItem.letter,
            correctDotLabel: isOX ? "" : question.correctItem.dotLabel,
            correctRawDots: isOX ? nil : question.correctItem.rawDots,
            userSelectedLetter: userAnswer,
            isCorrect: isCorrect,
            isOXQuestion: isOX,
            explanation: question.explanation
        )
        sessionResults.append(result)
    }

    func proceedToNext(context: ModelContext) {
        if let lastResult = sessionResults.last {
            if lastResult.isCorrect {
                // 정답 저장 (진행률 추적용)
                let attempt = QuizAttempt(
                    categoryId: lastResult.categoryId,
                    questionText: lastResult.questionText,
                    correctLetter: lastResult.correctLetter,
                    correctDotLabel: lastResult.correctDotLabel,
                    correctRawDots: lastResult.correctRawDots,
                    userSelectedLetter: lastResult.userSelectedLetter,
                    isCorrect: true,
                    isOXQuestion: lastResult.isOXQuestion
                )
                context.insert(attempt)
            } else if lastResult.isOXQuestion {
                // O/X 오답: 같은 문제(questionText) 중복 방지
                let qText = lastResult.questionText
                let descriptor = FetchDescriptor<QuizAttempt>(
                    predicate: #Predicate {
                        $0.questionText == qText
                        && !$0.isCorrect
                        && $0.isOXQuestion == true
                    }
                )
                let existing = (try? context.fetch(descriptor)) ?? []
                if existing.isEmpty {
                    let attempt = QuizAttempt(
                        categoryId: lastResult.categoryId,
                        questionText: lastResult.questionText,
                        correctLetter: lastResult.correctLetter,
                        correctDotLabel: "",
                        correctRawDots: nil,
                        userSelectedLetter: lastResult.userSelectedLetter,
                        isCorrect: false,
                        isOXQuestion: true,
                        explanation: lastResult.explanation
                    )
                    context.insert(attempt)
                }
            } else {
                // 객관식 오답: 같은 글자 중복 방지
                let letter = lastResult.correctLetter
                let descriptor = FetchDescriptor<QuizAttempt>(
                    predicate: #Predicate {
                        $0.correctLetter == letter
                        && !$0.isCorrect
                        && $0.isOXQuestion == false
                        && $0.userSelectedLetter != "북마크"
                    }
                )
                let existing = (try? context.fetch(descriptor)) ?? []
                if existing.isEmpty {
                    let attempt = QuizAttempt(
                        categoryId: lastResult.categoryId,
                        questionText: lastResult.questionText,
                        correctLetter: lastResult.correctLetter,
                        correctDotLabel: lastResult.correctDotLabel,
                        correctRawDots: lastResult.correctRawDots,
                        userSelectedLetter: lastResult.userSelectedLetter,
                        isCorrect: false
                    )
                    context.insert(attempt)
                }
            }
        }

        try? context.save()

        showResult = false
        currentChoiceIndex = 0
        isBookmarked = false

        if isLastQuestion {
            clearSavedSession()
            goTo(.sessionComplete)
        } else {
            currentQuestionIndex += 1
            saveSession()
            UIAccessibility.post(notification: .screenChanged, argument: nil)
        }
    }

    func goToPreviousQuestion() {
        guard currentQuestionIndex > 0 else { return }
        currentQuestionIndex -= 1
        currentChoiceIndex = 0
        showResult = false
        isBookmarked = false
        if !sessionResults.isEmpty {
            sessionResults.removeLast()
        }
        saveSession()
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

    /// 이어풀기
    func resumeQuiz() {
        showResumeAlert = false
        pendingCategory = nil
        goTo(.solving)
    }

    /// 새로 풀기
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
        case .wrongAnswerOXDetail:
            goTo(.wrongAnswerList)
        default:
            break
        }
    }

    /// 기존 중복 오답 정리
    func cleanUpWrongAnswers(context: ModelContext) {
        let descriptor = FetchDescriptor<QuizAttempt>(
            predicate: #Predicate {
                !$0.isCorrect
                && $0.userSelectedLetter != "북마크"
            }
        )
        guard let allWrong = try? context.fetch(descriptor) else { return }

        // 1) 기존 O/X 오답 중 isOXQuestion 미설정 건 삭제 (마이그레이션 정리)
        let legacyOX = allWrong.filter {
            ($0.userSelectedLetter == "O" || $0.userSelectedLetter == "X")
            && !$0.isOXQuestion
        }
        for item in legacyOX {
            context.delete(item)
        }

        // 2) 객관식 중복 제거 (가장 최신만 유지)
        let regular = allWrong.filter { !$0.isOXQuestion && $0.userSelectedLetter != "O" && $0.userSelectedLetter != "X" }
        let grouped = Dictionary(grouping: regular) { $0.correctLetter }
        for (_, items) in grouped where items.count > 1 {
            let sorted = items.sorted { $0.timestamp > $1.timestamp }
            for duplicate in sorted.dropFirst() {
                context.delete(duplicate)
            }
        }

        // 3) O/X 중복 제거 (같은 questionText 최신만 유지)
        let oxItems = allWrong.filter { $0.isOXQuestion }
        let oxGrouped = Dictionary(grouping: oxItems) { $0.questionText }
        for (_, items) in oxGrouped where items.count > 1 {
            let sorted = items.sorted { $0.timestamp > $1.timestamp }
            for duplicate in sorted.dropFirst() {
                context.delete(duplicate)
            }
        }

        try? context.save()
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

    // MARK: - 세션 영구 저장 (UserDefaults)

    private func saveSession() {
        guard let category = currentCategory, !questions.isEmpty else {
            clearSavedSession()
            return
        }
        let session = SavedQuizSession(
            categoryId: category.id,
            questions: questions,
            currentQuestionIndex: currentQuestionIndex,
            sessionResults: sessionResults
        )
        if let data = try? JSONEncoder().encode(session) {
            UserDefaults.standard.set(data, forKey: Self.sessionKey)
        }
    }

    private func clearSavedSession() {
        UserDefaults.standard.removeObject(forKey: Self.sessionKey)
    }

    private func loadSavedSession() {
        guard let data = UserDefaults.standard.data(forKey: Self.sessionKey),
              let saved = try? JSONDecoder().decode(SavedQuizSession.self, from: data),
              let category = quizCategories.first(where: { $0.id == saved.categoryId })
        else { return }

        currentCategory = category
        questions = saved.questions
        currentQuestionIndex = saved.currentQuestionIndex
        sessionResults = saved.sessionResults
    }
}
