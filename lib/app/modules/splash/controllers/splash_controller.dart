import 'package:get/get.dart';
import 'dart:developer';
import '../../../data/services/auth_service.dart';
import '../../../routes/app_routes.dart';

class SplashController extends GetxController {
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

      log('SplashController: Timer completed, checking auth status');

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
}
