# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
