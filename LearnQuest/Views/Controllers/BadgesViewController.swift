import UIKit

final class BadgesViewController: UIViewController {

    private let viewModel = BadgesViewModel()
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Achievements & Badges"
        navigationItem.largeTitleDisplayMode = .never
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.refresh()
        tableView.reloadData()
    }

    private func setupUI() {
        view.backgroundColor = AppTheme.surfaceGray

        let resetButton = UIBarButtonItem(
            title: "Reset",
            style: .plain,
            target: self,
            action: #selector(didTapResetProgress)
        )
        resetButton.tintColor = AppTheme.jetBlack
        navigationItem.rightBarButtonItem = resetButton

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = AppTheme.surfaceGray
        tableView.separatorColor = AppTheme.borderGray
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    @objc private func didTapResetProgress() {
        let alert = UIAlertController(
            title: "Reset Learning Progress?",
            message: "This will reset your XP, completed chapters, and quiz scores back to the initial Studio Cadet state.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Reset", style: .destructive) { [weak self] _ in
            _ = LocalStorageService.shared.resetUserProgress()
            self?.viewModel.refresh()
            self?.tableView.reloadData()
        })
        present(alert, animated: true)
    }
}

extension BadgesViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "YOUR STUDIO STATS" : "ALL ACHIEVEMENT BADGES"
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.textColor = AppTheme.slateGray
            header.textLabel?.font = .systemFont(ofSize: 12, weight: .heavy)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 3 : viewModel.badges.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "BadgeCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId)
            ?? UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        cell.selectionStyle = .none
        cell.backgroundColor = AppTheme.backgroundWhite
        cell.textLabel?.textColor = AppTheme.jetBlack
        cell.detailTextLabel?.textColor = AppTheme.slateGray
        cell.tintColor = AppTheme.jetBlack

        if indexPath.section == 0 {
            let p = viewModel.progress
            if indexPath.row == 0 {
                cell.imageView?.image = UIImage(systemName: "bolt.circle.fill")
                cell.imageView?.tintColor = AppTheme.studioAmber
                cell.textLabel?.text = "Total XP: \(p.totalXP) XP"
                cell.detailTextLabel?.text = "Level \(p.currentLevel) • \(p.levelTitle)"
            } else if indexPath.row == 1 {
                cell.imageView?.image = UIImage(systemName: "book.circle.fill")
                cell.imageView?.tintColor = AppTheme.jetBlack
                cell.textLabel?.text = "Completed Chapters: \(p.completedModuleIDs.count) / 6"
                cell.detailTextLabel?.text = "Topics Read: \(p.readTopicIDs.count) • Quizzes Taken: \(p.quizzesTakenCount)"
            } else {
                cell.imageView?.image = UIImage(systemName: "rosette")
                cell.imageView?.tintColor = AppTheme.studioAmber
                cell.textLabel?.text = "Badges Unlocked: \(p.unlockedBadgeIDs.count) / \(viewModel.badges.count)"
                cell.detailTextLabel?.text = "Includes Studio Cadet Landing Badge + 6 Syllabus Badges"
            }
            return cell
        }

        let badge = viewModel.badges[indexPath.row]
        let unlocked = viewModel.isUnlocked(badge)

        cell.imageView?.image = UIImage(systemName: badge.iconSymbol)
        cell.imageView?.tintColor = unlocked ? AppTheme.studioAmber : AppTheme.slateGray.withAlphaComponent(0.4)
        cell.textLabel?.text = "\(badge.title)  •  \(viewModel.statusText(for: badge))"
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: unlocked ? .bold : .medium)
        cell.textLabel?.textColor = unlocked ? AppTheme.jetBlack : AppTheme.slateGray
        cell.detailTextLabel?.text = badge.description
        cell.detailTextLabel?.numberOfLines = 2
        cell.accessoryType = unlocked ? .checkmark : .none
        return cell
    }
}
