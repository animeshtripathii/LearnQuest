import Foundation

final class BadgesViewModel {

    static let allBadges: [Badge] = [
        Badge(
            id: "badge_welcome_cadet",
            title: "Studio Cadet",
            description: "Signed in to LearnQuest and unlocked the landing welcome badge.",
            iconSymbol: "shield.lefthalf.filled.badge.checkmark",
            requiredXP: 0,
            requiredCompletedChapters: nil,
            requiresPerfectScore: false
        ),
        Badge(
            id: "badge_first_step",
            title: "First Steps",
            description: "Complete your first chapter quiz and earn bonus XP.",
            iconSymbol: "flag.fill",
            requiredXP: nil,
            requiredCompletedChapters: 1,
            requiresPerfectScore: false
        ),
        Badge(
            id: "badge_xp_scholar",
            title: "Golden Scholar",
            description: "Accumulate at least 150 XP across topics and quizzes.",
            iconSymbol: "bolt.fill",
            requiredXP: 150,
            requiredCompletedChapters: nil,
            requiresPerfectScore: false
        ),
        Badge(
            id: "badge_perfect_score",
            title: "Sharpshooter",
            description: "Score 100% on any chapter multiple-choice quiz.",
            iconSymbol: "target",
            requiredXP: nil,
            requiredCompletedChapters: nil,
            requiresPerfectScore: true
        ),
        Badge(
            id: "badge_halfway",
            title: "Halfway Hero",
            description: "Complete at least 3 learning modules in the syllabus.",
            iconSymbol: "star.circle.fill",
            requiredXP: nil,
            requiredCompletedChapters: 3,
            requiresPerfectScore: false
        ),
        Badge(
            id: "badge_xp_champion",
            title: "XP Champion",
            description: "Reach 450 XP and advance to Level 4.",
            iconSymbol: "flame.fill",
            requiredXP: 450,
            requiredCompletedChapters: nil,
            requiresPerfectScore: false
        ),
        Badge(
            id: "badge_syllabus_master",
            title: "Syllabus Master",
            description: "Complete all 6 chapters in the LearnQuest curriculum.",
            iconSymbol: "crown.fill",
            requiredXP: nil,
            requiredCompletedChapters: 6,
            requiresPerfectScore: false
        )
    ]

    private let storageService: LocalStorageServiceProtocol
    private(set) var progress: UserProgress

    init(storageService: LocalStorageServiceProtocol = LocalStorageService.shared) {
        self.storageService = storageService
        self.progress = storageService.loadUserProgress()
    }

    func refresh() {
        self.progress = storageService.loadUserProgress()
    }

    var badges: [Badge] {
        return Self.allBadges
    }

    func isUnlocked(_ badge: Badge) -> Bool {
        return progress.unlockedBadgeIDs.contains(badge.id)
    }

    func statusText(for badge: Badge) -> String {
        if isUnlocked(badge) {
            return "UNLOCKED"
        }
        if let reqXP = badge.requiredXP {
            return "\(min(progress.totalXP, reqXP)) / \(reqXP) XP"
        }
        if let reqChapters = badge.requiredCompletedChapters {
            return "\(min(progress.completedModuleIDs.count, reqChapters)) / \(reqChapters) Chapters"
        }
        if badge.requiresPerfectScore {
            let best = progress.moduleHighScores.values.max() ?? 0
            return "Best Quiz: \(best)% (Need 100%)"
        }
        return "LOCKED"
    }

    @discardableResult
    static func evaluateBadges(for progress: inout UserProgress, totalModulesCount: Int) -> [Badge] {
        var newlyUnlocked: [Badge] = []
        progress.unlockedBadgeIDs.insert("badge_welcome_cadet")

        for badge in allBadges {
            if progress.unlockedBadgeIDs.contains(badge.id) { continue }

            var shouldUnlock = false
            if let reqXP = badge.requiredXP, progress.totalXP >= reqXP {
                shouldUnlock = true
            }
            if let reqChapters = badge.requiredCompletedChapters,
               progress.completedModuleIDs.count >= reqChapters {
                shouldUnlock = true
            }
            if badge.requiresPerfectScore,
               progress.moduleHighScores.values.contains(where: { $0 == 100 }) {
                shouldUnlock = true
            }

            if shouldUnlock {
                progress.unlockedBadgeIDs.insert(badge.id)
                newlyUnlocked.append(badge)
            }
        }

        return newlyUnlocked
    }
}
