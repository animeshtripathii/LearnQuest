import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        window.overrideUserInterfaceStyle = .light

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let isLoggedIn = LocalStorageService.shared.isUserLoggedIn()

        if isLoggedIn {
            let modulesVC = (storyboard.instantiateViewController(withIdentifier: "ModulesListViewController") as? ModulesListViewController)
                ?? ModulesListViewController()
            let nav = UINavigationController(rootViewController: modulesVC)
            nav.navigationBar.prefersLargeTitles = true
            window.rootViewController = nav
        } else {
            let loginVC = (storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController)
                ?? LoginViewController()
            let nav = UINavigationController(rootViewController: loginVC)
            nav.navigationBar.prefersLargeTitles = false
            window.rootViewController = nav
        }

        self.window = window
        window.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}
}
