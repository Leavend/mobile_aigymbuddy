# 🏋️ AI Gym Buddy

> Your intelligent fitness companion powered by Flutter

AI Gym Buddy is a comprehensive fitness tracking application built with Flutter that helps users monitor their workouts, nutrition, sleep, and overall health metrics. The app features a clean architecture, local-first data persistence, and a beautiful, intuitive user interface.

[![Flutter](https://img.shields.io/badge/Flutter-3.9.0+-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.9.0+-0175C2?logo=dart)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## ✨ Features

- 🔐 **Secure Authentication** - Email/password authentication with PBKDF2 hashing
- 🏃 **Workout Tracking** - Log and monitor various workout types
- 🍎 **Meal Planning** - Track nutrition and plan meals
- 😴 **Sleep Tracking** - Monitor sleep patterns and quality
- 💧 **Water Intake** - Track daily hydration goals
- 📊 **Progress Analytics** - Visualize fitness progress with charts
- 📸 **Photo Progress** - Compare transformation photos
- 🌍 **Multi-language** - Support for English and Indonesian
- 💾 **Local Database** - Offline-first with Drift (SQLite)
- 🎨 **Beautiful UI** - Modern, gradient-rich design

## 🏗️ Architecture

AI Gym Buddy follows **Clean Architecture** principles with clear separation of concerns:

```
┌─────────────────────────────────────────────────────┐
│              Presentation Layer                     │
│         (Views, Widgets, Controllers)               │
└────────────────┬────────────────────────────────────┘
                 │
┌────────────────▼────────────────────────────────────┐
│               Domain Layer                          │
│       (Use Cases, Business Logic, Models)           │
└────────────────┬────────────────────────────────────┘
                 │
┌────────────────▼────────────────────────────────────┐
│               Data Layer                            │
│   (Repositories, Database, Local Storage)           │
└─────────────────────────────────────────────────────┘
```

**Key Technologies:**
- **State Management:** Provider + ChangeNotifier
- **Routing:** GoRouter (type-safe navigation)
- **Database:** Drift (SQLite with type-safe queries)
- **Dependency Injection:** Service Locator pattern
- **Localization:** Custom i18n implementation

For detailed architecture documentation, see [ARCHITECTURE.md](docs/ARCHITECTURE.md).

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.9.0 or higher
- Dart SDK 3.9.0 or higher
- IDE (VS Code or Android Studio recommended)

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/aigymbuddy.git
   cd aigymbuddy
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run code generation:**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Run the app:**
   ```bash
   flutter run
   ```

### Build for Production

**Android:**
```bash
flutter build apk --release
flutter build appbundle --release
```

**iOS:**
```bash
flutter build ios --release
```

**Web:**
```bash
flutter build web --release
```

## 🧪 Testing

### Run all tests:
```bash
flutter test
```

### Run with coverage:
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Static analysis:
```bash
flutter analyze
```

## 📱 Screenshots

> Add screenshots of your app here

## 🗂️ Project Structure

```
lib/
├── auth/                  # Authentication feature
├── common/                # Shared utilities
│   ├── constants/        # App-wide constants
│   ├── di/               # Dependency injection
│   ├── error_handling/   # Error handler
│   └── services/         # Logging, auth services
├── common_widget/         # Reusable UI components
├── database/              # Data layer
│   ├── repositories/     # Data access
│   └── tables/           # Database schema
├── view/                  # UI layer
│   ├── base/             # Base view classes
│   ├── home/             # Home screen
│   ├── login/            # Auth screens
│   └── ...
└── main.dart              # App entry point
```

## 🤝 Contributing

We welcome contributions! Please see [CONTRIBUTING.md](docs/CONTRIBUTING.md) for guidelines.

### Quick Start for Contributors:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'feat: add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Drift team for the excellent database solution
- All contributors who help improve this project

## 📞 Contact

For questions or support, please open an issue or contact the maintainers.

---

**Made with ❤️ using Flutter**
