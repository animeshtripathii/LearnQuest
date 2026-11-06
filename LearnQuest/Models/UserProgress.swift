import Foundation

struct UserProgress: Codable {
    var totalXP: Int
    var completedModuleIDs: Set<String>
    var readTopicIDs: Set<String>
    var moduleHighScores: [String: Int] // moduleId: percentage (0...100)
    var unlockedBadgeIDs: Set<String>
    var quizzesTakenCount: Int
    var lastUpdated: Date

    static var initial: UserProgress {
        return UserProgress(
            totalXP: 50,
            completedModuleIDs: [],
            readTopicIDs: [],
            moduleHighScores: [:],
            unlockedBadgeIDs: ["badge_welcome_cadet"],
            quizzesTakenCount: 0,
            lastUpdated: Date()
        )
    }

    var currentLevel: Int {
        return max(1, (totalXP / 150) + 1)
    }

    var levelTitle: String {
        switch currentLevel {
        case 1: return "Studio Novice"
        case 2: return "Swift Explorer"
        case 3: return "Code Specialist"
        case 4: return "System Architect"
        default: return "Grandmaster of Swift"
        }
    }

    var xpIntoCurrentLevel: Int {
        return totalXP % 150
    }

    var xpNeededForNextLevel: Int {
        return 150
    }

    var levelProgressFraction: Float {
        return Float(xpIntoCurrentLevel) / Float(xpNeededForNextLevel)
    }
}

struct Badge: Codable, Identifiable {
    let id: String
    let title: String
    let description: String
    let iconSymbol: String
    let requiredXP: Int?
    let requiredCompletedChapters: Int?
    let requiresPerfectScore: Bool
}
