import UIKit

enum AppTheme {
    /// Crisp Pure White background (#FFFFFF) from the reference image
    static let backgroundWhite = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.0)

    /// Soft Studio Gray card & secondary surface (#F5F5F7)
    static let surfaceGray = UIColor(red: 0.96, green: 0.96, blue: 0.97, alpha: 1.0)

    /// Subtle hairline border gray (#E5E5EA)
    static let borderGray = UIColor(red: 0.90, green: 0.90, blue: 0.92, alpha: 1.0)

    /// Jet Black primary ink, buttons, and dark squircle icon badge (#111113)
    static let jetBlack = UIColor(red: 0.07, green: 0.07, blue: 0.07, alpha: 1.0)

    /// Neutral Slate Gray for secondary headlines & subtitles (#86868B)
    static let slateGray = UIColor(red: 0.53, green: 0.53, blue: 0.55, alpha: 1.0)

    /// Warm Studio Amber / Marigold Yellow accent badge (#F5C43E)
    static let studioAmber = UIColor(red: 0.96, green: 0.77, blue: 0.24, alpha: 1.0)

    /// Soft Studio Amber tint for highlighted cards & badge backgrounds
    static let studioAmberSoft = UIColor(red: 0.96, green: 0.77, blue: 0.24, alpha: 0.20)

    /// Semantic feedback colors for quiz options
    static let correctGreen = UIColor(red: 0.12, green: 0.68, blue: 0.36, alpha: 1.0)
    static let incorrectRed = UIColor(red: 0.88, green: 0.23, blue: 0.24, alpha: 1.0)
}
