# TaskHive 🐝

**A Premium Smart Productivity Manager for Students and Young Professionals**

TaskHive is a high-end, feature-rich productivity application designed to help students and young professionals manage their tasks efficiently with a beautiful, modern interface and powerful features.

![TaskHive App](https://img.shields.io/badge/Flutter-3.8.1+-blue.svg)
![Platform](https://img.shields.io/badge/Platform-Web%20%7C%20Mobile%20%7C%20Desktop-green.svg)
![License](https://img.shields.io/badge/License-MIT-yellow.svg)
![Currency](https://img.shields.io/badge/Currency-MYR%20(RM)-orange.svg)

---

## ✨ Features

### 🎯 Core Features
- Smart task management: create, edit, delete, and organize tasks
- **Edit tasks from both Home and Tasks screens**
- Category organization & filtering: custom categories with colors and icons, filter tasks by category
- Category display: task cards show their category (with icon and color)
- Priority system: high, medium, low priority levels with color coding
- Due date management & status tracking
- **Category management: view, edit, delete (safe), and reassign tasks**
- **Safe deletion:** Cannot delete a category with tasks; must reassign or remove tasks first
- **Automatic refresh:** Task list updates instantly after add/edit
- Smart notifications: reminders for tasks (see below)
- Progress analytics: visual charts and statistics
- Theme customization: multiple beautiful themes and productivity packs
- **Confetti & audio feedback:** Celebrate task completion with confetti and sound (on both Home and Tasks screens)
- Cross-platform: Android, iOS, Web, Windows, macOS, Linux

### 🏷️ Category Management
- Unlimited custom categories
- Color & icon selection
- Visual customization and filtering
- **Edit category title, icon, and color**
- **Safe deletion with task reassignment required**

### 🎨 Premium Theme Store
- 8 premium themes, each with unique icon, color, and name
- Simulated purchases (no real payment required)
- Purchased themes are visually marked and available for selection

### 📊 Productivity Packs
- 4 premium productivity packs: advanced analytics, team collaboration, custom categories, priority reminders

### 💰 Business/E-Commerce Features
- Theme store with simulated in-app purchases
- Pricing: themes from RM1.99, packs from RM2.99

### 🔧 External Services
- Google Maps integration for location picking
- Geocoding for address search
- **Local notifications for reminders** (see below)

### 🎵 Interactive Media Elements
- Audio feedback and confetti animation on task completion (Home & Tasks screens)

### 🔔 Local Notifications
- **Set a reminder when adding/editing a task**
- The app will push a local notification at the exact date and time you set
- Works even if the app is in the background or closed
- To test: Add a task with a reminder a few minutes in the future and wait for the notification

### 🔮 Suggested Enhancements (No Firebase Required)
- REST API integration (e.g., motivational quotes)
- Export/import tasks (CSV/JSON)
- Speech-to-text for task creation
- Calendar view
- Gamification (streaks, badges, achievements)

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.8.1+)
- Dart SDK (3.0.0+)
- Android Studio / VS Code
- Git

### Installation

```sh
git clone https://github.com/yourusername/taskhive.git
cd taskhive
flutter pub get
```

### Running the App

```sh
# Android
flutter run -d android

# Web
flutter run -d chrome

# iOS
flutter run -d ios
```

### Building for Production

```sh
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# Web
flutter build web --release

# iOS
flutter build ios --release
```

---

## 📱 Usage Guide

- **Task Management:** Add, edit (from any screen), delete, complete, and filter tasks
- **Category Management:** Create, edit (title, icon, color), delete (only if empty), and filter by categories
- **Theme Store:** Browse, purchase (simulated), and select premium themes
- **Location Features:** Add and search for task locations using Google Maps
- **Media & Feedback:** Confetti and sound on task completion (Home & Tasks screens)
- **Settings:** Reset app data with "Clear All Data" for demonstrations
- **Reminders:** Set reminders for tasks and receive local notifications

---

## 🛠️ Development

- Strict code analysis and formatting
- Comprehensive code comments
- Unit and widget tests
- Optimized builds and smooth animations

---

## 📦 APK Release Instructions

1. **Change app name:** Already set to "TaskHive"
2. **Build release APK:**
   ```sh
   flutter build apk --release
   ```
3. **Find your APK at:**
   ```
   build/app/outputs/flutter-apk/app-release.apk
   ```
4. **Test the APK on a real device (recommended):**
   - Install and check all features, notifications, and UI
5. **Submit this APK to your lecturer. No extra signing needed for coursework.**

---

## ✅ Final Submission Checklist

- [x] All features work (tasks, categories, store, analytics, notifications)
- [x] No critical bugs or crashes
- [x] All navigation and UI flows are smooth
- [x] Animations and notifications work as expected
- [x] App icon and name are correct
- [x] README is up to date
- [x] APK is built and tested

---

## 🤝 Contributing

- Fork, branch, commit, push, and open a Pull Request
- Follow Flutter best practices and add tests for new features

---

## 📄 License

MIT License - see the [LICENSE](LICENSE) file.

---

## 🙏 Acknowledgments

- Flutter Team, Material Design, Open Source Community, Beta Testers

---

## 🔮 Roadmap

- [ ] Cloud sync
- [ ] Team features
- [ ] Advanced analytics
- [ ] Custom themes
- [ ] API integration
- [ ] Voice commands
- [ ] AI assistant
- [ ] Export/import
- [ ] Category templates
- [ ] Bulk operations

---

**TaskHive** - Transform your productivity with smart task management! 🐝✨

*Built with ❤️ using Flutter*
