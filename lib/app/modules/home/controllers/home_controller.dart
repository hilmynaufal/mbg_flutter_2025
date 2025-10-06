import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/models/user_model.dart';
import '../../../routes/app_routes.dart';

class HomeController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  // Observable user
  Rx<UserModel?> user = Rx<UserModel?>(null);

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
  }

  // Load user data
  void _loadUserData() {
    user.value = _authService.getUser();
  }

  // Navigate to Form SPPG
  void navigateToFormSppg() {
    Get.toNamed(Routes.FORM_SPPG);
  }

  // Logout
  Future<void> logout() async {
    // Show confirmation dialog
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Konfirmasi Logout'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _authService.logout();
      Get.offAllNamed(Routes.LOGIN);
      Get.snackbar(
        'Logout Berhasil',
        'Anda telah keluar dari aplikasi',
        snackPosition: SnackPosition.TOP,
      );
    }
  }
}
