import Foundation

final class ModulesViewModel {

    private let apiService: APIServiceProtocol
    private let storageService: LocalStorageServiceProtocol

    private(set) var allModules: [LearningModule] = []
    private(set) var filteredModules: [LearningModule] = []
    private(set) var userProgress: UserProgress
    private(set) var selectedFilterIndex: Int = 0

    var onDataUpdated: (() -> Void)?
    var onError: ((String) -> Void)?

    init(
        apiService: APIServiceProtocol = APIService.shared,
        storageService: LocalStorageServiceProtocol = LocalStorageService.shared
    ) {
        self.apiService = apiService
        self.storageService = storageService
        self.userProgress = storageService.loadUserProgress()
    }

    var currentStudentName: String {
        return storageService.currentUsername()
    }

    var isLoggedIn: Bool {
        return storageService.isUserLoggedIn()
    }

    func logout() {
        storageService.setLoggedInUser(username: nil)
    }

    func fetchModules() {
        apiService.fetchLearningModules { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let modules):
                self.allModules = modules.sorted { $0.chapterNumber < $1.chapterNumber }
                self.reloadProgress()
            case .failure(let error):
                self.onError?(error.localizedDescription)
            }
        }
    }

    func reloadProgress() {
        userProgress = storageService.loadUserProgress()
        _ = BadgesViewModel.evaluateBadges(for: &userProgress, totalModulesCount: allModules.count)
        storageService.saveUserProgress(userProgress)
        applyFilter(index: selectedFilterIndex)
    }

    func applyFilter(index: Int) {
        selectedFilterIndex = index
        switch index {
        case 1:
            filteredModules = allModules.filter { !userProgress.completedModuleIDs.contains($0.id) }
        case 2:
            filteredModules = allModules.filter { userProgress.completedModuleIDs.contains($0.id) }
        default:
            filteredModules = allModules
        }
        onDataUpdated?()
    }

    var numberOfModules: Int {
        return filteredModules.count
    }

    func module(at index: Int) -> LearningModule {
        return filteredModules[index]
    }

    func isModuleCompleted(_ module: LearningModule) -> Bool {
        return userProgress.completedModuleIDs.contains(module.id)
    }

    func highScore(for module: LearningModule) -> Int? {
        return userProgress.moduleHighScores[module.id]
    }

    func readTopicsCount(for module: LearningModule) -> Int {
        return module.topics.filter { userProgress.readTopicIDs.contains($0.id) }.count
    }

    var syllabusCompletionPercentage: Int {
        guard !allModules.isEmpty else { return 0 }
        let completed = allModules.filter { userProgress.completedModuleIDs.contains($0.id) }.count
        return Int((Double(completed) / Double(allModules.count)) * 100.0)
    }

    var allBadges: [Badge] {
        return BadgesViewModel.allBadges
    }

    func isBadgeUnlocked(_ badge: Badge) -> Bool {
        return userProgress.unlockedBadgeIDs.contains(badge.id)
    }
}
