import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        configureGlobalAppearance()
        return true
    }

    private func configureGlobalAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = AppTheme.backgroundWhite
        appearance.shadowColor = AppTheme.borderGray
        appearance.titleTextAttributes = [
            .foregroundColor: AppTheme.jetBlack,
            .font: UIFont.systemFont(ofSize: 18, weight: .bold)
        ]
        appearance.largeTitleTextAttributes = [
            .foregroundColor: AppTheme.jetBlack,
            .font: UIFont.systemFont(ofSize: 32, weight: .heavy)
        ]

        let navBar = UINavigationBar.appearance()
        navBar.standardAppearance = appearance
        navBar.scrollEdgeAppearance = appearance
        navBar.compactAppearance = appearance
        navBar.tintColor = AppTheme.jetBlack
        navBar.barStyle = .default

        UISegmentedControl.appearance().selectedSegmentTintColor = AppTheme.studioAmber
        UISegmentedControl.appearance().backgroundColor = AppTheme.surfaceGray
        UISegmentedControl.appearance().setTitleTextAttributes(
            [.foregroundColor: AppTheme.jetBlack, .font: UIFont.systemFont(ofSize: 13, weight: .bold)],
            for: .selected
        )
        UISegmentedControl.appearance().setTitleTextAttributes(
            [.foregroundColor: AppTheme.slateGray, .font: UIFont.systemFont(ofSize: 13, weight: .semibold)],
            for: .normal
        )
    }

    // MARK: UISceneSession Lifecycle

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(
        _ application: UIApplication,
        didDiscardSceneSessions sceneSessions: Set<UISceneSession>
    ) {
    }
}
