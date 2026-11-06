import Foundation

struct SyllabusResponse: Codable {
    let courseTitle: String
    let version: String
    let modules: [LearningModule]
}

struct LearningModule: Codable, Identifiable {
    let id: String
    let chapterNumber: Int
    let title: String
    let subtitle: String
    let category: String
    let difficulty: String
    let estimatedMinutes: Int
    let xpReward: Int
    let summary: String
    let topics: [TopicSection]
    let quiz: [QuizQuestion]
}

struct TopicSection: Codable, Identifiable {
    let id: String
    let title: String
    let explanation: String
    let keyTakeaway: String
    let codeExample: String?
}

struct QuizQuestion: Codable, Identifiable {
    let id: String
    let question: String
    let options: [String]
    let correctOptionIndex: Int
    let explanation: String
    let points: Int
}
