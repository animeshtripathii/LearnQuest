import UIKit

final class LoginViewController: UIViewController {

    private let viewModel = LoginViewModel()

    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()

    private let kickerLabel = UILabel()
    private let heroTitleLabel = UILabel()
    private let heroSubtitleLabel = UILabel()
    private let badgesIconRow = UIStackView()

    private let loginCard = UIView()
    private let usernameField = UITextField()
    private let passwordField = UITextField()
    private let loginButton = UIButton(type: .system)
    private let autofillButton = UIButton(type: .system)

    private let credentialsHintCard = UIView()
    private let credentialsHintLabel = UILabel()

    private let landingBadgePreviewCard = UIView()
    private let landingBadgeTitleLabel = UILabel()
    private let landingBadgeSubtitleLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "LearnQuest"
        setupUI()
        bindViewModel()
        prefillHardcodedCredentials()
    }

    private func setupUI() {
        view.backgroundColor = AppTheme.backgroundWhite

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.axis = .vertical
        contentStack.spacing = 18

        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -28),
            contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40)
        ])

        // Reference-inspired Hero Header:
        // Slate Gray "Features • LearnQuest" kicker + Jet Black primary headline + Slate Gray secondary headline
        // paired with the Jet Black & Studio Amber squircle badges
        kickerLabel.text = "Features • Gamified iOS Learning"
        kickerLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        kickerLabel.textColor = AppTheme.slateGray
        kickerLabel.textAlignment = .center

        let blackSquircle = makeSquircleBadge(
            bgColor: AppTheme.jetBlack,
            symbolName: "graduationcap.fill",
            symbolTint: AppTheme.backgroundWhite
        )
        let amberSquircle = makeSquircleBadge(
            bgColor: AppTheme.studioAmber,
            symbolName: "macwindow",
            symbolTint: AppTheme.jetBlack
        )

        let iconPairContainer = UIView()
        badgesIconRow.translatesAutoresizingMaskIntoConstraints = false
        badgesIconRow.axis = .horizontal
        badgesIconRow.spacing = 14
        badgesIconRow.alignment = .center
        badgesIconRow.addArrangedSubview(blackSquircle)
        badgesIconRow.addArrangedSubview(amberSquircle)
        iconPairContainer.addSubview(badgesIconRow)

        NSLayoutConstraint.activate([
            badgesIconRow.topAnchor.constraint(equalTo: iconPairContainer.topAnchor),
            badgesIconRow.centerXAnchor.constraint(equalTo: iconPairContainer.centerXAnchor),
            badgesIconRow.bottomAnchor.constraint(equalTo: iconPairContainer.bottomAnchor)
        ])

        heroTitleLabel.text = "A whole syllabus."
        heroTitleLabel.font = .systemFont(ofSize: 34, weight: .heavy)
        heroTitleLabel.textColor = AppTheme.jetBlack
        heroTitleLabel.textAlignment = .center

        heroSubtitleLabel.text = "One gamified app."
        heroSubtitleLabel.font = .systemFont(ofSize: 30, weight: .bold)
        heroSubtitleLabel.textColor = AppTheme.slateGray
        heroSubtitleLabel.textAlignment = .center

        // Login Card (Soft Studio Gray surface + subtle border)
        loginCard.backgroundColor = AppTheme.surfaceGray
        loginCard.layer.cornerRadius = 20
        loginCard.layer.borderWidth = 1
        loginCard.layer.borderColor = AppTheme.borderGray.cgColor

        let cardStack = UIStackView()
        cardStack.translatesAutoresizingMaskIntoConstraints = false
        cardStack.axis = .vertical
        cardStack.spacing = 14
        loginCard.addSubview(cardStack)

        NSLayoutConstraint.activate([
            cardStack.topAnchor.constraint(equalTo: loginCard.topAnchor, constant: 20),
            cardStack.leadingAnchor.constraint(equalTo: loginCard.leadingAnchor, constant: 18),
            cardStack.trailingAnchor.constraint(equalTo: loginCard.trailingAnchor, constant: -18),
            cardStack.bottomAnchor.constraint(equalTo: loginCard.bottomAnchor, constant: -20)
        ])

        let formTitle = UILabel()
        formTitle.text = "Student Portal Sign In"
        formTitle.font = .systemFont(ofSize: 19, weight: .bold)
        formTitle.textColor = AppTheme.jetBlack

        styleTextField(usernameField, placeholder: "Email or Username", isSecure: false)
        styleTextField(passwordField, placeholder: "Password", isSecure: true)

        loginButton.setTitle("Sign In to LearnQuest →", for: .normal)
        loginButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        loginButton.backgroundColor = AppTheme.jetBlack
        loginButton.setTitleColor(AppTheme.backgroundWhite, for: .normal)
        loginButton.layer.cornerRadius = 14
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)

        autofillButton.setTitle("Fill Hardcoded Demo Credentials", for: .normal)
        autofillButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        autofillButton.setTitleColor(AppTheme.jetBlack, for: .normal)
        autofillButton.backgroundColor = AppTheme.studioAmber
        autofillButton.layer.cornerRadius = 12
        autofillButton.heightAnchor.constraint(equalToConstant: 42).isActive = true
        autofillButton.addTarget(self, action: #selector(prefillHardcodedCredentials), for: .touchUpInside)

        cardStack.addArrangedSubview(formTitle)
        cardStack.addArrangedSubview(usernameField)
        cardStack.addArrangedSubview(passwordField)
        cardStack.addArrangedSubview(loginButton)
        cardStack.addArrangedSubview(autofillButton)

        // Hardcoded Credentials Reference Card
        credentialsHintCard.backgroundColor = AppTheme.backgroundWhite
        credentialsHintCard.layer.cornerRadius = 16
        credentialsHintCard.layer.borderWidth = 1.2
        credentialsHintCard.layer.borderColor = AppTheme.borderGray.cgColor

        credentialsHintLabel.translatesAutoresizingMaskIntoConstraints = false
        credentialsHintLabel.font = .monospacedSystemFont(ofSize: 12.5, weight: .medium)
        credentialsHintLabel.textColor = AppTheme.jetBlack
        credentialsHintLabel.numberOfLines = 0
        credentialsHintLabel.text = """
        HARDCODED CREDENTIALS:
        • student@learnquest.com / quest123
        • animesh / 12319335
        • admin / 123456
        """
        credentialsHintCard.addSubview(credentialsHintLabel)

        NSLayoutConstraint.activate([
            credentialsHintLabel.topAnchor.constraint(equalTo: credentialsHintCard.topAnchor, constant: 14),
            credentialsHintLabel.leadingAnchor.constraint(equalTo: credentialsHintCard.leadingAnchor, constant: 14),
            credentialsHintLabel.trailingAnchor.constraint(equalTo: credentialsHintCard.trailingAnchor, constant: -14),
            credentialsHintLabel.bottomAnchor.constraint(equalTo: credentialsHintCard.bottomAnchor, constant: -14)
        ])

        // Landing Badge Preview Card (Studio Amber highlight)
        landingBadgePreviewCard.backgroundColor = AppTheme.studioAmberSoft
        landingBadgePreviewCard.layer.cornerRadius = 16
        landingBadgePreviewCard.layer.borderWidth = 1.5
        landingBadgePreviewCard.layer.borderColor = AppTheme.studioAmber.cgColor

        let badgeStack = UIStackView()
        badgeStack.translatesAutoresizingMaskIntoConstraints = false
        badgeStack.axis = .vertical
        badgeStack.spacing = 6
        landingBadgePreviewCard.addSubview(badgeStack)

        landingBadgeTitleLabel.text = "LANDING BADGE REWARD: STUDIO CADET"
        landingBadgeTitleLabel.font = .systemFont(ofSize: 13, weight: .heavy)
        landingBadgeTitleLabel.textColor = AppTheme.jetBlack

        landingBadgeSubtitleLabel.text = "Sign in to claim your +50 XP Welcome Bonus and unlock the Studio Cadet Landing Badge on your dashboard."
        landingBadgeSubtitleLabel.font = .systemFont(ofSize: 13, weight: .medium)
        landingBadgeSubtitleLabel.textColor = AppTheme.slateGray
        landingBadgeSubtitleLabel.numberOfLines = 0

        badgeStack.addArrangedSubview(landingBadgeTitleLabel)
        badgeStack.addArrangedSubview(landingBadgeSubtitleLabel)

        NSLayoutConstraint.activate([
            badgeStack.topAnchor.constraint(equalTo: landingBadgePreviewCard.topAnchor, constant: 14),
            badgeStack.leadingAnchor.constraint(equalTo: landingBadgePreviewCard.leadingAnchor, constant: 14),
            badgeStack.trailingAnchor.constraint(equalTo: landingBadgePreviewCard.trailingAnchor, constant: -14),
            badgeStack.bottomAnchor.constraint(equalTo: landingBadgePreviewCard.bottomAnchor, constant: -14)
        ])

        contentStack.addArrangedSubview(kickerLabel)
        contentStack.addArrangedSubview(iconPairContainer)
        contentStack.addArrangedSubview(heroTitleLabel)
        contentStack.addArrangedSubview(heroSubtitleLabel)
        contentStack.addArrangedSubview(loginCard)
        contentStack.addArrangedSubview(credentialsHintCard)
        contentStack.addArrangedSubview(landingBadgePreviewCard)
    }

    private func makeSquircleBadge(bgColor: UIColor, symbolName: String, symbolTint: UIColor) -> UIView {
        let box = UIView()
        box.translatesAutoresizingMaskIntoConstraints = false
        box.backgroundColor = bgColor
        box.layer.cornerRadius = 14

        let icon = UIImageView(image: UIImage(systemName: symbolName))
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.tintColor = symbolTint
        icon.contentMode = .scaleAspectFit
        box.addSubview(icon)

        NSLayoutConstraint.activate([
            box.widthAnchor.constraint(equalToConstant: 54),
            box.heightAnchor.constraint(equalToConstant: 54),
            icon.centerXAnchor.constraint(equalTo: box.centerXAnchor),
            icon.centerYAnchor.constraint(equalTo: box.centerYAnchor),
            icon.widthAnchor.constraint(equalToConstant: 26),
            icon.heightAnchor.constraint(equalToConstant: 26)
        ])
        return box
    }

    private func styleTextField(_ textField: UITextField, placeholder: String, isSecure: Bool) {
        textField.backgroundColor = AppTheme.backgroundWhite
        textField.textColor = AppTheme.jetBlack
        textField.tintColor = AppTheme.jetBlack
        textField.font = .systemFont(ofSize: 15, weight: .medium)
        textField.isSecureTextEntry = isSecure
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        textField.layer.borderColor = AppTheme.borderGray.cgColor
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [.foregroundColor: AppTheme.slateGray]
        )
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 14, height: 46))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.heightAnchor.constraint(equalToConstant: 46).isActive = true
    }

    private func bindViewModel() {
        viewModel.onLoginSuccess = { [weak self] _ in
            guard let self = self else { return }
            self.navigateToLandingDashboard()
        }

        viewModel.onLoginError = { [weak self] errorMessage in
            guard let self = self else { return }
            let alert = UIAlertController(title: "Sign In Failed", message: errorMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Fill Demo Credentials", style: .default) { _ in
                self.prefillHardcodedCredentials()
            })
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            self.present(alert, animated: true)
        }
    }

    @objc private func prefillHardcodedCredentials() {
        usernameField.text = LoginViewModel.defaultUsername
        passwordField.text = LoginViewModel.defaultPassword
    }

    @objc private func didTapLoginButton() {
        view.endEditing(true)
        viewModel.authenticate(usernameInput: usernameField.text, passwordInput: passwordField.text)
    }

    private func navigateToLandingDashboard() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let modulesVC = (storyboard.instantiateViewController(withIdentifier: "ModulesListViewController") as? ModulesListViewController)
            ?? ModulesListViewController()
        let nav = UINavigationController(rootViewController: modulesVC)
        nav.navigationBar.prefersLargeTitles = true

        if let window = view.window {
            window.rootViewController = nav
            UIView.transition(
                with: window,
                duration: 0.35,
                options: .transitionCrossDissolve,
                animations: nil
            )
        } else {
            navigationController?.setViewControllers([modulesVC], animated: true)
        }
    }
}
