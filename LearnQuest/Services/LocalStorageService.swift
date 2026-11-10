import Foundation

protocol LocalStorageServiceProtocol {
    func loadUserProgress() -> UserProgress
    func saveUserProgress(_ progress: UserProgress)
    func resetUserProgress() -> UserProgress
    func saveCachedModules(_ modules: [LearningModule])
    func loadCachedModules() -> [LearningModule]?
    func isUserLoggedIn() -> Bool
    func setLoggedInUser(username: String?)
    func currentUsername() -> String
}

final class LocalStorageService: LocalStorageServiceProtocol {

    static let shared = LocalStorageService()

    private let userDefaults: UserDefaults
    private let progressKey = "com.learnquest.userProgress.v3"
    private let loggedInUserKey = "com.learnquest.loggedInUser.v3"
    private let cachedModulesFilename = "cached_modules.json"

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    func isUserLoggedIn() -> Bool {
        guard let user = userDefaults.string(forKey: loggedInUserKey) else { return false }
        return !user.isEmpty
    }

    func setLoggedInUser(username: String?) {
        if let username = username, !username.isEmpty {
            userDefaults.set(username, forKey: loggedInUserKey)
        } else {
            userDefaults.removeObject(forKey: loggedInUserKey)
        }
    }

    func currentUsername() -> String {
        return userDefaults.string(forKey: loggedInUserKey) ?? "Animesh Tripathi"
    }

    func loadUserProgress() -> UserProgress {
        guard let data = userDefaults.data(forKey: progressKey) else {
            let initial = UserProgress.initial
            saveUserProgress(initial)
            return initial
        }
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            var progress = try decoder.decode(UserProgress.self, from: data)
            progress.unlockedBadgeIDs.insert("badge_welcome_cadet")
            return progress
        } catch {
            return .initial
        }
    }

    func saveUserProgress(_ progress: UserProgress) {
        do {
            var updated = progress
            updated.unlockedBadgeIDs.insert("badge_welcome_cadet")
            updated.lastUpdated = Date()
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let data = try encoder.encode(updated)
            userDefaults.set(data, forKey: progressKey)
        } catch {
            print("[LocalStorageService] Failed to save user progress: \(error)")
        }
    }

    func resetUserProgress() -> UserProgress {
        let fresh = UserProgress.initial
        saveUserProgress(fresh)
        return fresh
    }

    func saveCachedModules(_ modules: [LearningModule]) {
        guard let url = cachedModulesFileURL() else { return }
        do {
            let data = try JSONEncoder().encode(modules)
            try data.write(to: url, options: .atomic)
        } catch {
            print("[LocalStorageService] Failed to cache modules: \(error)")
        }
    }

    func loadCachedModules() -> [LearningModule]? {
        guard let url = cachedModulesFileURL(),
              FileManager.default.fileExists(atPath: url.path) else {
            return nil
        }
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode([LearningModule].self, from: data)
        } catch {
            return nil
        }
    }

    private func cachedModulesFileURL() -> URL? {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?
            .appendingPathComponent(cachedModulesFilename)
    }
}
