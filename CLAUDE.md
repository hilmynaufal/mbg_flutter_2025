# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Flutter application project named `mbg_flutter_2025` - MBG Kabupaten Bandung SPPG Reporting System with multi-platform support (Android, iOS, Web, Linux, macOS, Windows). It uses Flutter SDK 3.7.2+ and follows GetX architecture pattern.

**Current Version:** 0.8.0-alpha+20251105

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

### Project Structure (GetX Pattern)
```
lib/
├── main.dart                          # Application entry point
├── app/
    ├── core/
    │   ├── theme/                     # App theming (colors, text styles)
    │   │   ├── app_colors.dart
    │   │   ├── app_text_styles.dart
    │   │   └── app_theme.dart
    │   ├── widgets/                   # Reusable widgets
    │   │   ├── banner_carousel_widget.dart
    │   │   ├── news_card_widget.dart
    │   │   ├── service_grid_item.dart
    │   │   ├── gradient_button.dart
    │   │   ├── custom_snackbar.dart
    │   │   ├── dynamic_form_builder.dart
    │   │   ├── custom_text_field.dart
    │   │   ├── custom_number_field.dart
    │   │   ├── custom_textarea.dart
    │   │   ├── custom_dropdown.dart
    │   │   ├── custom_radio_group.dart
    │   │   ├── custom_date_picker.dart
    │   │   ├── custom_image_picker.dart
    │   │   ├── map_picker_widget.dart
    │   │   └── map_viewer_widget.dart
    │   └── values/
    │       └── constants.dart
    ├── data/
    │   ├── models/                    # Data models
    │   │   ├── user_model.dart
    │   │   ├── news_model.dart
    │   │   ├── slide_model.dart
    │   │   ├── form_response_model.dart
    │   │   ├── report_list_item_model.dart
    │   │   └── report_list_response_model.dart
    │   ├── providers/                 # API providers
    │   │   ├── auth_provider.dart
    │   │   ├── form_provider.dart
    │   │   └── content_provider.dart
    │   ├── services/                  # Business logic services
    │   │   ├── auth_service.dart
    │   │   └── storage_service.dart
    │   └── dummy/                     # Dummy data for development
    │       └── news_dummy_data.dart
    ├── modules/                       # Feature modules (GetX pattern)
    │   ├── splash/
    │   │   ├── controllers/
    │   │   ├── views/
    │   │   └── bindings/
    │   ├── login/
    │   │   ├── controllers/
    │   │   ├── views/
    │   │   └── bindings/
    │   ├── home/
    │   ├── dynamic_form/
    │   ├── form_success/
    │   ├── report_list/
    │   ├── news_detail/
    │   ├── report_history/
    │   └── report_detail/
    └── routes/
        ├── app_pages.dart             # Route definitions
        └── app_routes.dart            # Route constants
```

### Key Dependencies
- **State Management:** GetX (get: ^4.6.6)
- **HTTP Client:** Dio (dio: ^5.4.0)
- **Local Storage:** SharedPreferences (shared_preferences: ^2.2.2)
- **UI Components:**
  - font_awesome_flutter: ^10.7.0
  - carousel_slider: ^5.0.0
  - flutter_spinkit: ^5.2.0
  - flutter_html: ^3.0.0-beta.2
- **Maps:** flutter_map: ^7.0.2, latlong2: ^0.9.0
- **Geolocation:** geolocator: ^11.0.0
- **Date/Time:** intl: ^0.19.0
- **Image Picker:** image_picker: ^1.0.7

### Design System
- **Font:** Plus Jakarta Sans (all weights)
- **Primary Color:** Teal (#14B8A6) - MBG Kabupaten Bandung branding
- **Gradient:** Linear gradient (#2DD4BF → #14B8A6)
- **Design Style:** Flat design with borders, white background
- **Icons:** FontAwesome Flutter
- **Theme:** Material Design 3 (useMaterial3: true)

### Code Quality
- Linting enforced via `flutter_lints` package
- Date formatting initialized for Indonesian locale (id_ID)
- GetX pattern for clean architecture
- Reactive programming with Obx observers

### Current Features
1. **Authentication System**
   - **Dual Login System**: PNS (Username/Password) and Non-PNS (NIK/Nama/Email with OTP)
   - PNS: Token-based authentication with API
   - Non-PNS: Local storage with OTP email verification
   - **OTP Verification** for Non-PNS users:
     - Email-based OTP (6 digits)
     - OTP expiry handling
     - Resend OTP with 60-second cooldown timer
     - Real-time verification status
   - NIK validation (16 digits)
   - User session management
   - User type differentiation (PNS/Non-PNS)

2. **Home Dashboard**
   - Real-time banner carousel from API (auto-play, active slides only)
   - Services grid with 3 main menus:
     - "Buat Laporan" - dialog to choose form type (SPPG/IKL)
     - "Laporan SPPG" - view SPPG report list
     - "Laporan IKL" - view IKL Dinkes report list
   - Latest news section (3 articles from API)
   - Loading states with spinner indicators
   - Flat design with bordered cards

3. **Dynamic Form System**
   - Dynamic form builder from API with slug-based routing
   - Multiple form types (SPPG, Laporan IKL Dinkes)
   - **Supported field types:** text, number, textarea, dropdown, radio, date, map, image
   - Field validation (required, min/max length, min/max value, regex)
   - Image upload with preview
   - **Interactive map coordinate picker** with flutter_map (OpenStreetMap)
     - Full-screen map picker with tap-to-select
     - Draggable marker for precise positioning
     - "Use My Location" button with GPS integration
     - Zoom controls and real-time coordinate display
     - Default center: Bandung, Indonesia
   - Regional data (Kecamatan/Desa)

4. **Report Management**
   - **Report List** - view submitted reports by type (SPPG/IKL)
     - Fetches data from API (no local storage)
     - Pull-to-refresh functionality
     - Displays: ID, summary, location, date, created by
     - Total count display
     - Empty state and error handling
   - **Report History** - legacy report history view
   - **Report Detail** - view individual report details

5. **News System**
   - Real-time news list from API
   - News detail page with HTML content rendering
   - Horizontal and vertical card layouts
   - Category badges and tags
   - Click-through navigation to full article
   - SEO-friendly slug-based URLs
   - Indonesian date formatting
   - Error handling with retry functionality

### Recent Changes (v0.8.0-alpha)
- **OTP Email Verification for Non-PNS Users**
  - Added OTP (One-Time Password) verification system for Non-PNS login security
  - **OTP API Integration**:
    - Created `OtpProvider` for API communication with fallback API
    - Send OTP endpoint: `POST /otp/send` (email-based)
    - Verify OTP endpoint: `POST /otp/verify` (6-digit code)
  - **OTP Response Models**:
    - `OtpSendResponseModel` - handles send OTP response (email, expires_at)
    - `OtpVerifyResponseModel` - handles verify OTP response (email, verified_at)
  - **LoginController OTP Features**:
    - Added `otpController` text controller for OTP input
    - OTP states: `isOtpSent`, `isOtpVerified`, `isSendingOtp`, `isVerifyingOtp`
    - Resend timer with 60-second cooldown (`resendTimer`)
    - **OTP Methods**:
      - `sendOtp()` - sends OTP to email (validates Email, NIK, Nama first)
      - `verifyOtp()` - verifies 6-digit OTP code
      - `resendOtp()` - resends OTP with timer check
      - `validateOtp()` - validates OTP format (6 digits)
    - `_startResendTimer()` - countdown timer for resend functionality
    - `_resetOtpStates()` - resets all OTP states when switching login types
  - **LoginView OTP UI**:
    - **Non-PNS Flow**: Email + NIK + Nama → Send OTP → Verify OTP → Login
    - Step 1: Email, NIK, Nama fields + "Kirim OTP" button
    - Step 2 (after OTP sent):
      - Info message box with instructions
      - OTP input field (6 digits) with verified checkmark icon
      - "Verifikasi OTP" button
      - "Kirim Ulang OTP" button with countdown timer (60s)
      - Fields disabled after OTP sent (prevent changes)
    - Step 3 (after OTP verified):
      - "Login" button enabled
      - Check mark icon on OTP field
    - Conditional rendering based on OTP states
    - Login button only shows for Non-PNS when OTP is verified
  - **Security Enhancements**:
    - Non-PNS users must verify email via OTP before login
    - OTP expiry handled by API (returns error if expired)
    - 60-second cooldown prevents OTP spam
    - Email, NIK, and Nama validated before sending OTP
  - Version updated to 0.8.0-alpha+20251105

### Recent Changes (v0.7.0-alpha)
- **Dual Login System - PNS & Non-PNS**
  - Added support for Non-PNS users to login without API authentication
  - **UserModel Updates**:
    - Added `userType` field ("PNS" / "NON_PNS")
    - Added factory constructor `UserModel.nonPns()` for Non-PNS users
    - Added `isPns` and `isNonPns` getters
    - Non-PNS users: NIK used as username, other fields set to empty/0
  - **AuthService Updates**:
    - Added `loginNonPns()` method for local storage authentication
    - No API call for Non-PNS login
  - **LoginController Updates**:
    - Added text controllers for Non-PNS: `nikController`, `namaController`, `emailController`
    - Added `isPnsLogin` toggle state
    - Split login logic: `loginPns()` and `loginNonPns()`
    - **Validators**:
      - `validateNik()` - NIK must be exactly 16 digits
      - `validateNama()` - Name minimum 3 characters
      - `validateEmail()` - Valid email format
  - **LoginView UI Redesign**:
    - Removed toggle button
    - Added text link below login button: "Tidak mempunyai akun? Masuk menggunakan NIK"
    - Form PNS: Username + Password
    - Form Non-PNS: NIK (16 digits) + Nama + Email (no password)
    - Clean and intuitive UI with conditional form rendering
  - **DynamicFormController Updates**:
    - Updated `_uploadToFallbackApi()` to use NIK as userId for Non-PNS users
    - PNS: uses `user.id`, Non-PNS: parses `user.nik` to int
  - Version updated to 0.7.0-alpha+20251105

### Recent Changes (v0.6.6-alpha)
- **Updated Application Launcher Icon**
  - Changed launcher icon from default Flutter icon to `assets/images/logo.png`
  - Generated platform-specific icons for Android, iOS, macOS, Windows, Linux, and Web
  - Uses flutter_launcher_icons package for consistent icon generation
  - MBG Kabupaten Bandung branding across all platforms

- **Updated Application Display Name**
  - Changed app name from "mbg_flutter_2025" to "Satgas MBG Kabupaten Bandung"
  - Updated for all platforms:
    - Android: Modified AndroidManifest.xml (android:label)
    - iOS: Modified Info.plist (CFBundleDisplayName, CFBundleName)
    - macOS: Modified Info.plist (CFBundleName)
    - Windows: Modified main.cpp (window.Create() title)
    - Linux: Modified my_application.cc (gtk_header_bar_set_title, gtk_window_set_title)
    - Web: Modified index.html (title tag, apple-mobile-web-app-title meta)

- **Dependencies Update**
  - Added flutter_launcher_icons: ^0.13.1 to dev_dependencies
  - Version bumped to 0.6.6-alpha+20251024

### Recent Changes (v0.6.5-alpha)
- **Banner Carousel Cleanup**
  - Removed gradient overlay and text from banner carousel
  - Banners now display images in full clarity without obstructions
  - Maintains clean design with rounded corners and shadows
  - Better visual clarity for banner content

- **Splash Screen Navigation Fix**
  - Fixed controller initialization issue (changed `Get.lazyPut()` → `Get.put()`)
  - Navigation now works correctly after 2 second delay
  - Added comprehensive logging for debugging
  - Enhanced error handling with try-catch

- **Complete Native Splash Cleanup**
  - Removed all remaining native splash files (19 Android images, iOS assets, web splash)
  - Cleaned up Android/iOS configuration files
  - App now uses only Flutter widget splash screen
  - Version updated to 0.6.5-alpha+20251016

### Recent Changes (v0.6.4-alpha)
- **Manual Splash Screen Implementation**
  - Created new `splash` module with GetX pattern (controller, view, binding)
  - **Replaced native splash screen with Flutter widget implementation**
  - `SplashView` displays `assets/images/splash.jpg` in fullscreen with `BoxFit.cover`
  - `SplashController` handles auto-navigation after 2 second delay
  - **Smart navigation** based on authentication status:
    - If logged in → Navigate to HOME
    - If not logged in → Navigate to LOGIN
  - Initial route changed from `LOGIN` to `SPLASH`
  - Added `Routes.SPLASH = '/splash'` route constant
  - **Removed `flutter_native_splash` package** - native implementation wasn't working properly
  - Pure Flutter implementation for better control and consistency
  - Version updated to 0.6.4-alpha+20251016

### Recent Changes (v0.6.3-alpha)
- **Native Fullscreen Splash Screen Implementation** *(Replaced in v0.6.4)*
  - Added `flutter_native_splash ^2.3.10` package for native splash screen generation
  - Created **fullscreen** platform-native splash screens for Android, iOS, and Web
  - **Configuration**:
    - Splash image: assets/images/splash.jpg (1.3MB fullscreen image)
    - Background color: #FFFFFF (white fallback)
    - **Fullscreen mode enabled** - image fills entire screen
    - Android gravity: `fill` - splash image scales to fill screen
    - iOS content mode: `scaleAspectFill` - splash fills screen without distortion
    - Web image mode: `center`
    - Android 12+ support with fullscreen splash
    - Dark mode support for Android
  - **Platform-Specific Features**:
    - Android: Fullscreen splash with `android:gravity="fill"`, status bar hidden
    - iOS: Launch screen with `scaleAspectFill`, status bar hidden
    - Web: CSS-based fullscreen splash screen
  - Shows immediately on app launch (before Flutter initialization)
  - Professional, fullscreen native experience across all platforms

- **Login Page Redesign**
  - Replaced generic icon (Icons.account_balance) with actual logo image
  - Using `assets/images/logo.png` (334KB) for branding consistency
  - **Removed circular container** - logo displayed directly for better visibility
  - **Changed background from teal to white** for cleaner, modern look
  - Logo size: 120px height with `BoxFit.contain`
  - Footer text color changed to grey for visibility on white background
  - Removed title texts (MBG, Pelaporan SPPG, Kabupaten Bandung) for simpler design

- **Assets & Configuration**
  - Added splash screen fullscreen configuration in pubspec.yaml
  - Logo and splash images properly referenced in assets
  - Version updated to 0.6.3-alpha+20251015

### Recent Changes (v0.6.2-alpha)
- **Success Screen for Form Submission**
  - Created new `form_success` module with GetX pattern
  - Dedicated full-screen success view after form submission
  - Comprehensive report information display:
    - Report ID (bold, prominent, with copy button)
    - Token (with copy button for easy tracking)
    - Submission timestamp (formatted in Indonesian)
    - SKPD name (if available)
    - Report description
  - **Animations**:
    - Animated success icon with scale animation (Curves.elasticOut)
    - Fade-in animation for content
    - Staggered animations for buttons
  - **Three Action Buttons**:
    - "Lihat Detail Laporan" → Navigate to report detail page
    - "Buat Laporan Lagi" → Create another report
    - "Kembali ke Home" → Return to home page
  - **Copy-to-clipboard functionality** for Report ID and Token
  - Replaced simple snackbar notification with full-screen confirmation

- **Updated DynamicFormController**
  - Removed: CustomSnackbar.success + Get.back()
  - Added: Get.offNamed(Routes.FORM_SUCCESS) with response data
  - Better user experience with clear confirmation screen

- **Routes Updates**
  - Added `FORM_SUCCESS` route constant
  - Registered FormSuccessView with FormSuccessBinding

- Updated version to 0.6.2-alpha+20251014

### Recent Changes (v0.6.1-alpha)
- **Map Display in Report Detail**
  - Created `MapViewerWidget` - read-only map viewer for displaying coordinates
  - Report detail now shows interactive map for coordinate answers
  - Automatically detects coordinate format (e.g., "-6.9175, 107.6191")
  - Map displayed with marker at exact location using OpenStreetMap
  - Compact 200px height with coordinate badge overlay

- **UI Improvement: Unified Report Detail Layout**
  - Refactored report detail view to use single card design
  - Merged header info and Q&A answers into one cohesive card
  - All items separated by consistent dividers for clean look
  - Three specialized answer renderers:
    - Text answers: using _buildAnswerRow
    - Coordinate answers: using _buildMapAnswerRow with map display
    - Image answers: using _buildImageAnswerRow with preview
  - Icons for each answer type (question, location, image)
  - Removed separate "Detail Jawaban" section for cleaner UI

- **Enhanced QuestionAnswer Model**
  - Added `isCoordinate` getter for automatic coordinate detection
  - Added `coordinateValues` getter to parse lat/lng from string
  - Validates coordinate ranges (lat: -90 to 90, lng: -180 to 180)
  - Supports formats: "-6.9175, 107.6191" or "-6.9175,107.6191"

- Updated version to 0.6.1-alpha+20251014

### Recent Changes (v0.6.0-alpha)
- **Interactive Map Picker with flutter_map**
  - Completely rewrote `MapPickerWidget` with flutter_map implementation
  - **Replaced**: google_maps_flutter (unused) → flutter_map + latlong2
  - **Features**:
    - Full-screen interactive map using OpenStreetMap tiles
    - Tap anywhere on map to select coordinates
    - Real-time coordinate display (latitude/longitude with 6 decimal precision)
    - "Use My Location" button with GPS/geolocation integration
    - Zoom in/out controls with floating action buttons
    - Instruction overlay for better UX
    - Red marker pin for selected location
    - Default center: Bandung, Indonesia (-6.9175, 107.6191)
  - **Location Permissions**:
    - Added ACCESS_FINE_LOCATION & ACCESS_COARSE_LOCATION for Android
    - Added NSLocationWhenInUseUsageDescription for iOS
  - **Benefits**:
    - No Google Maps API key required (uses OpenStreetMap)
    - Better UX: visual map instead of manual lat/lng input
    - More accurate coordinate selection
    - Free and open-source
    - Multi-platform support (Android, iOS, Web, Desktop)
- Updated version to 0.6.0-alpha+20251014

### Recent Changes (v0.5.0-alpha)
- **Report List Feature**
  - New module to display submitted reports from API
  - Separate lists for SPPG and IKL Dinkes reports
  - Created `ReportListItemModel` and `ReportListResponseModel`
  - API endpoints: `/data/pelaporan-tugas-satgas-mbg` and `/data/pelaporan-tugas-satgas-mbg---dinkes---laporan-ikl`
  - Pull-to-refresh, empty state, error handling
  - Report card UI with ID, summary, location, timestamp
- **Home Menu Redesign**
  - Replaced static menus with dynamic report list navigation
  - "Buat Laporan" menu shows dialog to choose form type
  - Separate menus for viewing SPPG and IKL report lists
  - Updated icons for better visual clarity
- Updated version to 0.5.0-alpha+20251009

### Recent Changes (v0.4.1-alpha)
- **Home Dashboard Simplification**
  - Removed "Statistik Pelaporan" section for cleaner UI
  - Focus shifted to main features: carousel, services, and news
  - Removed unused `_buildStatItem()` helper method
  - Improved page performance with less reactive elements
- Updated version to 0.4.1-alpha+20251009

### Recent Changes (v0.4.0-alpha)
- **API Integration for Carousel and News**
  - Created `ContentProvider` for API communication with Bandung Kab. API
  - Carousel now loads real-time slides from `GET /api/site/12/slides`
  - News list loads from `GET /api/site/12/posts` (limited to 3 items)
  - Added loading states and error handling for all API calls
  - Created `SlideModel` for carousel data structure
  - Updated `NewsModel` to match API response (added `idPost`, `url`, `imageSmallUrl`, `imageMiddleUrl`, `tags`, `createdAt`)
  - Legacy compatibility maintained with backward-compatible getters
  - Added `dart:developer` logging for API debugging
- **News Detail Page**
  - New `news_detail` module with full article display
  - HTML content rendering using `flutter_html` package
  - Fetches article from API by slug: `GET /api/site/12/post/{slug}`
  - Hero image with loading/error states
  - Article metadata (date, author, category, tags)
  - Error handling with retry functionality
  - SEO-friendly slug-based routing
  - Clean AppBar design with transparent background
- **UI/UX Improvements**
  - Simplified news card horizontal layout for better readability
  - Added Material Design 3 headline text styles (`headlineLarge`, `headlineMedium`, `headlineSmall`)
  - Transparent AppBar on news detail page for modern look
- **API Base URL**: `https://api.bandungkab.go.id/api`
- **Site ID**: 12 (all endpoints use site ID 12)
- Updated version to 0.4.0-alpha+20251008

### Recent Changes (v0.3.0-alpha)
- **Radio Button Support in Dynamic Form**
  - Created `CustomRadioGroup` widget for radio button fields
  - Added support for `question_type: "radio"` in `DynamicFormBuilder`
  - Uses `RadioListTile` for better UX with bordered container
  - Parses options from API with format `{"text": "...", "value": "..."}`
  - Full validation support (required field)
  - Consistent styling with label, description, and required indicator (*)
- **Dynamic form now supports 8 field types**: text, number, textarea, dropdown, **radio**, date, map, image
- Updated version to 0.3.0-alpha+20251008

### Recent Changes (v0.2.1-alpha)
- **Refactored form_sppg module to dynamic_form** for better reusability
  - Renamed `FormSppgController` → `DynamicFormController`
  - Renamed `FormSppgView` → `DynamicFormView`
  - Renamed `FormSppgBinding` → `DynamicFormBinding`
  - Routes updated: `FORM_SPPG` → `DYNAMIC_FORM`
  - Form slug now passed via route arguments
- **Added new menu item**: Laporan IKL Dinkes form
- **Created custom snackbar widget** (`CustomSnackbar`)
  - Success, error, warning, and info snackbar types
  - Consistent styling across the app
  - Replaced all `Get.snackbar()` calls with `CustomSnackbar` helper
- Updated version to 0.2.1-alpha+20251007

### Recent Changes (v0.2.0-alpha)
- Added banner carousel with auto-play
- Implemented news feature with dummy data
- Created gradient button component
- Updated to flat design (no elevation, bordered cards)
- Changed to 3-column services grid
- Hidden user info card (moved to future Profile page)
- Fixed LocaleDataException for Indonesian date formatting
