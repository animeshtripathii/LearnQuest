import Foundation

final class LoginViewModel {

    struct CredentialPair {
        let username: String
        let password: String
        let displayName: String
    }

    /// Hardcoded valid login credentials
    static let defaultUsername: String = "student@learnquest.com"
    static let defaultPassword: String = "quest123"

    private let allowedCredentials: [CredentialPair] = [
        CredentialPair(username: "student@learnquest.com", password: "quest123", displayName: "Animesh Tripathi"),
        CredentialPair(username: "animesh", password: "12319335", displayName: "Animesh Tripathi (12319335)"),
        CredentialPair(username: "admin", password: "123456", displayName: "Admin Scholar")
    ]

    private let storageService: LocalStorageServiceProtocol

    var onLoginSuccess: ((String) -> Void)?
    var onLoginError: ((String) -> Void)?

    init(storageService: LocalStorageServiceProtocol = LocalStorageService.shared) {
        self.storageService = storageService
    }

    func authenticate(usernameInput: String?, passwordInput: String?) {
        let trimmedUser = (usernameInput ?? "").trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let trimmedPass = (passwordInput ?? "").trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedUser.isEmpty, !trimmedPass.isEmpty else {
            onLoginError?("Please enter both your email/username and password.")
            return
        }

        if let match = allowedCredentials.first(where: {
            $0.username.lowercased() == trimmedUser && $0.password == trimmedPass
        }) {
            storageService.setLoggedInUser(username: match.displayName)
            var progress = storageService.loadUserProgress()
            progress.unlockedBadgeIDs.insert("badge_welcome_cadet")
            storageService.saveUserProgress(progress)
            onLoginSuccess?(match.displayName)
        } else {
            onLoginError?(
                "Invalid credentials.\n\nUse Hardcoded Credentials:\n• Email: \(Self.defaultUsername) / \(Self.defaultPassword)\n• Student: animesh / 12319335\n• Admin: admin / 123456"
            )
        }
    }
}
