# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.6.5-alpha] - 2025-10-16

### Changed
- **Banner Carousel Cleanup**
  - Removed gradient overlay from banner carousel for clearer image display
  - Removed title and description text overlay
  - Banners now display images in full clarity without any visual obstructions
  - Maintains rounded corners (12px) and shadow effects
  - Better user experience with clean, unobstructed banner images

### Fixed
- **Splash Screen Navigation Issue**
  - Fixed controller not being initialized in SplashBinding
  - Changed `Get.lazyPut()` to `Get.put()` to ensure controller is created immediately
  - Fixed navigation not triggering after 2 second delay
  - Added comprehensive logging for debugging navigation flow
  - Added try-catch error handling with fallback to LOGIN
  - Controller now properly executes `onInit()` and navigates to appropriate screen

- **Native Splash Screen Cleanup**
  - Removed all remaining native splash screen files from v0.6.3:
    - Deleted 19 Android splash images (splash.png, android12splash.png, background.png)
    - Removed 5 dark mode drawable folders
    - Removed Android 12+ values folders (values-v31, values-night-v31)
    - Cleaned up iOS LaunchBackground.imageset
    - Removed web/splash/ folder with 8 splash images
  - Simplified launch_background.xml to plain white background
  - Cleaned up styles.xml to remove fullscreen/dark mode configurations
  - App now uses only Flutter widget splash screen (no native splash remnants)

### Technical
- Updated `SplashBinding` to use `Get.put()` instead of `Get.lazyPut()`
- Added `dart:developer` import for logging in SplashController
- Splash screen timing: 2 seconds (reduced from 2.5 seconds)
- Enhanced error handling in splash navigation flow

---

## [0.6.4-alpha] - 2025-10-16

### Added
- **Manual Splash Screen Widget** - Custom Flutter widget for fullscreen splash screen
  - New module: `lib/app/modules/splash/` (controller, view, binding)
  - `SplashView` displays `assets/images/splash.jpg` in fullscreen (`BoxFit.cover`)
  - `SplashController` handles auto-navigation after 2.5 second delay
  - Smart navigation based on login status:
    - If logged in → Navigate to HOME
    - If not logged in → Navigate to LOGIN
  - Uses GetX pattern for state management
  - No additional dependencies required (pure Flutter)

### Changed
- **Initial Route**
  - Changed `Routes.INITIAL` from `LOGIN` to `SPLASH`
  - App now shows splash screen first, then navigates to appropriate page

- **Route Configuration**
  - Added `Routes.SPLASH = '/splash'` constant in `app_routes.dart`
  - Registered `SplashView` with `SplashBinding` in `app_pages.dart`

### Removed
- **Native Splash Screen Package**
  - Removed `flutter_native_splash: ^2.3.10` from dev dependencies
  - Removed entire `flutter_native_splash` configuration section from `pubspec.yaml`
  - Native splash implementation replaced with manual Flutter widget
  - Reason: Native splash screen was not working properly, manual implementation provides better control

### Technical
- Updated version in `pubspec.yaml`: 0.6.4-alpha+20251016
- Splash screen now runs within Flutter framework (not platform-native)
- Auto-navigation uses `Future.delayed` with 2.5 second duration
- Checks `AuthService.isLoggedIn.value` for navigation decision
- `Get.offAllNamed()` ensures splash screen is removed from navigation stack

### UI/UX
- ✅ **Fullscreen Display**: Splash image fills entire screen with `BoxFit.cover`
- ✅ **Smart Navigation**: Auto-directs to appropriate page based on auth state
- ✅ **No Manual Interaction**: User doesn't need to tap anything
- ✅ **Clean Transition**: Splash removed from stack, can't go back to it

---

## [0.6.3-alpha] - 2025-10-15

### Added
- **Native Fullscreen Splash Screen Implementation**
  - Integrated `flutter_native_splash ^2.3.10` package for platform-native splash screens
  - Created **fullscreen** splash screens for **Android**, **iOS**, and **Web** platforms
  - **Configuration**:
    - Splash image: `assets/images/splash.jpg` (1.3MB, fullscreen image for mobile)
    - Background color: `#FFFFFF` (white fallback, not visible when image fills screen)
    - **Fullscreen mode enabled** - image fills entire screen without letterboxing
    - Android gravity: `fill` - scales image to fill entire screen
    - iOS content mode: `scaleAspectFill` - fills screen without distortion
    - Web image mode: `center`
    - Android 12+ support with fullscreen splash
    - Dark mode support for Android splash screens
  - **Platform-Specific Features**:
    - **Android**:
      - Fullscreen splash with `android:gravity="fill"` in launch_background.xml
      - Status bar hidden during splash (`android:windowFullscreen="true"`)
      - Android 12+ styled fullscreen splash
      - Dark mode variants for Android 12+
      - Drawable resources in multiple densities
    - **iOS**:
      - Launch screen with `scaleAspectFill` content mode
      - Status bar hidden during splash (`UIStatusBarHidden=true`)
      - Updated Info.plist and LaunchScreen.storyboard
      - Launch images (1x, 2x, 3x)
    - **Web**:
      - CSS-based fullscreen splash screen
      - Responsive images (1x, 2x, 3x, 4x) for different screen densities
      - Updated index.html for splash integration
  - Shows immediately on app launch (before Flutter engine initializes)
  - Professional, fullscreen native experience across all platforms
  - No dependencies on Flutter runtime for initial display

- **Assets Added**
  - `assets/images/logo.png` (334KB PNG) - branding logo for login page
  - `assets/images/splash.jpg` (1.3MB JPG) - fullscreen splash image

### Changed
- **Login Page Redesign** (`lib/app/modules/login/views/login_view.dart`)
  - **Background**: Changed from primary teal color to white for cleaner, modern look
  - **Logo Display**:
    - Replaced generic material icon (`Icons.account_balance`) with actual branding logo
    - Using `assets/images/logo.png` (334KB PNG) for consistent branding
    - **Removed circular container and shadow** - logo displayed directly
    - **Removed ClipOval** - logo shows in full without clipping
    - Size: **120px height** (increased from 80px) with `BoxFit.contain`
  - **Removed Elements** for simpler, cleaner design:
    - Removed "MBG" title text
    - Removed "Pelaporan SPPG" subtitle
    - Removed "Kabupaten Bandung" subtitle
  - **Footer**: Changed text color from white to grey (`Colors.grey[600]`) for visibility on white background
  - More professional, minimalist login screen

- **Splash Screen Configuration in pubspec.yaml**
  - Added `flutter_native_splash` configuration section with fullscreen settings
  - Set `fullscreen: true` to fill entire screen
  - Configured `android_gravity: fill` for Android
  - Configured `ios_content_mode: scaleAspectFill` for iOS
  - Configured `web_image_mode: center` for Web
  - Android 12+ specific settings for modern Android devices

### Technical
- Updated version in `pubspec.yaml`: 0.6.3-alpha+20251015
- Added dev dependency: `flutter_native_splash: ^2.3.10`
- Generated platform-specific splash screen files via `dart run flutter_native_splash:create`
- Files auto-generated:
  - `android/app/src/main/res/drawable/launch_background.xml`
  - `android/app/src/main/res/drawable-v21/launch_background.xml`
  - `android/app/src/main/res/values-v31/styles.xml` (created)
  - `android/app/src/main/res/values-night-v31/styles.xml` (created)
  - `android/app/src/main/res/values/styles.xml` (updated)
  - `android/app/src/main/res/values-night/styles.xml` (updated)
  - `ios/Runner/Info.plist` (updated)
  - Web splash screen files (CSS and images)
- Updated `CLAUDE.md` with version and recent changes
- No breaking changes

### UI/UX Improvements
- ✅ **Instant Splash Screen**: Appears immediately (before Flutter loads)
- ✅ **Professional Look**: Platform-native splash screens
- ✅ **Brand Consistency**: Logo on login + splash image on launch
- ✅ **Better UX**: No blank white screen during app initialization
- ✅ **Multi-Platform**: Works on Android, iOS, and Web

---

## [0.6.2-alpha] - 2025-10-14

### Added
- **Form Success Screen** - Dedicated full-screen confirmation after form submission
  - New module: `lib/app/modules/form_success/` (controller, view, binding)
  - Replaces simple snackbar notification with comprehensive success page
  - **Animated UI Elements**:
    - Success icon with scale animation (Curves.elasticOut, 600ms)
    - Fade-in animation for content
    - Staggered animations for action buttons (800ms delay)
  - **Comprehensive Report Information Card**:
    - Report ID - Bold, prominent display with copy-to-clipboard button
    - Token - Unique tracking token with copy button
    - Submission timestamp - Formatted in Indonesian (d MMMM yyyy, HH:mm)
    - SKPD name - Displayed if available from API response
    - Report description - Summary of submitted report
  - **Three Action Buttons**:
    - Primary: "Lihat Detail Laporan" → Navigate to report detail page
    - Secondary: "Buat Laporan Lagi" → Create another report (returns to home then form)
    - Tertiary: "Kembali ke Home" → Navigate back to home page
  - **Copy-to-Clipboard Functionality**:
    - One-tap copy for Report ID
    - One-tap copy for Token
    - Success feedback with snackbar notification

### Changed
- **Form Submission Flow**
  - **Before**: Submit → Snackbar (4s) → Auto-close to home
  - **After**: Submit → Full-screen success page → User chooses action
  - Better user experience with clear confirmation
  - User can review report details before continuing
  - No more missed notifications due to short snackbar duration

- **DynamicFormController Updates**
  - Removed: `CustomSnackbar.success()` call after submission
  - Removed: Automatic `Get.back()` navigation
  - Added: `Get.offNamed(Routes.FORM_SUCCESS, arguments: response)`
  - Passes complete `FormSubmitResponseModel` to success screen

- **Routes Configuration**
  - Added `FORM_SUCCESS = '/form-success'` constant in `app_routes.dart`
  - Registered `FormSuccessView` with `FormSuccessBinding` in `app_pages.dart`

### Technical
- Updated version in `pubspec.yaml`: 0.6.2-alpha+20251014
- No new dependencies added (reuses existing packages)
- Maintains consistency with app design system (Teal theme, Material Design 3)
- Follows GetX architecture pattern
- Uses `intl` package for Indonesian date formatting

### UI/UX Improvements
- ✅ **Impossible to Miss**: Full-screen confirmation vs dismissible snackbar
- ✅ **More Informative**: Complete report details vs just ID
- ✅ **Clear Actions**: 3 explicit buttons vs automatic navigation
- ✅ **Better Tracking**: Copy buttons for ID & Token
- ✅ **User Control**: User decides next action
- ✅ **Professional Look**: Animated, polished UI

---

## [0.6.1-alpha] - 2025-10-14

### Added
- **MapViewerWidget** - New read-only map viewer widget
  - Created `lib/app/core/widgets/map_viewer_widget.dart`
  - Displays coordinates on interactive OpenStreetMap
  - Read-only mode (no tap-to-select, but allows pan/zoom)
  - Shows red marker pin at exact location
  - Compact 200px height with coordinate badge overlay
  - Bordered with theme color for visual consistency
  - Used in report detail to visualize coordinate answers

- **Coordinate Detection in QuestionAnswer Model**
  - New getter: `isCoordinate` - automatically detects coordinate format
  - New getter: `coordinateValues` - parses lat/lng from string
  - Supports formats: "-6.9175, 107.6191" or "-6.9175,107.6191"
  - Validates coordinate ranges (lat: -90 to 90, lng: -180 to 180)
  - Returns null if format is invalid

### Changed
- **Report Detail View - Unified Single Card Layout**
  - Complete UI refactor of `lib/app/modules/report_detail/views/report_detail_view.dart`
  - **Before**: Header info card + separate "Detail Jawaban" section with multiple cards
  - **After**: Single card containing header info + all Q&A answers
  - All items separated by dividers for consistent, clean appearance
  - Removed section title "Detail Jawaban" for simpler layout

- **Enhanced Answer Rendering**
  - Three specialized answer renderers:
    - `_buildAnswerRow` - for text-based answers
    - `_buildMapAnswerRow` - for coordinate answers with map display (NEW!)
    - `_buildImageAnswerRow` - for image answers with preview
  - Each answer type has appropriate icon (question, location, image)
  - Consistent format matching `_buildInfoRow` for header info

- **Automatic Answer Type Detection**
  - Priority order: Coordinate → Image → Text
  - Coordinate answers now show visual map instead of just text
  - More informative for users to see location on map

### Technical
- Updated version in `pubspec.yaml`: 0.6.1-alpha+20251014
- Removed unused import `dart:developer` from report_detail_view.dart
- Added import for `MapViewerWidget`
- No new dependencies added (reuses flutter_map from v0.6.0)

### UI/UX Improvements
- ✅ **Visual Coordinates**: Map shown for coordinate answers
- ✅ **Cleaner Layout**: Single card instead of scattered cards
- ✅ **Consistent Design**: All items use same format with dividers
- ✅ **Better Context**: Icons indicate answer type at a glance
- ✅ **More Compact**: Reduced vertical spacing, better use of screen space

---

## [0.6.0-alpha] - 2025-10-14

### Added
- **Interactive Map Picker with flutter_map**
  - Completely rewrote `MapPickerWidget` (`lib/app/core/widgets/map_picker_widget.dart`)
  - Full-screen interactive map picker using OpenStreetMap tiles
  - Tap anywhere on map to select coordinates
  - Real-time coordinate display with 6 decimal precision (latitude/longitude)
  - "Use My Location" button with GPS integration using geolocator package
  - Zoom in/out controls with floating action buttons
  - Instruction overlay for better user experience
  - Red marker pin for selected location
  - Default center: Bandung, Indonesia (-6.9175, 107.6191)
  - Fallback AppBar with "Simpan" (Save) button

- **Location Permissions**
  - Android: `ACCESS_FINE_LOCATION` and `ACCESS_COARSE_LOCATION` in AndroidManifest.xml
  - iOS: `NSLocationWhenInUseUsageDescription` and `NSLocationAlwaysUsageDescription` in Info.plist
  - Runtime permission handling with user-friendly error messages

### Changed
- **Replaced Map Dependencies**
  - Removed: `google_maps_flutter: ^2.5.3` (was not being used)
  - Added: `flutter_map: ^7.0.2` - Interactive map widget
  - Added: `latlong2: ^0.9.0` - Coordinate handling
  - Added: `geolocator: ^11.0.0` - GPS location services

- **MapPickerWidget Behavior**
  - Old: Dialog with manual latitude/longitude text input
  - New: Full-screen map picker with visual coordinate selection
  - More intuitive and accurate for users

### Technical
- Updated version in `pubspec.yaml`: 0.6.0-alpha+20251014
- No Google Maps API key required (uses free OpenStreetMap)
- Multi-platform support: Android, iOS, Web, Desktop
- Consistent with app design system (Teal theme, flat design)
- Fixed deprecation warning: `withOpacity()` → `withValues(alpha:)`

### Benefits
- ✅ **Free & Open Source**: No API key fees (OpenStreetMap)
- ✅ **Better UX**: Visual map selection vs manual input
- ✅ **More Accurate**: Tap and visual feedback vs typing coordinates
- ✅ **GPS Support**: Users can use their current location
- ✅ **Multi-platform**: Works on all Flutter platforms

---

## [0.5.1-alpha] - 2025-10-09

### Fixed
- **Report List Navigation**
  - Implemented navigation from report list to report detail page
  - Fixed TODO in `lib/app/modules/report_list/views/report_list_view.dart:169`
  - Users can now tap on any report card to view detailed information
  - Report ID is properly passed as argument to ReportDetailController

### Technical
- Updated version in `pubspec.yaml`: 0.5.1-alpha+20251009
- Updated version in `CLAUDE.md`: 0.5.1-alpha+20251009

---

## [0.5.0-alpha] - 2025-10-09

### Added
- **Report List Feature**
  - New `report_list` module with GetX pattern (controller, view, binding)
  - Two new data models:
    - `ReportListItemModel` - individual report item structure
    - `ReportListResponseModel` - API response wrapper
  - API integration for fetching submitted reports:
    - `getReportsSppg()` - GET `/data/pelaporan-tugas-satgas-mbg`
    - `getReportsIkl()` - GET `/data/pelaporan-tugas-satgas-mbg---dinkes---laporan-ikl`
  - Report list view features:
    - Pull-to-refresh functionality
    - Loading indicators
    - Empty state handling
    - Error handling with retry button
    - Report card displaying: ID, summary, location, date, created by
    - Total count display
  - New route: `REPORT_LIST` for viewing report lists

### Changed
- **Home Dashboard Menu Updates**
  - Replaced "Lihat Laporan" with 2 specific report list menus
  - New menu: "Buat Laporan" - shows dialog to choose form type (SPPG or IKL)
  - New menu: "Laporan SPPG" - navigates to SPPG report list
  - New menu: "Laporan IKL" - navigates to IKL Dinkes report list
  - Updated icons: `fileCirclePlus` (create), `fileLines` (SPPG list), `notesMedical` (IKL list)

### Technical
- Updated version in `pubspec.yaml`: 0.5.0-alpha+20251009
- Added routing for report list with type argument (sppg/ikl)
- Enhanced ContentProvider with 2 new API methods
- Report detail navigation prepared (currently shows snackbar)
- No local storage needed - reports fetched directly from API

---

## [0.4.1-alpha] - 2025-10-09

### Removed
- **Home Dashboard - Report Statistics Card**
  - Removed "Statistik Pelaporan" section from home view
  - Removed display of Total, Pending, Approved, and Rejected reports counters
  - Cleaned up unused `_buildStatItem()` helper method
  - Simplified home page layout for better focus on main features

### Technical
- Updated version in `pubspec.yaml`: 0.4.1-alpha+20251009
- Code cleanup: removed 60+ lines of unused statistics UI code

---

## [0.4.0-alpha] - 2025-10-08

### Added
- **API Integration for Carousel/Slides**
  - New model: `SlideModel` (`lib/app/data/models/slide_model.dart`)
  - Carousel now loads real-time data from API endpoint: `GET /api/site/12/slides`
  - Loading states with spinner indicator during API calls
  - Error handling with user-friendly error messages
  - Filters to show only active slides (status = 1)

- **API Integration for News/Posts**
  - Updated `NewsModel` to match API response structure
  - News list now loads from API endpoint: `GET /api/site/12/posts` (limited to 3 items)
  - Added new fields: `idPost`, `url` (slug), `imageSmallUrl`, `imageMiddleUrl`, `tags`, `createdAt`, `descriptionText`
  - Legacy compatibility with backward-compatible getters (`id`, `publishedDate`)
  - HTML tag stripping helper for plain text descriptions
  - Loading states with spinner indicator

- **News Detail Page**
  - New module: `news_detail` with GetX controller, view, and binding
  - Full news article display with HTML content rendering
  - Uses `flutter_html` package for rich content display
  - Hero image with loading and error states
  - Article metadata (date, author, category)
  - Tags display
  - Slug-based routing for SEO-friendly URLs
  - Fetches article data from API: `GET /api/site/12/post/{slug}`
  - Error handling with retry functionality

- **ContentProvider API Client**
  - New provider: `ContentProvider` (`lib/app/data/providers/content_provider.dart`)
  - Dio-based HTTP client with base URL configuration
  - Logging interceptor for debugging
  - Three API methods:
    - `getSlides()` - Fetch carousel slides
    - `getPosts({int? limit})` - Fetch news posts with optional limit
    - `getPostBySlug(String slug)` - Fetch single post by slug
  - Comprehensive error handling (timeout, connection errors, server errors)
  - Response parsing with success/data validation

### Changed
- **HomeController Updates**
  - Replaced dummy data with live API calls
  - Added loading states: `isLoadingBanners`, `isLoadingNews`
  - `_loadBanners()` now async, fetches from API
  - `_loadLatestNews()` now async, fetches from API
  - Converts `SlideModel` to `BannerItem` format
  - Error snackbars for failed API calls
  - Removed dependency on `NewsDummyData`

- **Home View Updates**
  - Carousel wrapped with loading indicator
  - News section wrapped with loading indicator
  - News cards now navigate to detail page on tap
  - Updated to use `news.imageSmallUrl` for thumbnails in horizontal layout
  - Navigation: `Get.toNamed(Routes.NEWS_DETAIL, arguments: news.url)`

- **Routes**
  - Added `NEWS_DETAIL` route constant in `app_routes.dart`
  - Registered `NewsDetailView` with `NewsDetailBinding` in `app_pages.dart`

### Technical
- Updated version in `pubspec.yaml`: 0.4.0-alpha+20251008
- Added dependency: `flutter_html: ^3.0.0-beta.2` for HTML content rendering
- Initialized `ContentProvider` in `main.dart` dependency injection
- API base URL: `https://api.bandungkab.go.id/api`
- API timeout: 10 seconds (connect and receive)
- All API endpoints use site ID: 12
- Added `dart:developer` logging for API debugging
- Fixed `AppTextStyles` to include Material Design 3 headline styles

### UI/UX Improvements
- **News Detail AppBar**: Transparent background with black foreground for cleaner look
- **News Card (Horizontal)**: Simplified layout - removed category badge overlay for better readability
- News card uses main `imageUrl` instead of `imageSmallUrl` to ensure better quality

### API Endpoints
- **Slides**: `GET https://api.bandungkab.go.id/api/site/12/slides`
- **Posts**: `GET https://api.bandungkab.go.id/api/site/12/posts`
- **Post Detail**: `GET https://api.bandungkab.go.id/api/site/12/post/{slug}`

---

## [0.3.0-alpha] - 2025-10-08

### Added
- **Radio Button Support in Dynamic Form**
  - New widget: `CustomRadioGroup` (`lib/app/core/widgets/custom_radio_group.dart`)
  - Support for `question_type: "radio"` in dynamic form builder
  - Uses `RadioListTile` for better UX
  - Displays options from API with format `{"text": "...", "value": "..."}`
  - Full validation support (required field, etc.)
  - Consistent styling with label, description, and required indicator (*)

### Changed
- **Updated DynamicFormBuilder**
  - Added `case 'radio'` in `_buildField()` method
  - Imported `custom_radio_group.dart`
  - Radio field values stored as String in formValues

### Technical
- Updated version in `pubspec.yaml`: 0.3.0-alpha+20251008
- Dynamic form now supports 8 field types: text, number, textarea, dropdown, radio, date, map, image

---

## [0.2.1-alpha] - 2025-10-07

### Added
- **New Form Menu**: Laporan IKL Dinkes menu item in home dashboard
  - Slug: `pelaporan-tugas-satgas-mbg---dinkes---laporan-ikl`
  - Icon: Medical file icon (FontAwesome `fileMedical`)
- **Custom Snackbar Widget** (`lib/app/core/widgets/custom_snackbar.dart`)
  - `CustomSnackbar.success()` - Green snackbar with check icon
  - `CustomSnackbar.error()` - Red snackbar with error icon
  - `CustomSnackbar.warning()` - Orange snackbar with warning icon
  - `CustomSnackbar.info()` - Teal snackbar with info icon
  - Consistent styling with proper margins, border radius, and dismissible behavior

### Changed
- **Refactored form_sppg module to dynamic_form** for better reusability
  - Renamed folder: `lib/app/modules/form_sppg/` → `lib/app/modules/dynamic_form/`
  - Renamed controller: `FormSppgController` → `DynamicFormController`
  - Renamed view: `FormSppgView` → `DynamicFormView`
  - Renamed binding: `FormSppgBinding` → `DynamicFormBinding`
  - Form slug now dynamically passed via route arguments instead of hardcoded
  - Routes updated: `Routes.FORM_SPPG` → `Routes.DYNAMIC_FORM`
- **Updated HomeController**
  - `navigateToFormSppg()` → `navigateToDynamicForm(String slug)`
  - Now accepts slug parameter for dynamic form navigation
- **Replaced all snackbar implementations**
  - Replaced `Get.snackbar()` with `CustomSnackbar` helper in:
    - `DynamicFormController` (4 occurrences)
    - `HomeView` (3 occurrences)
    - `HomeController` (1 occurrence)
  - Improved consistency and user experience

### Technical
- Updated version in `pubspec.yaml`: 0.2.1-alpha+20251007
- Updated `CLAUDE.md` with new version info and recent changes
- Updated project structure documentation to reflect dynamic_form module

---

## [0.2.0-alpha] - 2025-10-07

### Added
- **Banner Carousel** on home dashboard
  - Auto-play functionality
  - Multiple banners with images and descriptions
  - Tap handler for banner interactions
- **News System**
  - News model with dummy data
  - Horizontal and vertical card layouts
  - Category badges
  - Indonesian date formatting support
  - "Latest News" section on home page (3 articles)
  - "View All" button (placeholder)
- **Gradient Button Component** (`lib/app/core/widgets/gradient_button.dart`)
  - Consistent gradient styling across the app
  - Support for icons, loading state, and customizable dimensions

### Changed
- **Updated Design System**
  - Changed to flat design (no elevation on cards)
  - Added borders to cards for visual separation
  - White background with clean, modern look
- **Home Dashboard Layout**
  - Changed services grid from 2 columns to 3 columns
  - Removed subtitle from service grid items
  - Hidden user info card (will be moved to future Profile page)
- **Report Statistics Card**
  - Flat design with bordered stat items
  - Color-coded statistics (Total, Pending, Approved, Rejected)

### Fixed
- **LocaleDataException** for Indonesian date formatting
  - Properly initialized Indonesian locale (id_ID) in main.dart
  - Fixed date formatting issues in news cards

### Technical
- Initial alpha release with core features
- GetX architecture pattern implementation
- API integration with dynamic form builder
- Token-based authentication system

---

## Version Naming Convention

- **Format**: `MAJOR.MINOR.PATCH-stage+BUILD_DATE`
- **Stage**: alpha, beta, rc (release candidate), or omitted for stable
- **Build Date**: YYYYMMDD format

### Examples:
- `0.2.1-alpha+20251007` - Alpha version 0.2.1 built on October 7, 2025
- `1.0.0-beta+20251115` - Beta version 1.0.0 built on November 15, 2025
- `1.0.0+20251201` - Stable version 1.0.0 built on December 1, 2025

---

## Categories Reference

- **Added**: New features
- **Changed**: Changes in existing functionality
- **Deprecated**: Soon-to-be removed features
- **Removed**: Removed features
- **Fixed**: Bug fixes
- **Security**: Security fixes
- **Technical**: Technical changes, dependencies, configurations
