import Foundation

final class TopicDetailViewModel {

    let module: LearningModule
    private let storageService: LocalStorageServiceProtocol
    private(set) var userProgress: UserProgress
    private(set) var currentTopicIndex: Int = 0

    var onTopicChanged: (() -> Void)?
    var onXPAwarded: ((Int) -> Void)?

    init(
        module: LearningModule,
        storageService: LocalStorageServiceProtocol = LocalStorageService.shared
    ) {
        self.module = module
        self.storageService = storageService
        self.userProgress = storageService.loadUserProgress()
    }

    var topics: [TopicSection] {
        return module.topics
    }

    var currentTopic: TopicSection {
        return module.topics[currentTopicIndex]
    }

    var topicProgressText: String {
        return "TOPIC \(currentTopicIndex + 1) OF \(module.topics.count)"
    }

    var topicProgressFraction: Float {
        guard !module.topics.isEmpty else { return 1.0 }
        return Float(currentTopicIndex + 1) / Float(module.topics.count)
    }

    var isCurrentTopicRead: Bool {
        return userProgress.readTopicIDs.contains(currentTopic.id)
    }

    func markCurrentTopicAsRead() {
        let topicId = currentTopic.id
        guard !userProgress.readTopicIDs.contains(topicId) else { return }

        userProgress.readTopicIDs.insert(topicId)
        let readingXP = 15
        userProgress.totalXP += readingXP
        _ = BadgesViewModel.evaluateBadges(for: &userProgress, totalModulesCount: 6)
        storageService.saveUserProgress(userProgress)

        onXPAwarded?(readingXP)
        onTopicChanged?()
    }

    func goToNextTopic() -> Bool {
        markCurrentTopicAsRead()
        if currentTopicIndex + 1 < module.topics.count {
            currentTopicIndex += 1
            onTopicChanged?()
            return true
        }
        return false
    }

    func goToPreviousTopic() {
        guard currentTopicIndex > 0 else { return }
        currentTopicIndex -= 1
        onTopicChanged?()
    }
}
