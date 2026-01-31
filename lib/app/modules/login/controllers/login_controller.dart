import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/auth_service.dart';

import '../../../routes/app_routes.dart';

class LoginController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  // final OtpProvider _otpProvider = OtpProvider();

  // Text editing controllers - PNS
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // Text editing controllers - Non-PNS
  final nikController = TextEditingController();

  // Form key
  final formKey = GlobalKey<FormState>();

  // Observable states
  final RxBool isLoading = false.obs;
  final RxBool isPasswordVisible = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isPnsLogin = true.obs; // true = PNS login, false = Non-PNS login

  @override
  void onInit() {
    super.onInit();
    // Check if already logged in
    if (_authService.isLoggedIn) {
      // Navigate to home if already logged in
      Future.delayed(Duration.zero, () {
        Get.offAllNamed(Routes.HOME);
      });
    }
  }

  @override
  void onClose() {
    // Dispose PNS controllers
    usernameController.dispose();
    passwordController.dispose();
    // Dispose Non-PNS controllers
    nikController.dispose();
    // Cancel timer

    super.onClose();
  }

  // Toggle between PNS and Non-PNS login
  void toggleLoginType() {
    isPnsLogin.value = !isPnsLogin.value;
    // Clear error message when switching
    errorMessage.value = '';
    // Clear controllers
    usernameController.clear();
    passwordController.clear();
    nikController.clear();
  }

  // Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // Validate username
  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username tidak boleh kosong';
    }
    return null;
  }

  // Validate password
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    return null;
  }

  // Validate NIK (must be 16 digits) - Used as username for Non-PNS
  String? validateNik(String? value) {
    if (value == null || value.isEmpty) {
      return 'NIK tidak boleh kosong';
    }
    // Remove any whitespace
    final cleanedValue = value.trim();
    // Check if it's exactly 16 digits
    if (cleanedValue.length != 16) {
      return 'NIK harus 16 digit';
    }
    // Check if it contains only numbers
    if (!RegExp(r'^[0-9]+$').hasMatch(cleanedValue)) {
      return 'NIK harus berupa angka';
    }
    return null;
  }

  // Login method - unified for both PNS and Non-PNS
  Future<void> login() async {
    if (isPnsLogin.value) {
      await loginPns();
    } else {
      await loginNonPns();
    }
  }

  // Login PNS method (API authentication)
  Future<void> loginPns() async {
    // Clear previous error
    errorMessage.value = '';

    // Validate form
    if (!formKey.currentState!.validate()) {
      return;
    }

    // Start loading
    isLoading.value = true;

    try {
      final success = await _authService.login(
        username: usernameController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (success) {
        // Show success message
        Get.snackbar(
          'Login Berhasil',
          'Selamat datang ${_authService.currentUser?.nmLengkap ?? ''}',
          backgroundColor: Get.theme.colorScheme.primary,
          colorText: Get.theme.colorScheme.onPrimary,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 2),
        );

        // Navigate to home
        Get.offAllNamed(Routes.HOME);
      }
    } catch (e) {
      // Show error message
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      Get.snackbar(
        'Login Gagal',
        errorMessage.value,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
      );
    } finally {
      // Stop loading
      isLoading.value = false;
    }
  }

  // Login Non-PNS method (Using endpoint)
  Future<void> loginNonPns() async {
    // Clear previous error
    errorMessage.value = '';

    // Validate form
    if (!formKey.currentState!.validate()) {
      return;
    }

    // Start loading
    isLoading.value = true;

    try {
      // Verify NIK and Password are provided (using existing controllers or new ones)
      // We reuse usernameController for NIK and passwordController for Password?
      // Or use nikController?
      // Let's use nikController for username involved in Non-PNS login to correspond with "NIK" label.
      // And we need a password controller for Non-PNS. Reuse passwordController.

      final success = await _authService.loginNonPns(
        username: nikController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (success) {
        // Show success message
        Get.snackbar(
          'Login Berhasil',
          'Selamat datang ${_authService.currentUser?.nmLengkap ?? ''}',
          backgroundColor: Get.theme.colorScheme.primary,
          colorText: Get.theme.colorScheme.onPrimary,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 2),
        );

        // Navigate to home
        Get.offAllNamed(Routes.HOME);
      }
    } catch (e) {
      // Show error message
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      Get.snackbar(
        'Login Gagal',
        errorMessage.value,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
      );
    } finally {
      // Stop loading
      isLoading.value = false;
    }
  }

  // Show Guest login confirmation dialog
  Future<void> showGuestLoginDialog() async {
    await Get.dialog(
      AlertDialog(
        title: const Text('Login sebagai Tamu?'),
        content: const Text(
          'Dengan login sebagai tamu, Anda hanya dapat mengakses menu terbatas. '
          'Beberapa fitur mungkin tidak tersedia.\n\n'
          'Lanjutkan tanpa akun?',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back(); // Close dialog
              loginGuest(); // Proceed with guest login
            },
            child: const Text('Ya, Lanjutkan'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  // Login Guest method (local storage only, no fields required)
  Future<void> loginGuest() async {
    // Clear previous error
    errorMessage.value = '';

    // Start loading
    isLoading.value = true;

    try {
      final success = await _authService.loginGuest();

      if (success) {
        // Show success message
        Get.snackbar(
          'Login Berhasil',
          'Selamat datang, Pengguna Tamu',
          backgroundColor: Get.theme.colorScheme.primary,
          colorText: Get.theme.colorScheme.onPrimary,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 2),
        );

        // Navigate to home
        Get.offAllNamed(Routes.HOME);
      }
    } catch (e) {
      // Show error message
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      Get.snackbar(
        'Login Gagal',
        errorMessage.value,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
      );
    } finally {
      // Stop loading
      isLoading.value = false;
    }
  }
}
