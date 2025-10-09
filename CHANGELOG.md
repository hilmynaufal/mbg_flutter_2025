# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
