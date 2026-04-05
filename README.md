# Mubit - Modern Islamic Habit Tracker

Mubit (derived from Muslim Habit) is a high-performance, offline-first mobile application built with Flutter. It serves as a comprehensive tool for tracking daily worship habits, specifically focusing on the five obligatory prayers and various Sunnah fasts. 

This project represents a full-scale modernization of a legacy codebase, migrated to the latest Flutter 3.41 ecosystem with a focus on reactive programming and robust local data persistence.

## Key Technical Features

### 1. Robust Prayer Engine
*   **Offline Calculation**: Utilizes the Adhan algorithm for precise prayer time generation based on GPS coordinates without requiring persistent internet access.
*   **Real-time Synchronization**: Features a live digital clock and dynamic countdowns to the next prayer time, implemented using isolated stateful rebuilds for performance optimization.
*   **Global Timezone Support**: Advanced timezone handling using `lat_lng_to_timezone` to ensure accuracy for users traveling across different longitudinal zones.

### 2. Habit Tracking & Data Persistence
*   **Isar NoSQL Database**: Implements Isar for high-speed local storage, ensuring all user progress is saved instantly and persists across application restarts.
*   **Reactive State Management**: Built with Riverpod (using the modern Notifier and AsyncNotifier patterns) to provide a seamless and flicker-free user experience.

### 3. Data Visualization & Statistics
*   **Istiqomah Graphics**: Integrated `fl_chart` to visualize the last 20 days of worship consistency through interactive bar charts.
*   **Streak Logic**: Implements custom algorithms to calculate current worship streaks, encouraging user consistency.

### 4. Modern UI/UX
*   **Material 3**: Fully compliant with Material Design 3 standards, featuring a refreshed Teal-Mint color palette and adaptive components.
*   **Dynamic Fasting Forecast**: Automatically identifies upcoming Sunnah fasts (Monday-Thursday, Ayyamul Bidh) for the next 30 days.

## Technology Stack

*   **Framework**: Flutter 3.41.2 (Stable Channel)
*   **Language**: Dart 3.x (Sound Null Safety)
*   **State Management**: `flutter_riverpod`
*   **Local Database**: `isar` & `isar_flutter_libs`
*   **Build System**: Modern Kotlin DSL (`.gradle.kts`) with Java 21 support
*   **Core Engines**: `adhan` (Prayer Times), `hijri` (Islamic Calendar), `geolocator` (GPS)

## Project Structure

```text
lib/
├── core/
│   ├── theme/       # Material 3 color schemes and typography
│   ├── services/    # Global services (Location, Preferences, Isar)
│   └── utils/       # Global formatters (Currency, Date)
├── features/
│   ├── habit_tracker/ # Daily checklist logic and UI components
│   ├── prayer_times/  # Prayer calculation engine and providers
│   ├── statistics/    # fl_chart implementation and data aggregation
│   ├── settings/      # App configuration and "About" module
│   └── splash/        # Branded boot sequence
└── main.dart        # Application entry point & service initialization
```

## Getting Started

### Prerequisites
*   Flutter SDK (3.41.0 or higher)
*   Java 21 (required for the modern Gradle build system)
*   Android SDK 34 (Target) / iOS 17.0

### Installation & Build
1. Clone the repository:
   ```bash
   git clone https://github.com/dithdyt/mubit-app.git
   ```
2. Fetch dependencies:
   ```bash
   flutter pub get
   ```
3. Generate Isar & Riverpod code-gen files:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```
4. Run the application:
   ```bash
   flutter run
   ```

## Author
*   **dithdyt** - *Project Lead & Developer*

---
