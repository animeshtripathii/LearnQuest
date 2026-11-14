import UIKit

final class ModuleTableViewCell: UITableViewCell {

    static let reuseIdentifier = "ModuleTableViewCell"

    private let cardView = UIView()
    private let chapterBadgeLabel = UILabel()
    private let statusIconView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let metadataStack = UIStackView()
    private let categoryPill = UILabel()
    private let xpPill = UILabel()
    private let scorePill = UILabel()
    private let topicProgressView = UIProgressView(progressViewStyle: .default)
    private let topicProgressLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayout()
    }

    private func setupLayout() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.backgroundColor = AppTheme.surfaceGray
        cardView.layer.cornerRadius = 18
        cardView.layer.borderWidth = 1.2
        cardView.layer.borderColor = AppTheme.borderGray.cgColor
        contentView.addSubview(cardView)

        chapterBadgeLabel.translatesAutoresizingMaskIntoConstraints = false
        chapterBadgeLabel.font = .systemFont(ofSize: 11, weight: .heavy)
        chapterBadgeLabel.textColor = AppTheme.backgroundWhite
        chapterBadgeLabel.backgroundColor = AppTheme.jetBlack
        chapterBadgeLabel.textAlignment = .center
        chapterBadgeLabel.layer.cornerRadius = 8
        chapterBadgeLabel.layer.masksToBounds = true

        statusIconView.translatesAutoresizingMaskIntoConstraints = false
        statusIconView.contentMode = .scaleAspectFit

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        titleLabel.textColor = AppTheme.jetBlack
        titleLabel.numberOfLines = 2

        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        subtitleLabel.textColor = AppTheme.slateGray
        subtitleLabel.numberOfLines = 2

        stylePill(categoryPill, textColor: AppTheme.slateGray, bgColor: AppTheme.backgroundWhite)
        stylePill(xpPill, textColor: AppTheme.jetBlack, bgColor: AppTheme.studioAmber)
        stylePill(scorePill, textColor: AppTheme.backgroundWhite, bgColor: AppTheme.jetBlack)

        metadataStack.translatesAutoresizingMaskIntoConstraints = false
        metadataStack.axis = .horizontal
        metadataStack.spacing = 8
        metadataStack.alignment = .center
        metadataStack.addArrangedSubview(categoryPill)
        metadataStack.addArrangedSubview(xpPill)
        metadataStack.addArrangedSubview(scorePill)

        topicProgressView.translatesAutoresizingMaskIntoConstraints = false
        topicProgressView.trackTintColor = AppTheme.borderGray
        topicProgressView.progressTintColor = AppTheme.studioAmber
        topicProgressView.layer.cornerRadius = 3
        topicProgressView.clipsToBounds = true

        topicProgressLabel.translatesAutoresizingMaskIntoConstraints = false
        topicProgressLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        topicProgressLabel.textColor = AppTheme.slateGray

        cardView.addSubview(chapterBadgeLabel)
        cardView.addSubview(statusIconView)
        cardView.addSubview(titleLabel)
        cardView.addSubview(subtitleLabel)
        cardView.addSubview(metadataStack)
        cardView.addSubview(topicProgressView)
        cardView.addSubview(topicProgressLabel)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            chapterBadgeLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 14),
            chapterBadgeLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            chapterBadgeLabel.widthAnchor.constraint(equalToConstant: 92),
            chapterBadgeLabel.heightAnchor.constraint(equalToConstant: 24),

            statusIconView.centerYAnchor.constraint(equalTo: chapterBadgeLabel.centerYAnchor),
            statusIconView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            statusIconView.widthAnchor.constraint(equalToConstant: 24),
            statusIconView.heightAnchor.constraint(equalToConstant: 24),

            titleLabel.topAnchor.constraint(equalTo: chapterBadgeLabel.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            subtitleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),

            metadataStack.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 12),
            metadataStack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            metadataStack.trailingAnchor.constraint(lessThanOrEqualTo: cardView.trailingAnchor, constant: -16),

            topicProgressView.topAnchor.constraint(equalTo: metadataStack.bottomAnchor, constant: 12),
            topicProgressView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            topicProgressView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            topicProgressView.heightAnchor.constraint(equalToConstant: 6),

            topicProgressLabel.topAnchor.constraint(equalTo: topicProgressView.bottomAnchor, constant: 6),
            topicProgressLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            topicProgressLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            topicProgressLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -14)
        ])
    }

    private func stylePill(_ label: UILabel, textColor: UIColor, bgColor: UIColor) {
        label.font = .systemFont(ofSize: 11, weight: .bold)
        label.textColor = textColor
        label.backgroundColor = bgColor
        label.layer.cornerRadius = 6
        label.layer.masksToBounds = true
        label.textAlignment = .center
    }

    func configure(
        with module: LearningModule,
        isCompleted: Bool,
        highScore: Int?,
        readTopicsCount: Int
    ) {
        chapterBadgeLabel.text = "CHAPTER \(module.chapterNumber)"
        titleLabel.text = module.title
        subtitleLabel.text = module.subtitle

        categoryPill.text = "  \(module.category) • \(module.difficulty)  "
        xpPill.text = "  +\(module.xpReward) XP  "

        if let score = highScore {
            scorePill.isHidden = false
            scorePill.text = "  QUIZ: \(score)%  "
        } else {
            scorePill.isHidden = true
        }

        if isCompleted {
            statusIconView.image = UIImage(systemName: "checkmark.seal.fill")
            statusIconView.tintColor = AppTheme.jetBlack
            cardView.layer.borderColor = AppTheme.studioAmber.cgColor
            cardView.layer.borderWidth = 2.0
        } else {
            statusIconView.image = UIImage(systemName: "chevron.right.circle.fill")
            statusIconView.tintColor = AppTheme.slateGray
            cardView.layer.borderColor = AppTheme.borderGray.cgColor
            cardView.layer.borderWidth = 1.2
        }

        let totalTopics = max(1, module.topics.count)
        let fraction = Float(readTopicsCount) / Float(totalTopics)
        topicProgressView.progress = fraction
        topicProgressLabel.text = "\(readTopicsCount)/\(module.topics.count) topics read • \(module.quiz.count) MCQs • ~\(module.estimatedMinutes) min"
    }
}
