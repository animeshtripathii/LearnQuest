import Foundation

struct QuizCompletionResult {
    let correctAnswers: Int
    let totalQuestions: Int
    let scorePercentage: Int
    let xpEarned: Int
    let passed: Bool
    let newlyUnlockedBadges: [Badge]
}

final class QuizViewModel {

    let module: LearningModule
    private let storageService: LocalStorageServiceProtocol

    private(set) var currentQuestionIndex: Int = 0
    private(set) var selectedOptionIndex: Int? = nil
    private(set) var isAnswerSubmitted: Bool = false
    private(set) var correctAnswersCount: Int = 0
    private(set) var earnedQuestionPoints: Int = 0

    init(
        module: LearningModule,
        storageService: LocalStorageServiceProtocol = LocalStorageService.shared
    ) {
        self.module = module
        self.storageService = storageService
    }

    var questions: [QuizQuestion] {
        return module.quiz
    }

    var currentQuestion: QuizQuestion {
        return module.quiz[currentQuestionIndex]
    }

    var progressText: String {
        return "QUESTION \(currentQuestionIndex + 1) OF \(questions.count)"
    }

    var progressFraction: Float {
        guard !questions.isEmpty else { return 1.0 }
        return Float(currentQuestionIndex + 1) / Float(questions.count)
    }

    var isLastQuestion: Bool {
        return currentQuestionIndex == questions.count - 1
    }

    func submitAnswer(optionIndex: Int) -> Bool {
        guard !isAnswerSubmitted else { return false }
        selectedOptionIndex = optionIndex
        isAnswerSubmitted = true

        let isCorrect = (optionIndex == currentQuestion.correctOptionIndex)
        if isCorrect {
            correctAnswersCount += 1
            earnedQuestionPoints += currentQuestion.points
        }
        return isCorrect
    }

    func advanceToNextQuestion() -> Bool {
        guard currentQuestionIndex + 1 < questions.count else {
            return false
        }
        currentQuestionIndex += 1
        selectedOptionIndex = nil
        isAnswerSubmitted = false
        return true
    }

    func finalizeQuiz() -> QuizCompletionResult {
        let total = max(1, questions.count)
        let percentage = Int(round((Double(correctAnswersCount) / Double(total)) * 100.0))
        let passed = percentage >= 60

        var progress = storageService.loadUserProgress()
        progress.quizzesTakenCount += 1

        let previousBest = progress.moduleHighScores[module.id] ?? 0
        var xpAwarded = earnedQuestionPoints

        if passed && !progress.completedModuleIDs.contains(module.id) {
            progress.completedModuleIDs.insert(module.id)
            xpAwarded += module.xpReward
        } else if percentage > previousBest {
            xpAwarded += 25
        }

        if percentage > previousBest {
            progress.moduleHighScores[module.id] = percentage
        }

        progress.totalXP += xpAwarded
        let unlockedBadges = BadgesViewModel.evaluateBadges(for: &progress, totalModulesCount: 6)
        storageService.saveUserProgress(progress)

        return QuizCompletionResult(
            correctAnswers: correctAnswersCount,
            totalQuestions: questions.count,
            scorePercentage: percentage,
            xpEarned: xpAwarded,
            passed: passed,
            newlyUnlockedBadges: unlockedBadges
        )
    }
}
