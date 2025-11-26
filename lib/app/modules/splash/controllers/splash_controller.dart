import 'package:get/get.dart';
import 'dart:developer';
import '../../../data/services/auth_service.dart';
import '../../../data/services/version_service.dart';
import '../../../core/widgets/update_dialog.dart';
import '../../../routes/app_routes.dart';

class SplashController extends GetxController {
  final VersionService _versionService = VersionService();

  @override
  void onInit() {
    super.onInit();
    log('SplashController: onInit called');
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    try {
      log('SplashController: Starting navigation timer');

      // Wait 2 seconds before navigating
      await Future.delayed(const Duration(seconds: 2));

      log('SplashController: Timer completed, checking version...');

      // Check for app updates
      final shouldBlockNavigation = await _checkAppVersion();

      // If force update is required, stop navigation here
      if (shouldBlockNavigation) {
        log('SplashController: Navigation blocked due to force update');
        return;
      }

      log('SplashController: Version check completed, checking auth status');

      // Get AuthService
      final authService = Get.find<AuthService>();
      final isLoggedIn = authService.isLoggedIn;

      log('SplashController: User logged in status: $isLoggedIn');

      if (isLoggedIn) {
        // User is logged in, navigate to home
        log('SplashController: Navigating to HOME');
        Get.offAllNamed(Routes.HOME);
      } else {
        // User is not logged in, navigate to login
        log('SplashController: Navigating to LOGIN');
        Get.offAllNamed(Routes.LOGIN);
      }
    } catch (e) {
      log('SplashController: Error during navigation - $e');
      // Fallback to login on error
      Get.offAllNamed(Routes.LOGIN);
    }
  }

  /// Check app version and show update dialog if needed
  /// Returns true if navigation should be blocked (force update required)
  Future<bool> _checkAppVersion() async {
    try {
      log('Checking app version...', name: 'SplashController');

      final versionData = await _versionService.checkForUpdate();

      log('Version data: ${versionData?.toJson().toString()}', name: 'SplashController');

      if (versionData == null) {
        log('Version check returned null, skipping update check', name: 'SplashController');
        return false; // Don't block navigation
      }

      // Check if force update is required
      if (versionData.forceUpdate) {
        log('Force update required!', name: 'SplashController');
        UpdateDialog.show(
          versionData: versionData,
          isForceUpdate: true,
        );
        return true; // Block navigation - force update required
      }

      // Check if optional update is available
      if (versionData.optionalUpdate) {
        log('Optional update available', name: 'SplashController');
        UpdateDialog.show(
          versionData: versionData,
          isForceUpdate: false,
        );
        // Continue with navigation after showing dialog
      }

      return false; // Don't block navigation
    } catch (e) {
      log('Error checking version: $e', name: 'SplashController');
      // Don't block navigation on version check errors
      return false;
    }
  }
}
