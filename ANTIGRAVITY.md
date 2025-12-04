# ANTIGRAVITY Analysis: MBG Flutter 2025

## Project Overview
**Name:** `mbg_flutter_2025`
**Description:** A Flutter application for "Pelaporan SPPG" (likely a reporting system).
**Version:** 0.10.0-alpha+202511261
**Tech Stack:** Flutter, Dart

## Architecture
The project follows a modular architecture using the **GetX** state management library. The main code is located in `lib/app`.

### Directory Structure (`lib/app`)
- **core/**: Contains core utilities, likely themes (`app_theme.dart`), and shared components.
- **data/**: Handles data layer, including services (`StorageService`, `AuthService`), providers (`ContentProvider`), and likely models/repositories.
- **modules/**: Contains the feature modules (screens/pages and their controllers).
- **routes/**: Defines application navigation (`app_pages.dart`, `app_routes.dart`).

## Key Dependencies
- **State Management:** `get` (^4.6.6)
- **Networking:** `dio` (^5.4.0)
- **Local Storage:** `shared_preferences` (^2.2.2)
- **Maps & Location:**
    - `flutter_map` (^7.0.2)
    - `latlong2` (^0.9.0)
    - `flutter_map_marker_cluster` (^1.3.6)
    - `geolocator` (^11.0.0)
- **UI Components:**
    - `flutter_spinkit` (Loading indicators)
    - `carousel_slider` (Image carousel)
    - `flutter_html` (HTML rendering)
    - `font_awesome_flutter` (Icons)
    - `cupertino_icons` (iOS icons)
- **Utilities:**
    - `intl` (Date & Time formatting)
    - `image_picker` (Media selection)
    - `url_launcher` (Open URLs)
    - `package_info_plus` (App version info)

## Entry Point (`lib/main.dart`)
- Initializes Flutter bindings.
- Sets up services asynchronously:
    - `StorageService` (persisted)
    - `AuthService`
    - `ContentProvider`
- Configures `GetMaterialApp` with:
    - Title: 'MBG - Pelaporan SPPG'
    - Theme: `AppTheme.lightTheme`
    - Initial Route: `Routes.INITIAL`
    - Pages: `AppPages.routes`
- Sets locale to Indonesian (`id_ID`).

## Observations
- The app seems to be focused on reporting, likely involving geolocation and map features.
- It uses a service-locator pattern via `Get.put` for dependency injection.
- The project is in alpha stage (version 0.10.0-alpha).
