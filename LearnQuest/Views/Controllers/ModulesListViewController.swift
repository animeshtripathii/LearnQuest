import UIKit

final class ModulesListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private let viewModel = ModulesViewModel()
    private let refreshControl = UIRefreshControl()

    // Gamification & Landing Badge Showcase Header
    private let dashboardCard = UIView()
    private let welcomeUserLabel = UILabel()
    private let levelBadgeLabel = UILabel()
    private let xpValueLabel = UILabel()
    private let levelProgressView = UIProgressView(progressViewStyle: .default)
    private let syllabusStatusLabel = UILabel()

    private let landingBadgesSectionTitle = UILabel()
    private let viewAllBadgesButton = UIButton(type: .system)
    private let badgesScrollView = UIScrollView()
    private let badgesHorizontalStack = UIStackView()

    private let filterSegmentedControl = UISegmentedControl(items: ["All Chapters", "In Progress", "Completed"])

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupUI()
        bindViewModel()
        viewModel.fetchModules()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigation()
        viewModel.reloadProgress()
    }

    private func setupNavigation() {
        title = "LearnQuest"
        navigationController?.navigationBar.prefersLargeTitles = true

        let authTitle = viewModel.isLoggedIn ? "Logout" : "Login"
        let loginBarButton = UIBarButtonItem(
            title: authTitle,
            style: .plain,
            target: self,
            action: #selector(didTapAuthButton)
        )
        loginBarButton.tintColor = AppTheme.slateGray

        let badgesButton = UIBarButtonItem(
            image: UIImage(systemName: "rosette"),
            style: .plain,
            target: self,
            action: #selector(didTapBadgesButton)
        )
        badgesButton.tintColor = AppTheme.jetBlack
        badgesButton.accessibilityLabel = "Achievement Badges"

        navigationItem.leftBarButtonItem = loginBarButton
        navigationItem.rightBarButtonItem = badgesButton
    }

    private func setupUI() {
        view.backgroundColor = AppTheme.backgroundWhite

        if tableView == nil {
            let tv = UITableView(frame: .zero, style: .plain)
            tv.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(tv)
            NSLayoutConstraint.activate([
                tv.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                tv.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                tv.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                tv.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
            self.tableView = tv
        }

        tableView.backgroundColor = AppTheme.backgroundWhite
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 165
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ModuleTableViewCell.self, forCellReuseIdentifier: ModuleTableViewCell.reuseIdentifier)

        refreshControl.addTarget(self, action: #selector(handlePullToRefresh), for: .valueChanged)
        refreshControl.tintColor = AppTheme.jetBlack
        tableView.refreshControl = refreshControl

        tableView.tableHeaderView = buildHeaderContainerView()
    }

    private func buildHeaderContainerView() -> UIView {
        let headerContainer = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 325))
        headerContainer.backgroundColor = AppTheme.backgroundWhite

        // 1. Jet Black & Studio Amber XP Dashboard Card
        dashboardCard.translatesAutoresizingMaskIntoConstraints = false
        dashboardCard.backgroundColor = AppTheme.jetBlack
        dashboardCard.layer.cornerRadius = 20
        headerContainer.addSubview(dashboardCard)

        welcomeUserLabel.translatesAutoresizingMaskIntoConstraints = false
        welcomeUserLabel.font = .systemFont(ofSize: 11.5, weight: .bold)
        welcomeUserLabel.textColor = AppTheme.studioAmber

        levelBadgeLabel.translatesAutoresizingMaskIntoConstraints = false
        levelBadgeLabel.font = .systemFont(ofSize: 18, weight: .heavy)
        levelBadgeLabel.textColor = AppTheme.backgroundWhite

        xpValueLabel.translatesAutoresizingMaskIntoConstraints = false
        xpValueLabel.font = .systemFont(ofSize: 20, weight: .heavy)
        xpValueLabel.textColor = AppTheme.studioAmber
        xpValueLabel.textAlignment = .right

        levelProgressView.translatesAutoresizingMaskIntoConstraints = false
        levelProgressView.progressTintColor = AppTheme.studioAmber
        levelProgressView.trackTintColor = UIColor.white.withAlphaComponent(0.2)
        levelProgressView.layer.cornerRadius = 4
        levelProgressView.clipsToBounds = true

        syllabusStatusLabel.translatesAutoresizingMaskIntoConstraints = false
        syllabusStatusLabel.font = .systemFont(ofSize: 12.5, weight: .medium)
        syllabusStatusLabel.textColor = AppTheme.borderGray

        dashboardCard.addSubview(welcomeUserLabel)
        dashboardCard.addSubview(levelBadgeLabel)
        dashboardCard.addSubview(xpValueLabel)
        dashboardCard.addSubview(levelProgressView)
        dashboardCard.addSubview(syllabusStatusLabel)

        // 2. Landing Badges Showcase Bar
        landingBadgesSectionTitle.translatesAutoresizingMaskIntoConstraints = false
        landingBadgesSectionTitle.text = "LANDING & SYLLABUS BADGES"
        landingBadgesSectionTitle.font = .systemFont(ofSize: 12, weight: .heavy)
        landingBadgesSectionTitle.textColor = AppTheme.slateGray

        viewAllBadgesButton.translatesAutoresizingMaskIntoConstraints = false
        viewAllBadgesButton.setTitle("See All →", for: .normal)
        viewAllBadgesButton.titleLabel?.font = .systemFont(ofSize: 12.5, weight: .bold)
        viewAllBadgesButton.setTitleColor(AppTheme.jetBlack, for: .normal)
        viewAllBadgesButton.addTarget(self, action: #selector(didTapBadgesButton), for: .touchUpInside)

        badgesScrollView.translatesAutoresizingMaskIntoConstraints = false
        badgesScrollView.showsHorizontalScrollIndicator = false

        badgesHorizontalStack.translatesAutoresizingMaskIntoConstraints = false
        badgesHorizontalStack.axis = .horizontal
        badgesHorizontalStack.spacing = 10
        badgesScrollView.addSubview(badgesHorizontalStack)

        headerContainer.addSubview(landingBadgesSectionTitle)
        headerContainer.addSubview(viewAllBadgesButton)
        headerContainer.addSubview(badgesScrollView)

        // 3. Filter Segmented Control
        filterSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        filterSegmentedControl.selectedSegmentIndex = 0
        filterSegmentedControl.addTarget(self, action: #selector(filterChanged(_:)), for: .valueChanged)
        headerContainer.addSubview(filterSegmentedControl)

        NSLayoutConstraint.activate([
            dashboardCard.topAnchor.constraint(equalTo: headerContainer.topAnchor, constant: 10),
            dashboardCard.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor, constant: 16),
            dashboardCard.trailingAnchor.constraint(equalTo: headerContainer.trailingAnchor, constant: -16),
            dashboardCard.heightAnchor.constraint(equalToConstant: 126),

            welcomeUserLabel.topAnchor.constraint(equalTo: dashboardCard.topAnchor, constant: 14),
            welcomeUserLabel.leadingAnchor.constraint(equalTo: dashboardCard.leadingAnchor, constant: 16),

            levelBadgeLabel.topAnchor.constraint(equalTo: welcomeUserLabel.bottomAnchor, constant: 4),
            levelBadgeLabel.leadingAnchor.constraint(equalTo: dashboardCard.leadingAnchor, constant: 16),

            xpValueLabel.centerYAnchor.constraint(equalTo: levelBadgeLabel.centerYAnchor),
            xpValueLabel.trailingAnchor.constraint(equalTo: dashboardCard.trailingAnchor, constant: -16),

            levelProgressView.topAnchor.constraint(equalTo: levelBadgeLabel.bottomAnchor, constant: 12),
            levelProgressView.leadingAnchor.constraint(equalTo: dashboardCard.leadingAnchor, constant: 16),
            levelProgressView.trailingAnchor.constraint(equalTo: dashboardCard.trailingAnchor, constant: -16),
            levelProgressView.heightAnchor.constraint(equalToConstant: 8),

            syllabusStatusLabel.topAnchor.constraint(equalTo: levelProgressView.bottomAnchor, constant: 10),
            syllabusStatusLabel.leadingAnchor.constraint(equalTo: dashboardCard.leadingAnchor, constant: 16),
            syllabusStatusLabel.trailingAnchor.constraint(equalTo: dashboardCard.trailingAnchor, constant: -16),

            landingBadgesSectionTitle.topAnchor.constraint(equalTo: dashboardCard.bottomAnchor, constant: 14),
            landingBadgesSectionTitle.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor, constant: 16),

            viewAllBadgesButton.centerYAnchor.constraint(equalTo: landingBadgesSectionTitle.centerYAnchor),
            viewAllBadgesButton.trailingAnchor.constraint(equalTo: headerContainer.trailingAnchor, constant: -16),

            badgesScrollView.topAnchor.constraint(equalTo: landingBadgesSectionTitle.bottomAnchor, constant: 8),
            badgesScrollView.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor, constant: 16),
            badgesScrollView.trailingAnchor.constraint(equalTo: headerContainer.trailingAnchor, constant: -16),
            badgesScrollView.heightAnchor.constraint(equalToConstant: 78),

            badgesHorizontalStack.topAnchor.constraint(equalTo: badgesScrollView.topAnchor),
            badgesHorizontalStack.leadingAnchor.constraint(equalTo: badgesScrollView.leadingAnchor),
            badgesHorizontalStack.trailingAnchor.constraint(equalTo: badgesScrollView.trailingAnchor),
            badgesHorizontalStack.bottomAnchor.constraint(equalTo: badgesScrollView.bottomAnchor),
            badgesHorizontalStack.heightAnchor.constraint(equalTo: badgesScrollView.heightAnchor),

            filterSegmentedControl.topAnchor.constraint(equalTo: badgesScrollView.bottomAnchor, constant: 14),
            filterSegmentedControl.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor, constant: 16),
            filterSegmentedControl.trailingAnchor.constraint(equalTo: headerContainer.trailingAnchor, constant: -16),
            filterSegmentedControl.heightAnchor.constraint(equalToConstant: 34)
        ])

        return headerContainer
    }

    private func rebuildLandingBadgesStrip() {
        badgesHorizontalStack.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for badge in viewModel.allBadges {
            let unlocked = viewModel.isBadgeUnlocked(badge)
            let pillCard = UIView()
            pillCard.translatesAutoresizingMaskIntoConstraints = false
            pillCard.backgroundColor = unlocked ? AppTheme.studioAmber : AppTheme.surfaceGray
            pillCard.layer.cornerRadius = 14
            pillCard.layer.borderWidth = 1.2
            pillCard.layer.borderColor = unlocked ? AppTheme.jetBlack.cgColor : AppTheme.borderGray.cgColor

            let iconView = UIImageView(image: UIImage(systemName: badge.iconSymbol))
            iconView.translatesAutoresizingMaskIntoConstraints = false
            iconView.tintColor = unlocked ? AppTheme.jetBlack : AppTheme.slateGray
            iconView.contentMode = .scaleAspectFit

            let nameLabel = UILabel()
            nameLabel.translatesAutoresizingMaskIntoConstraints = false
            nameLabel.text = badge.title
            nameLabel.font = .systemFont(ofSize: 12, weight: .bold)
            nameLabel.textColor = unlocked ? AppTheme.jetBlack : AppTheme.slateGray

            let stateLabel = UILabel()
            stateLabel.translatesAutoresizingMaskIntoConstraints = false
            stateLabel.text = unlocked ? "● UNLOCKED" : "LOCKED"
            stateLabel.font = .systemFont(ofSize: 10, weight: .heavy)
            stateLabel.textColor = unlocked ? AppTheme.jetBlack : AppTheme.slateGray.withAlphaComponent(0.7)

            pillCard.addSubview(iconView)
            pillCard.addSubview(nameLabel)
            pillCard.addSubview(stateLabel)

            NSLayoutConstraint.activate([
                pillCard.widthAnchor.constraint(equalToConstant: 142),
                iconView.topAnchor.constraint(equalTo: pillCard.topAnchor, constant: 10),
                iconView.leadingAnchor.constraint(equalTo: pillCard.leadingAnchor, constant: 10),
                iconView.widthAnchor.constraint(equalToConstant: 20),
                iconView.heightAnchor.constraint(equalToConstant: 20),

                nameLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 6),
                nameLabel.leadingAnchor.constraint(equalTo: pillCard.leadingAnchor, constant: 10),
                nameLabel.trailingAnchor.constraint(equalTo: pillCard.trailingAnchor, constant: -8),

                stateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2),
                stateLabel.leadingAnchor.constraint(equalTo: pillCard.leadingAnchor, constant: 10),
                stateLabel.trailingAnchor.constraint(equalTo: pillCard.trailingAnchor, constant: -8)
            ])

            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapBadgesButton))
            pillCard.addGestureRecognizer(tapGesture)
            pillCard.isUserInteractionEnabled = true

            badgesHorizontalStack.addArrangedSubview(pillCard)
        }
    }

    private func bindViewModel() {
        viewModel.onDataUpdated = { [weak self] in
            guard let self = self else { return }
            self.refreshControl.endRefreshing()
            self.updateDashboardHeader()
            self.rebuildLandingBadgesStrip()
            self.tableView.reloadData()
        }

        viewModel.onError = { [weak self] message in
            guard let self = self else { return }
            self.refreshControl.endRefreshing()
            let alert = UIAlertController(title: "Notice", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }

    private func updateDashboardHeader() {
        let progress = viewModel.userProgress
        welcomeUserLabel.text = "STUDENT: \(viewModel.currentStudentName.uppercased())"
        levelBadgeLabel.text = "Level \(progress.currentLevel) • \(progress.levelTitle)"
        xpValueLabel.text = "\(progress.totalXP) XP"
        levelProgressView.setProgress(progress.levelProgressFraction, animated: true)

        let completedCount = progress.completedModuleIDs.count
        let totalCount = viewModel.allModules.count
        let badgesCount = progress.unlockedBadgeIDs.count
        syllabusStatusLabel.text = "Syllabus: \(viewModel.syllabusCompletionPercentage)% (\(completedCount)/\(totalCount) chapters) • \(badgesCount) Badges Unlocked"
    }

    @objc private func handlePullToRefresh() {
        viewModel.fetchModules()
    }

    @objc private func filterChanged(_ sender: UISegmentedControl) {
        viewModel.applyFilter(index: sender.selectedSegmentIndex)
    }

    @objc private func didTapAuthButton() {
        viewModel.logout()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = (storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController)
            ?? LoginViewController()
        let nav = UINavigationController(rootViewController: loginVC)
        if let window = view.window {
            window.rootViewController = nav
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
        } else {
            navigationController?.setViewControllers([loginVC], animated: true)
        }
    }

    @objc private func didTapBadgesButton() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let badgesVC = (storyboard.instantiateViewController(withIdentifier: "BadgesViewController") as? BadgesViewController)
            ?? BadgesViewController()
        navigationController?.pushViewController(badgesVC, animated: true)
    }
}

extension ModulesListViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfModules
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ModuleTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? ModuleTableViewCell else {
            return UITableViewCell()
        }

        let module = viewModel.module(at: indexPath.row)
        cell.configure(
            with: module,
            isCompleted: viewModel.isModuleCompleted(module),
            highScore: viewModel.highScore(for: module),
            readTopicsCount: viewModel.readTopicsCount(for: module)
        )
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedModule = viewModel.module(at: indexPath.row)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = (storyboard.instantiateViewController(withIdentifier: "TopicDetailViewController") as? TopicDetailViewController)
            ?? TopicDetailViewController()
        detailVC.viewModel = TopicDetailViewModel(module: selectedModule)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
