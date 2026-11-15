import UIKit

final class TopicDetailViewController: UIViewController {

    var viewModel: TopicDetailViewModel!

    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()

    private let chapterHeaderLabel = UILabel()
    private let topicStepLabel = UILabel()
    private let topicProgressBar = UIProgressView(progressViewStyle: .default)
    private let topicTitleLabel = UILabel()
    private let readStatusBadge = UILabel()
    private let explanationCard = UIView()
    private let explanationLabel = UILabel()
    private let codeCard = UIView()
    private let codeLabel = UILabel()
    private let takeawayCard = UIView()
    private let takeawayLabel = UILabel()

    private let navButtonsStack = UIStackView()
    private let previousTopicButton = UIButton(type: .system)
    private let nextTopicButton = UIButton(type: .system)
    private let startQuizButton = UIButton(type: .system)
    private let xpBannerLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        guard viewModel != nil else { return }
        title = "Chapter \(viewModel.module.chapterNumber)"
        navigationItem.largeTitleDisplayMode = .never
        setupUI()
        bindViewModel()
        renderTopic()
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

        chapterHeaderLabel.font = .systemFont(ofSize: 12, weight: .bold)
        chapterHeaderLabel.textColor = AppTheme.slateGray
        chapterHeaderLabel.numberOfLines = 0

        let progressRow = UIStackView(arrangedSubviews: [topicStepLabel, readStatusBadge])
        progressRow.axis = .horizontal
        progressRow.distribution = .equalSpacing

        topicStepLabel.font = .systemFont(ofSize: 13, weight: .heavy)
        topicStepLabel.textColor = AppTheme.jetBlack

        readStatusBadge.font = .systemFont(ofSize: 11, weight: .heavy)
        readStatusBadge.layer.cornerRadius = 6
        readStatusBadge.layer.masksToBounds = true
        readStatusBadge.textAlignment = .center

        topicProgressBar.progressTintColor = AppTheme.studioAmber
        topicProgressBar.trackTintColor = AppTheme.borderGray

        topicTitleLabel.font = .systemFont(ofSize: 24, weight: .heavy)
        topicTitleLabel.textColor = AppTheme.jetBlack
        topicTitleLabel.numberOfLines = 0

        explanationCard.backgroundColor = AppTheme.surfaceGray
        explanationCard.layer.cornerRadius = 16
        explanationCard.layer.borderWidth = 1
        explanationCard.layer.borderColor = AppTheme.borderGray.cgColor

        explanationLabel.translatesAutoresizingMaskIntoConstraints = false
        explanationLabel.font = .systemFont(ofSize: 16, weight: .regular)
        explanationLabel.textColor = AppTheme.jetBlack
        explanationLabel.numberOfLines = 0
        explanationCard.addSubview(explanationLabel)
        NSLayoutConstraint.activate([
            explanationLabel.topAnchor.constraint(equalTo: explanationCard.topAnchor, constant: 16),
            explanationLabel.leadingAnchor.constraint(equalTo: explanationCard.leadingAnchor, constant: 16),
            explanationLabel.trailingAnchor.constraint(equalTo: explanationCard.trailingAnchor, constant: -16),
            explanationLabel.bottomAnchor.constraint(equalTo: explanationCard.bottomAnchor, constant: -16)
        ])

        codeCard.backgroundColor = AppTheme.jetBlack
        codeCard.layer.cornerRadius = 14

        codeLabel.translatesAutoresizingMaskIntoConstraints = false
        codeLabel.font = .monospacedSystemFont(ofSize: 13.5, weight: .medium)
        codeLabel.textColor = AppTheme.studioAmber
        codeLabel.numberOfLines = 0
        codeCard.addSubview(codeLabel)
        NSLayoutConstraint.activate([
            codeLabel.topAnchor.constraint(equalTo: codeCard.topAnchor, constant: 14),
            codeLabel.leadingAnchor.constraint(equalTo: codeCard.leadingAnchor, constant: 14),
            codeLabel.trailingAnchor.constraint(equalTo: codeCard.trailingAnchor, constant: -14),
            codeLabel.bottomAnchor.constraint(equalTo: codeCard.bottomAnchor, constant: -14)
        ])

        takeawayCard.backgroundColor = AppTheme.studioAmberSoft
        takeawayCard.layer.cornerRadius = 14
        takeawayCard.layer.borderWidth = 1.5
        takeawayCard.layer.borderColor = AppTheme.studioAmber.cgColor

        takeawayLabel.translatesAutoresizingMaskIntoConstraints = false
        takeawayLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        takeawayLabel.textColor = AppTheme.jetBlack
        takeawayLabel.numberOfLines = 0
        takeawayCard.addSubview(takeawayLabel)
        NSLayoutConstraint.activate([
            takeawayLabel.topAnchor.constraint(equalTo: takeawayCard.topAnchor, constant: 14),
            takeawayLabel.leadingAnchor.constraint(equalTo: takeawayCard.leadingAnchor, constant: 14),
            takeawayLabel.trailingAnchor.constraint(equalTo: takeawayCard.trailingAnchor, constant: -14),
            takeawayLabel.bottomAnchor.constraint(equalTo: takeawayCard.bottomAnchor, constant: -14)
        ])

        xpBannerLabel.font = .systemFont(ofSize: 14, weight: .bold)
        xpBannerLabel.textColor = AppTheme.jetBlack
        xpBannerLabel.textAlignment = .center
        xpBannerLabel.isHidden = true

        previousTopicButton.setTitle("← Previous", for: .normal)
        previousTopicButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        previousTopicButton.backgroundColor = AppTheme.surfaceGray
        previousTopicButton.setTitleColor(AppTheme.jetBlack, for: .normal)
        previousTopicButton.layer.cornerRadius = 12
        previousTopicButton.layer.borderWidth = 1
        previousTopicButton.layer.borderColor = AppTheme.borderGray.cgColor
        previousTopicButton.heightAnchor.constraint(equalToConstant: 46).isActive = true
        previousTopicButton.addTarget(self, action: #selector(didTapPreviousTopic), for: .touchUpInside)

        nextTopicButton.setTitle("Mark Read & Next →", for: .normal)
        nextTopicButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        nextTopicButton.backgroundColor = AppTheme.studioAmber
        nextTopicButton.setTitleColor(AppTheme.jetBlack, for: .normal)
        nextTopicButton.layer.cornerRadius = 12
        nextTopicButton.heightAnchor.constraint(equalToConstant: 46).isActive = true
        nextTopicButton.addTarget(self, action: #selector(didTapNextTopic), for: .touchUpInside)

        navButtonsStack.axis = .horizontal
        navButtonsStack.spacing = 12
        navButtonsStack.distribution = .fillEqually
        navButtonsStack.addArrangedSubview(previousTopicButton)
        navButtonsStack.addArrangedSubview(nextTopicButton)

        startQuizButton.setTitle("Start Chapter Quiz →", for: .normal)
        startQuizButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .heavy)
        startQuizButton.backgroundColor = AppTheme.jetBlack
        startQuizButton.setTitleColor(AppTheme.backgroundWhite, for: .normal)
        startQuizButton.layer.cornerRadius = 14
        startQuizButton.heightAnchor.constraint(equalToConstant: 52).isActive = true
        startQuizButton.addTarget(self, action: #selector(didTapStartQuiz), for: .touchUpInside)

        contentStack.addArrangedSubview(chapterHeaderLabel)
        contentStack.addArrangedSubview(progressRow)
        contentStack.addArrangedSubview(topicProgressBar)
        contentStack.addArrangedSubview(topicTitleLabel)
        contentStack.addArrangedSubview(explanationCard)
        contentStack.addArrangedSubview(codeCard)
        contentStack.addArrangedSubview(takeawayCard)
        contentStack.addArrangedSubview(xpBannerLabel)
        contentStack.addArrangedSubview(navButtonsStack)
        contentStack.addArrangedSubview(startQuizButton)
    }

    private func bindViewModel() {
        viewModel.onTopicChanged = { [weak self] in
            self?.renderTopic()
        }

        viewModel.onXPAwarded = { [weak self] xp in
            guard let self = self else { return }
            self.xpBannerLabel.text = "+\(xp) XP earned for completing this topic!"
            self.xpBannerLabel.isHidden = false
        }
    }

    private func renderTopic() {
        let topic = viewModel.currentTopic
        chapterHeaderLabel.text = "\(viewModel.module.title.uppercased()) • \(viewModel.module.category.uppercased())"
        topicStepLabel.text = viewModel.topicProgressText
        topicProgressBar.setProgress(viewModel.topicProgressFraction, animated: true)
        topicTitleLabel.text = topic.title
        explanationLabel.text = topic.explanation
        takeawayLabel.text = "KEY TAKEAWAY:\n\(topic.keyTakeaway)"

        if let code = topic.codeExample, !code.isEmpty {
            codeCard.isHidden = false
            codeLabel.text = code
        } else {
            codeCard.isHidden = true
        }

        if viewModel.isCurrentTopicRead {
            readStatusBadge.text = "  ✓ COMPLETED  "
            readStatusBadge.textColor = AppTheme.backgroundWhite
            readStatusBadge.backgroundColor = AppTheme.jetBlack
        } else {
            readStatusBadge.text = "  +15 XP  "
            readStatusBadge.textColor = AppTheme.jetBlack
            readStatusBadge.backgroundColor = AppTheme.studioAmber
        }

        previousTopicButton.isEnabled = viewModel.currentTopicIndex > 0
        previousTopicButton.alpha = previousTopicButton.isEnabled ? 1.0 : 0.4

        let isLast = viewModel.currentTopicIndex == viewModel.topics.count - 1
        nextTopicButton.setTitle(isLast ? "✓ Mark Topic Read" : "Mark Read & Next →", for: .normal)
    }

    @objc private func didTapPreviousTopic() {
        xpBannerLabel.isHidden = true
        viewModel.goToPreviousTopic()
    }

    @objc private func didTapNextTopic() {
        xpBannerLabel.isHidden = true
        _ = viewModel.goToNextTopic()
    }

    @objc private func didTapStartQuiz() {
        viewModel.markCurrentTopicAsRead()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let quizVC = (storyboard.instantiateViewController(withIdentifier: "QuizViewController") as? QuizViewController)
            ?? QuizViewController()
        quizVC.viewModel = QuizViewModel(module: viewModel.module)
        navigationController?.pushViewController(quizVC, animated: true)
    }
}
