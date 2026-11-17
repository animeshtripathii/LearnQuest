import UIKit

final class QuizViewController: UIViewController {

    var viewModel: QuizViewModel!

    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()

    private let questionCounterLabel = UILabel()
    private let progressBar = UIProgressView(progressViewStyle: .default)
    private let questionCard = UIView()
    private let questionLabel = UILabel()
    private let optionsStack = UIStackView()
    private var optionButtons: [UIButton] = []

    private let feedbackCard = UIView()
    private let feedbackLabel = UILabel()
    private let nextButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        guard viewModel != nil else { return }
        title = "Chapter \(viewModel.module.chapterNumber) Quiz"
        navigationItem.largeTitleDisplayMode = .never
        setupUI()
        renderQuestion()
    }

    private func setupUI() {
        view.backgroundColor = AppTheme.backgroundWhite

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.axis = .vertical
        contentStack.spacing = 16

        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -24),
            contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)
        ])

        questionCounterLabel.font = .systemFont(ofSize: 13, weight: .heavy)
        questionCounterLabel.textColor = AppTheme.slateGray

        progressBar.progressTintColor = AppTheme.studioAmber
        progressBar.trackTintColor = AppTheme.borderGray

        questionCard.backgroundColor = AppTheme.jetBlack
        questionCard.layer.cornerRadius = 18

        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        questionLabel.font = .systemFont(ofSize: 19, weight: .bold)
        questionLabel.textColor = AppTheme.backgroundWhite
        questionLabel.numberOfLines = 0
        questionCard.addSubview(questionLabel)

        NSLayoutConstraint.activate([
            questionLabel.topAnchor.constraint(equalTo: questionCard.topAnchor, constant: 18),
            questionLabel.leadingAnchor.constraint(equalTo: questionCard.leadingAnchor, constant: 16),
            questionLabel.trailingAnchor.constraint(equalTo: questionCard.trailingAnchor, constant: -16),
            questionLabel.bottomAnchor.constraint(equalTo: questionCard.bottomAnchor, constant: -18)
        ])

        optionsStack.axis = .vertical
        optionsStack.spacing = 12

        feedbackCard.backgroundColor = AppTheme.surfaceGray
        feedbackCard.layer.cornerRadius = 14
        feedbackCard.layer.borderWidth = 1.5
        feedbackCard.isHidden = true

        feedbackLabel.translatesAutoresizingMaskIntoConstraints = false
        feedbackLabel.font = .systemFont(ofSize: 14.5, weight: .medium)
        feedbackLabel.textColor = AppTheme.jetBlack
        feedbackLabel.numberOfLines = 0
        feedbackCard.addSubview(feedbackLabel)

        NSLayoutConstraint.activate([
            feedbackLabel.topAnchor.constraint(equalTo: feedbackCard.topAnchor, constant: 14),
            feedbackLabel.leadingAnchor.constraint(equalTo: feedbackCard.leadingAnchor, constant: 14),
            feedbackLabel.trailingAnchor.constraint(equalTo: feedbackCard.trailingAnchor, constant: -14),
            feedbackLabel.bottomAnchor.constraint(equalTo: feedbackCard.bottomAnchor, constant: -14)
        ])

        nextButton.setTitle("Next Question →", for: .normal)
        nextButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .heavy)
        nextButton.backgroundColor = AppTheme.studioAmber
        nextButton.setTitleColor(AppTheme.jetBlack, for: .normal)
        nextButton.layer.cornerRadius = 14
        nextButton.heightAnchor.constraint(equalToConstant: 52).isActive = true
        nextButton.isHidden = true
        nextButton.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)

        contentStack.addArrangedSubview(questionCounterLabel)
        contentStack.addArrangedSubview(progressBar)
        contentStack.addArrangedSubview(questionCard)
        contentStack.addArrangedSubview(optionsStack)
        contentStack.addArrangedSubview(feedbackCard)
        contentStack.addArrangedSubview(nextButton)
    }

    private func renderQuestion() {
        let question = viewModel.currentQuestion
        questionCounterLabel.text = "\(viewModel.progressText) • +\(question.points) XP"
        progressBar.setProgress(viewModel.progressFraction, animated: true)
        questionLabel.text = question.question

        feedbackCard.isHidden = true
        nextButton.isHidden = true
        nextButton.setTitle(viewModel.isLastQuestion ? "Finish Quiz & Claim XP →" : "Next Question →", for: .normal)

        optionsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        optionButtons.removeAll()

        let letters = ["A", "B", "C", "D"]
        for (index, optionText) in question.options.enumerated() {
            let button = UIButton(type: .system)
            let prefix = index < letters.count ? letters[index] : "\(index + 1)"
            button.setTitle("  \(prefix).  \(optionText)", for: .normal)
            button.contentHorizontalAlignment = .left
            button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
            button.titleLabel?.numberOfLines = 0
            button.setTitleColor(AppTheme.jetBlack, for: .normal)
            button.backgroundColor = AppTheme.surfaceGray
            button.layer.cornerRadius = 14
            button.layer.borderWidth = 1.2
            button.layer.borderColor = AppTheme.borderGray.cgColor
            button.contentEdgeInsets = UIEdgeInsets(top: 14, left: 14, bottom: 14, right: 14)
            button.tag = index
            button.addTarget(self, action: #selector(didTapOption(_:)), for: .touchUpInside)
            optionsStack.addArrangedSubview(button)
            optionButtons.append(button)
        }
    }

    @objc private func didTapOption(_ sender: UIButton) {
        let selectedIndex = sender.tag
        guard !viewModel.isAnswerSubmitted else { return }

        let isCorrect = viewModel.submitAnswer(optionIndex: selectedIndex)
        let correctIndex = viewModel.currentQuestion.correctOptionIndex

        for (index, button) in optionButtons.enumerated() {
            button.isUserInteractionEnabled = false
            if index == correctIndex {
                button.backgroundColor = AppTheme.studioAmberSoft
                button.layer.borderColor = AppTheme.correctGreen.cgColor
                button.setTitleColor(AppTheme.jetBlack, for: .normal)
            } else if index == selectedIndex && !isCorrect {
                button.backgroundColor = AppTheme.incorrectRed.withAlphaComponent(0.12)
                button.layer.borderColor = AppTheme.incorrectRed.cgColor
                button.setTitleColor(AppTheme.incorrectRed, for: .normal)
            }
        }

        let header = isCorrect ? "✓ CORRECT! (+\(viewModel.currentQuestion.points) XP)" : "✕ INCORRECT"
        feedbackLabel.text = "\(header)\n\n\(viewModel.currentQuestion.explanation)"
        feedbackCard.layer.borderColor = isCorrect ? AppTheme.correctGreen.cgColor : AppTheme.incorrectRed.cgColor
        feedbackCard.isHidden = false
        nextButton.isHidden = false
    }

    @objc private func didTapNextButton() {
        if viewModel.advanceToNextQuestion() {
            renderQuestion()
        } else {
            presentQuizSummary()
        }
    }

    private func presentQuizSummary() {
        let result = viewModel.finalizeQuiz()
        let titleText = result.passed ? "Chapter Completed!" : "Keep Practicing!"

        var message = "Score: \(result.correctAnswers)/\(result.totalQuestions) (\(result.scorePercentage)%)\n"
        message += "XP Earned: +\(result.xpEarned) XP\n"

        if !result.newlyUnlockedBadges.isEmpty {
            let badgeNames = result.newlyUnlockedBadges.map { "• \($0.title)" }.joined(separator: "\n")
            message += "\nNew Badges Unlocked:\n\(badgeNames)"
        }

        let alert = UIAlertController(title: titleText, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Retry Quiz", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.viewModel = QuizViewModel(module: self.viewModel.module)
            self.renderQuestion()
        })
        alert.addAction(UIAlertAction(title: "Back to Dashboard", style: .cancel) { [weak self] _ in
            self?.navigationController?.popToRootViewController(animated: true)
        })
        present(alert, animated: true)
    }
}
