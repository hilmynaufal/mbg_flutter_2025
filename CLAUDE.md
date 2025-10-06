# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Flutter application project named `mbg_flutter_2025` with multi-platform support (Android, iOS, Web, Linux, macOS, Windows). It uses Flutter SDK 3.7.2+ and follows standard Flutter project conventions.

## Development Commands

### Running the Application
```bash
flutter run                    # Run on connected device/emulator
flutter run -d chrome          # Run on Chrome browser
flutter run -d windows         # Run on Windows desktop
```

### Testing
```bash
flutter test                   # Run all tests
flutter test test/widget_test.dart  # Run a specific test file
```

### Code Quality
```bash
flutter analyze                # Run static analysis
flutter pub outdated           # Check for outdated dependencies
```

### Building
```bash
flutter build apk              # Build Android APK
flutter build appbundle        # Build Android App Bundle
flutter build ios              # Build iOS app (macOS only)
flutter build windows          # Build Windows executable
flutter build web              # Build web application
```

### Dependencies
```bash
flutter pub get                # Install dependencies
flutter pub upgrade            # Upgrade dependencies
```

## Architecture

### Project Structure
- `lib/` - Application source code
  - `main.dart` - Application entry point with MyApp and MyHomePage widgets
- `test/` - Widget and unit tests
- `android/`, `ios/`, `web/`, `linux/`, `macos/`, `windows/` - Platform-specific code
- `pubspec.yaml` - Project dependencies and configuration

### Code Quality
- Linting is enforced via `flutter_lints` package (configured in `analysis_options.yaml`)
- Uses Material Design with Cupertino icons support
- Default theme uses `ColorScheme.fromSeed` with deep purple seed color

### Current State
This is a fresh Flutter project with the default counter app demo implementation. The app is a simple stateful widget demonstrating basic Flutter concepts.
