# LearnQuest v3.0 — Gamified iOS Learning Application

[![Swift](https://img.shields.io/badge/Swift-5.0+-orange.svg?style=flat&logo=swift)](https://swift.org)
[![Platform](https://img.shields.io/badge/Platform-iOS%2015.0+-lightgrey.svg?style=flat&logo=apple)](https://developer.apple.com/ios/)
[![Architecture](https://img.shields.io/badge/Architecture-MVVM-blue.svg)](https://developer.apple.com/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

**LearnQuest** is an interactive, gamified iOS educational application built with **Swift 5** and **UIKit**, architected around clean **MVVM (Model-View-ViewModel)** design principles. The app provides structured learning modules, topic deep-dives, interactive quizzes with instant evaluation, and an achievement badge rewards system.

---

## 🎨 Visual Palette & Design System
Designed with a modern Studio aesthetic:
- **Pure White Canvas (`#FFFFFF`)** & **Soft Studio Gray Cards (`#F5F5F7`)**
- **Jet Black (`#111113`)**: Primary headlines, squircle icon badges, chapter pills, and primary action buttons
- **Studio Amber Yellow (`#F5C43E`)**: Accent squircle badges, XP indicators, progress bars, segmented controls, and unlocked achievement badges
- **Slate Gray (`#86868B`)**: Secondary headlines, kickers, timestamps, and metadata labels

---

## ✨ Key Features
- **Structured Modules Dashboard**: View modules categorized by domain with visual progress indicators and XP counters.
- **Topic Detail View**: Rich content reader with intuitive navigation, chapter checkpoints, and key takeaway summaries.
- **Interactive Quiz Engine**: Multiple-choice assessment with instant feedback, scoring logic, and streak tracking.
- **Badges & Gamification**: Unlockable milestone achievements, level progression, and learner stats.
- **Offline Persistence**: Local storage caching service (`LocalStorageService`) ensures progress is preserved without network dependencies.
- **MVVM Architecture**: Clean separation between views, view models, network services, and models for maintainability and testability.

---

## 📁 Project Structure

```text
LearnQuest/
├── LearnQuest/
│   ├── App/
│   │   ├── AppDelegate.swift          # App lifecycle & root initialization
│   │   ├── SceneDelegate.swift        # Window & scene management
│   │   └── AppTheme.swift             # Design system, colors & font styles
│   ├── Models/
│   │   ├── LearningModule.swift       # Module, chapter & quiz models
│   │   └── UserProgress.swift         # User progress, XP, and badge state
│   ├── Resources/
│   │   ├── Assets.xcassets/           # Icons and color assets
│   │   └── modules.json               # Seed learning content & quizzes
│   ├── Services/
│   │   ├── APIService.swift           # Remote synchronization & network layer
│   │   └── LocalStorageService.swift  # Offline caching & persistence
│   ├── ViewModels/
│   │   ├── BadgesViewModel.swift      # Badges & rewards business logic
│   │   ├── LoginViewModel.swift       # Authentication validation
│   │   ├── ModulesViewModel.swift     # Dashboard & module feed state
│   │   ├── QuizViewModel.swift        # Question progression & scoring
│   │   └── TopicDetailViewModel.swift # Reading view state
│   └── Views/
│       ├── Cells/
│       │   └── ModuleTableViewCell.swift
│       ├── Controllers/
│       │   ├── BadgesViewController.swift
│       │   ├── LoginViewController.swift
│       │   ├── ModulesListViewController.swift
│       │   ├── QuizViewController.swift
│       │   └── TopicDetailViewController.swift
│       └── Storyboards/
│           ├── LaunchScreen.storyboard
│           └── Main.storyboard
└── LearnQuest.xcodeproj               # Xcode project workspace configuration
```

---

## 🔐 Demo Credentials

| Account Role | Username / Email | Password | Logged In Identity |
|---|---|---|---|
| **Default Student** | `student@learnquest.com` | `quest123` | **Animesh Tripathi** |
| **Student ID** | `animesh` | `12319335` | **Animesh Tripathi (12319335)** |
| **Admin Scholar** | `admin` | `123456` | **Admin Scholar** |

---

## 🚀 Getting Started

### Prerequisites
- macOS with **Xcode 14.0+**
- iOS 15.0+ Deployment Target
- Swift 5.0+

### Running the App
1. Clone the repository:
   ```bash
   git clone https://github.com/animeshtripathii/LearnQuest.git
   cd LearnQuest
   ```
2. Open `LearnQuest.xcodeproj` in Xcode:
   ```bash
   open LearnQuest.xcodeproj
   ```
3. Select an iOS Simulator (e.g., iPhone 15 / 16 Pro) as your active build target.
4. Press `Cmd + R` to build and run.

---

## 📅 Maintenance & Release Notes
- **Last Updated**: 21 November 2026
- **Version**: 3.0.0
- **Author**: Animesh Tripathi
