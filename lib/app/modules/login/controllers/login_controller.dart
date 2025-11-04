import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/auth_service.dart';
import '../../../routes/app_routes.dart';

class LoginController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  // Text editing controllers - PNS
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // Text editing controllers - Non-PNS
  final nikController = TextEditingController();
  final namaController = TextEditingController();
  final emailController = TextEditingController();

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
    namaController.dispose();
    emailController.dispose();
    super.onClose();
  }

  // Toggle between PNS and Non-PNS login
  void toggleLoginType() {
    isPnsLogin.value = !isPnsLogin.value;
    // Clear error message when switching
    errorMessage.value = '';
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

  // Validate NIK (must be 16 digits)
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

  // Validate nama
  String? validateNama(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nama tidak boleh kosong';
    }
    if (value.trim().length < 3) {
      return 'Nama minimal 3 karakter';
    }
    return null;
  }

  // Validate email
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email tidak boleh kosong';
    }
    // Basic email validation
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Email tidak valid';
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

  // Login Non-PNS method (local storage only)
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
      final success = await _authService.loginNonPns(
        nik: nikController.text.trim(),
        nama: namaController.text.trim(),
        email: emailController.text.trim(),
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
}
