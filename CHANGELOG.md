# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.11.0-alpha] - 2025-12-04

### Added
- **Restructured Dashboards**
  - Implemented three distinct dashboards: **Bedas Menanam**, **Posyandu**, and **MBG & SPPG**.
  - Each dashboard features a premium design with:
    - **SliverAppBar**: Collapsible header with theme-specific gradient and background pattern.
    - **Banner Carousel**: Dedicated banner section for each service.
    - **Statistics Section**: Key metrics displayed in a horizontal list.
    - **Menu Grid**: Quick access to specific services with updated design.
    - **News Feed**: Relevant news and activities for each dashboard.

### Changed
- **Home View Refactor**
  - Updated `HomeView` to navigate to the new dashboards instead of direct service links.
  - Refactored `ServiceGridItem` to support custom colors and improved "NEW" badge positioning.
  - "NEW" badge is now attached to the icon container for a cleaner look.

- **Dashboard Theming**
  - **Bedas Menanam**: Green theme with leaf pattern.
  - **Posyandu**: Red/Pink theme with heart/pulse pattern.
  - **MBG & SPPG**: Blue theme with utensils pattern.

### Technical Details
- **Modular Architecture**
  - Created separate modules for each dashboard (`bedas_menanam_dashboard`, `posyandu_dashboard`, `mbg_sppg_dashboard`).
  - Each module has its own Controller, View, and Binding.
- **Reusable Components**
  - Updated `ServiceGridItem` to be more flexible with color and badge positioning.
  - Reused `BannerCarouselWidget` and `NewsCardWidget` across all dashboards.
- **Dummy Data Integration**
  - Controllers currently use dummy data for banners, statistics, and news to facilitate UI development and testing.

## [0.10.0-alpha] - 2025-11-26

### Added
- **Version Update Check System**
  - Automatic version check on app startup (splash screen)
  - API integration with version endpoint: `https://hirumi.xyz/fallback_api/api/version/check?version=x.x.x`
  - Current app version sent as query parameter `version` (e.g., `?version=0.10.0-alpha`)
  - Support for two update modes:
    - **Force Update**: User MUST update to continue (dialog cannot be dismissed)
    - **Optional Update**: User can choose "Update Now" or "Later"
  - Created VersionCheckResponseModel for API response handling
  - Created VersionProvider for API communication
  - Created VersionService for version comparison logic
  - Created UpdateDialog widget with Material Design 3 styling
  - Display current version vs latest version in dialog
  - Custom update messages from API
  - Direct link to Play Store (Android) and App Store (iOS)
  - Semantic version comparison (supports "x.y.z" format)
  - Clean version parsing (removes suffixes like "-alpha", "+build")

- **Dependencies**
  - Added `package_info_plus: ^6.0.0` - for getting current app version
  - Added `url_launcher: ^6.2.5` - for opening app stores

### Changed
- **Posyandu Edit Module - Search Flow Improvement**
  - Changed flow from direct navigation to list selection
  - **Before**: Search by phone → Direct navigate to detail page
  - **After**: Search by phone → Show list of matching posyandu → User selects → Navigate to detail
  - Added `filteredPosyanduList` to store search results
  - Added `hasSearched` flag to track search state
  - Enhanced UI with three states:
    1. Before search: Help message
    2. No results: Empty state with icon and message
    3. Results found: Scrollable list with PosyanduCard
  - Search results show count: "Ditemukan X Posyandu"
  - Better UX: Users can now see all posyandu with same phone number

- **Form Success Page - Back Button Behavior**
  - Wrapped view with `PopScope` to intercept back button
  - Back button (hardware/gesture/system) now redirects to Home instead of form
  - Prevents users from accidentally returning to submitted form
  - Consistent behavior across platforms (Android hardware back, iOS swipe gesture)
  - Clean navigation stack with `Get.until()` to Home route

- **Splash Controller - Version Check Integration**
  - Added version check before navigation
  - Returns boolean flag to block/allow navigation
  - Force update blocks navigation completely
  - Optional update shows dialog but continues navigation
  - Error-tolerant: Navigation continues even if version check fails

### Fixed
- **Version Check Dialog Not Showing**
  - Fixed navigation flow in SplashController
  - Changed `_checkAppVersion()` to return `Future<bool>`
  - `true` = block navigation (force update required)
  - `false` = continue navigation (no update or optional update)
  - Dialog now properly displays before navigation occurs

- **Deprecated API Usage**
  - Replaced `WillPopScope` with `PopScope` in UpdateDialog (Flutter 3.12+)
  - Updated to use `canPop` and `onPopInvokedWithResult` parameters

### Technical Details
- **Version Check Flow**:
  1. App launches → Splash screen (2s delay)
  2. Get current version from package_info_plus
  3. Call version API: `GET /version/check?version={currentVersion}`
  4. Backend compares version and returns update status
  5. If force_update = true → Show dialog, block navigation
  6. If optional_update = true → Show dialog, continue navigation
  7. If no update → Continue to login/home

- **API Request Example**:
  - URL: `https://hirumi.xyz/fallback_api/api/version/check?version=0.10.0-alpha`
  - Method: GET
  - Query Parameter: `version` (current app version)

- **Version Service Methods**:
  - `getCurrentVersion()` - Get app version from package_info
  - `checkForUpdate()` - Call API and return VersionData
  - `compareVersions()` - Semantic version comparison
  - `isForceUpdateRequired()` - Check if force update needed
  - `isOptionalUpdateAvailable()` - Check if optional update available

- **New Files Created**:
  - `lib/app/data/models/version_check_response_model.dart`
  - `lib/app/data/providers/version_provider.dart`
  - `lib/app/data/services/version_service.dart`
  - `lib/app/core/widgets/update_dialog.dart`

- **Updated Files**:
  - `lib/app/modules/splash/controllers/splash_controller.dart`
  - `lib/app/modules/posyandu_edit/controllers/posyandu_edit_controller.dart`
  - `lib/app/modules/posyandu_edit/views/posyandu_edit_view.dart`
  - `lib/app/modules/form_success/views/form_success_view.dart`
  - `lib/app/core/values/constants.dart`
  - `pubspec.yaml`

- **Constants Updated**:
  - Added `baseUrlFallback` - Fallback API base URL
  - Added `versionCheckEndpoint` - Version check API endpoint
  - Added `appName`, `androidPackageName`, `iosAppId`
  - Added `playStoreUrl`, `appStoreUrl`

- Updated version to 0.10.0-alpha+20251126

### Benefits
- ✅ **Version Control**: Automatic version management and update notifications
- ✅ **Force Update Support**: Can enforce critical updates for security/compatibility
- ✅ **Better UX in Posyandu Search**: Users can now see and choose from multiple results
- ✅ **Cleaner Navigation**: Form success properly redirects to home on back button
- ✅ **Platform Independent**: Version check works on all platforms
- ✅ **Non-Blocking**: Version check errors don't prevent app usage
- ✅ **Customizable Messages**: Backend can set custom update messages per version

---

## [0.6.13-alpha] - 2025-11-04

### Fixed
- **Improper Use of GetX Error in Report Detail**
  - Fixed "improper use of getx" error when viewing non-pelaporan-penerima-mbg reports
  - Obx now only used for pelaporan-penerima-mbg reports (where fallbackImages is reactive)
  - Other report types use static widget without Obx wrapper
  - Created reusable `_buildImageWidget()` helper method for both cases

### Technical Details
- Refactored `_buildImageAnswer()` method in report_detail_view.dart
- Added conditional logic: if reportSlug == 'pelaporan-penerima-mbg' → use Obx, else → use static widget
- New helper method: `_buildImageWidget(imageUrl, fallbackUrl)` - shared by both branches
- Eliminates unnecessary reactive subscription for non-penerima-mbg reports
- Updated version to 0.6.13-alpha+20251104

### Benefits
- ✅ **No More GetX Errors**: Obx only used when actually needed
- ✅ **Better Performance**: No unnecessary reactive subscriptions
- ✅ **Cleaner Code**: Reusable widget builder method
- ✅ **Proper Scope**: Reactive logic isolated to specific report type

---

## [0.6.12-alpha] - 2025-11-04

### Fixed
- **Delete Report Flow Enhancement**
  - Fixed loading state management - `isLoading` now properly reset to false after successful deletion
  - Fixed page close timing - detail page closes immediately after API success response
  - Fixed list refresh - report list automatically reloads after returning from deleted report
  - Added comprehensive logging for debugging delete flow:
    - Log after API delete success
    - Log after local storage removal
    - Log before closing detail page
    - Log when list refresh is triggered
    - Log after list refresh completes

### Technical Details
- `isLoading.value = false` now called before `Get.back()` in deleteReport()
- `await controller.loadReports()` ensures list fully reloads before proceeding
- Added `dart:developer` import for logging in report_list_view.dart
- Better error logging with context in catch blocks
- Updated version to 0.6.12-alpha+20251104

### Flow After Delete:
1. User confirms delete → Show loading indicator
2. API delete called → Wait for response
3. After success response → Remove from reportIds + local storage (if penerima-mbg)
4. Reset loading state → `isLoading = false`
5. Show success snackbar
6. Close detail page → `Get.back(result: true)`
7. List detects result == true → Auto refresh
8. User sees updated list without deleted report

---

## [0.6.11-alpha] - 2025-11-04

### Added
- **Delete Report Feature with Local Storage Sync**
  - Added delete button (trash icon) in report detail AppBar
  - Confirmation dialog before deletion
  - Delete from API server first
  - If successful and report is pelaporan-penerima-mbg, also remove from local storage
  - Automatic refresh of report list after deletion
  - Custom success/error snackbar notifications

### Changed
- **ReportDetailController Enhancement**
  - Added `_removeFromLocalStorage()` private method
  - Automatically syncs local storage deletion for pelaporan-penerima-mbg reports
  - Enhanced deleteReport() method with better error handling
  - Returns result (true) to indicate successful deletion
  - Uses CustomSnackbar for consistent UI feedback

- **ReportListView Navigation Update**
  - Changed onTap to async function to await navigation result
  - Automatically refreshes report list if deletion occurred (result == true)
  - Ensures UI stays in sync with backend and local storage

### Technical Details
- Delete API endpoint: DELETE /api/form/delete/{id}
- Local storage sync only for pelaporan-penerima-mbg reports
- Other report types (SPPG, IKL) only deleted from API (no local storage)
- Error handling doesn't block if local storage removal fails
- Added imports: ReportListItemModel, CustomSnackbar
- Updated version to 0.6.11-alpha+20251104

### Benefits
- ✅ **Data Consistency**: Local storage always in sync with server
- ✅ **Better UX**: Immediate feedback and automatic list refresh
- ✅ **Safe Operation**: Confirmation dialog prevents accidental deletion
- ✅ **Graceful Degradation**: Local storage errors don't fail the operation

---

## [0.6.10-alpha] - 2025-11-04

### Changed
- **Updated Application Launcher Icon**
  - Regenerated launcher icons for all platforms with new logo
  - Updated `assets/images/logo.png` with new branding design
  - Icons generated for:
    - Android - default launcher icon
    - iOS - app icon
    - Web - favicon and app icons
    - Windows - application icon
    - MacOS - app icon
  - Consistent branding across all platforms

### Technical
- Updated version to 0.6.10-alpha+20251104
- Used flutter_launcher_icons v0.13.1 for icon generation
- All platform-specific icon files regenerated automatically

---

## [0.6.9-alpha] - 2025-11-04

### Added
- **Local Storage for Pelaporan Penerima MBG Reports**
  - Created local storage system specifically for `pelaporan-penerima-mbg` reports
  - Reports automatically saved to local storage on every successful submission
  - Report list ("Laporan Harian Saya") now loads from local storage instead of API
  - Significantly faster load times for report list (instant access)
  - Offline access to submitted reports
  - Most recent reports displayed first (insert at beginning of list)

- **Storage Service Enhancements**
  - Added `writeObjectList()` method - save list of objects as JSON to SharedPreferences
  - Added `readObjectList()` method - read list of objects from JSON in SharedPreferences
  - Uses `jsonEncode()` and `jsonDecode()` for serialization
  - Type-safe conversion with `List<Map<String, dynamic>>`

- **New Storage Constant**
  - Added `AppConstants.keyPenerimaMbgReports = 'penerima_mbg_reports'`
  - Dedicated storage key for local report caching

### Changed
- **DynamicFormController - Local Save on Submit**
  - Added `_saveReportToLocalStorage()` method (lines 254-319)
  - Automatically saves full report data after successful submission
  - Extracts all form values from `formValues` Map
  - Converts different value types to storable format:
    - DateTime → ISO date string (yyyy-MM-dd)
    - Map<String, double> (coordinates) → "lat,lng" string
    - File (images) → file path string
    - Other types → string conversion
  - Constructs complete `ReportListItemModel` with all metadata
  - Loads existing reports, prepends new report, saves back to storage
  - Error handling doesn't block submission flow (silent failure with logging)
  - Only runs for `formSlug == 'pelaporan-penerima-mbg'`

- **ReportListController - Load from Local Storage**
  - Updated `loadReports()` method to check report type
  - If `reportType == 'penerima-mbg'`, loads from local storage instead of API
  - No network request required for penerima-mbg reports
  - Custom metadata for local storage:
    - Page title: "Laporan Harian Saya"
    - Description: "Daftar laporan penerima MBG yang tersimpan di perangkat Anda"
    - Total count: based on local storage length
  - Other report types (SPPG, IKL) continue using API as before
  - Added imports: `StorageService`, `AppConstants`

### Technical Details
- Local storage uses SharedPreferences via StorageService
- JSON encoding format for list of objects
- Report detail field constructed from form structure and values
- File paths stored for images (limitation: won't work if files deleted)
- Data persists across app restarts
- No API dependency for penerima-mbg report list
- Report detail page still fetches from API (as designed)
- Updated version to 0.6.9-alpha+20251104

### Benefits
- ✅ **Instant Load**: No API delay for report list
- ✅ **Offline Access**: View reports without internet connection
- ✅ **Reduced API Calls**: Less server load for frequent list views
- ✅ **Better UX**: Faster, smoother user experience
- ✅ **Data Persistence**: Reports saved locally for reliable access

### Known Limitations
- Image file paths stored as strings (won't display if original files deleted)
- Local storage only for penerima-mbg reports (SPPG/IKL still use API)
- Report detail still fetched from API for complete data accuracy

---

## [0.6.8-alpha] - 2025-11-04

### Changed
- **Service Grid Item UI Improvements**
  - Reduced grid item size for more compact layout
  - Padding reduced: 16px → 12px
  - Icon container size: 48x48 → 40x40
  - Icon size: 24 → 20
  - Spacing between icon and title: 8px → 6px
  - Grid items now look smaller and more tightly packed

- **Menu Reordering with NEW Badges**
  - Moved "Pelaporan Penerima MBG" to first position
  - Moved "Laporan Harian Saya" to second position
  - Added red "NEW" badge to both new menu items
  - Badge positioned at top-right corner of grid item
  - Existing menus (Buat Laporan, Laporan SPPG, Laporan IKL) moved down

### Fixed
- **Slug Detection for Fallback Images**
  - Fixed bug where API doesn't return slug in report detail response
  - Now passing slug from report list page to report detail page
  - Added `slug` getter in ReportListController (converts report type to slug)
  - Updated navigation to pass Map with `{id, slug}` instead of just id
  - Updated ReportDetailController to accept both formats (backward compatible)
  - Updated FormSuccessController to pass slug to report detail
  - Fallback image detection now works correctly for pelaporan-penerima-mbg

- **Fallback Images Display on First Load**
  - Wrapped `_buildImageAnswer()` with Obx for proper reactivity
  - Fallback images now appear correctly on first page load
  - FallbackImageWidget properly updates when fallbackUrl becomes available
  - No need to refresh page to see fallback images

- **Full Screen Image View with Fallback Support**
  - Updated `_showFullScreenImage()` to accept and use fallback URL
  - Full screen dialog now uses FallbackImageWidget instead of Image.network
  - Tap on image now properly shows fallback if primary fails
  - Consistent fallback behavior across thumbnail and full screen views

- **Added Debugging Logs for Duplicate Fields Issue**
  - Added logging to track answer rendering count
  - Added logging for each individual answer being rendered
  - Helps diagnose if duplication is from API or rendering

### Added
- **Fallback API Integration for Image Uploads**
  - Created `FallbackApiProvider` for fallback image storage
  - Automatic upload to fallback API after successful form submission (pelaporan-penerima-mbg only)
  - Fallback API endpoint: `http://hirumi.xyz/fallback_api/api/image-paths`
  - Supports 3 image fields: dokumentasi_foto_1, dokumentasi_foto_2, dokumentasi_foto_3
  - Multipart/form-data upload format
  - Errors in fallback API don't block main submission flow

- **Image Display with Fallback Support**
  - Created `FallbackImageWidget` - tries primary URL first, then fallback URL on error
  - Automatic fallback image loading if primary image fails
  - Only shows error if both primary and fallback fail
  - Includes loading indicators and error states

- **"Laporan Harian Saya" Menu**
  - New menu item in home dashboard (5th menu)
  - Title: "Laporan Harian Saya"
  - Icon: clipboard-check (FontAwesome)
  - Displays list of pelaporan-penerima-mbg reports
  - Shows all reports (no user filtering)

- **Report List for Penerima MBG**
  - Added `getReportsPenerimaMbg()` method to ContentProvider
  - API endpoint: `GET /data/pelaporan-penerima-mbg`
  - Integrated with existing ReportListController
  - Supports pull-to-refresh and error handling

### Changed
- **DynamicFormController Enhancement**
  - Added automatic fallback API upload for pelaporan-penerima-mbg form
  - Intelligently matches image fields by question text
  - Uses AuthService to get current user ID
  - Fallback upload runs asynchronously (doesn't block success screen)

- **ReportDetailController Enhancement**
  - Added fallback image fetching for pelaporan-penerima-mbg reports
  - Loads fallback images automatically when viewing report detail
  - Fallback data stored in reactive variable
  - Silent failure if fallback API unavailable

- **ReportDetailView Image Display**
  - Updated to use FallbackImageWidget for all images
  - Automatic fallback for pelaporan-penerima-mbg reports
  - Maintains existing functionality for other report types
  - Better error handling and user experience

- **ReportListController**
  - Added support for 'penerima-mbg' report type
  - Three report types now supported: sppg, ikl, penerima-mbg
  - Consistent error handling across all types

### Technical Details
- New files:
  - `lib/app/data/providers/fallback_api_provider.dart`
  - `lib/app/data/models/fallback_image_model.dart`
  - `lib/app/core/widgets/fallback_image_widget.dart`
- Fallback scope: Only for `pelaporan-penerima-mbg` form/reports
- No breaking changes to existing forms (SPPG, IKL)
- Performance: Fallback only triggered on image load failure
- Updated pubspec.yaml version to 0.6.8-alpha+20251104

---

## [0.6.7-alpha] - 2025-11-03

### Added
- **New Menu Item: Pelaporan Penerima MBG**
  - Added 4th menu item to home dashboard services grid
  - Title: "Pelaporan Penerima MBG"
  - Icon: clipboard-list (FontAwesome)
  - Type: Form submission (dynamic form)
  - Form slug: `pelaporan-penerima-mbg`
  - Navigates to dynamic form builder with API-driven form structure
  - Uses existing DynamicFormController for form handling

### Technical
- Updated `home_view.dart` to include 4th ServiceGridItem in Wrap widget
- Form structure loaded from API endpoint: `/form/create/pelaporan-penerima-mbg`
- Follows existing pattern with other form types (SPPG, IKL Dinkes)
- Updated pubspec.yaml version to 0.6.7-alpha+20251103

---

## [0.6.6-alpha] - 2025-10-24

### Changed
- **Updated Application Launcher Icon**
  - Changed launcher icon to `assets/images/logo.png` for all platforms
  - Generated icons for Android, iOS, macOS, Windows, Linux, and Web
  - Branding consistency across all platforms with MBG Kabupaten Bandung logo

- **Updated Application Display Name**
  - Changed application name from "mbg_flutter_2025" to "Satgas MBG Kabupaten Bandung"
  - Updated for all platforms:
    - Android: AndroidManifest.xml application label
    - iOS: Info.plist CFBundleDisplayName and CFBundleName
    - macOS: Info.plist CFBundleName
    - Windows: window.Create() title parameter
    - Linux: gtk_header_bar_set_title and gtk_window_set_title
    - Web: HTML title tag and apple-mobile-web-app-title meta tag

### Technical
- Updated pubspec.yaml version to 0.6.6-alpha+20251024
- Added flutter_launcher_icons dependency (^0.13.1) to dev_dependencies
- Generated platform-specific launcher icons using flutter_launcher_icons tool
- Configured launcher icons for all platforms in pubspec.yaml

---

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
