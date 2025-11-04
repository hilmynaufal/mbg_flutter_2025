import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/providers/otp_provider.dart';
import '../../../routes/app_routes.dart';

class LoginController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final OtpProvider _otpProvider = OtpProvider();

  // Text editing controllers - PNS
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // Text editing controllers - Non-PNS
  final nikController = TextEditingController();
  final namaController = TextEditingController();
  final emailController = TextEditingController();
  final otpController = TextEditingController();

  // Form key
  final formKey = GlobalKey<FormState>();

  // Observable states
  final RxBool isLoading = false.obs;
  final RxBool isPasswordVisible = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isPnsLogin = true.obs; // true = PNS login, false = Non-PNS login

  // OTP states
  final RxBool isOtpSent = false.obs;
  final RxBool isOtpVerified = false.obs;
  final RxBool isSendingOtp = false.obs;
  final RxBool isVerifyingOtp = false.obs;
  final RxInt resendTimer = 0.obs; // Countdown timer for resend OTP
  Timer? _resendTimer;

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
    otpController.dispose();
    // Cancel timer
    _resendTimer?.cancel();
    super.onClose();
  }

  // Toggle between PNS and Non-PNS login
  void toggleLoginType() {
    isPnsLogin.value = !isPnsLogin.value;
    // Clear error message when switching
    errorMessage.value = '';
    // Reset OTP states when switching
    _resetOtpStates();
  }

  // Reset OTP states
  void _resetOtpStates() {
    isOtpSent.value = false;
    isOtpVerified.value = false;
    isSendingOtp.value = false;
    isVerifyingOtp.value = false;
    resendTimer.value = 0;
    otpController.clear();
    _resendTimer?.cancel();
  }

  // Start resend timer (60 seconds)
  void _startResendTimer() {
    resendTimer.value = 60;
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendTimer.value > 0) {
        resendTimer.value--;
      } else {
        timer.cancel();
      }
    });
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

  // Validate OTP (must be 6 digits)
  String? validateOtp(String? value) {
    if (value == null || value.isEmpty) {
      return 'Kode OTP tidak boleh kosong';
    }
    // Remove any whitespace
    final cleanedValue = value.trim();
    // Check if it's exactly 6 digits
    if (cleanedValue.length != 6) {
      return 'Kode OTP harus 6 digit';
    }
    // Check if it contains only numbers
    if (!RegExp(r'^[0-9]+$').hasMatch(cleanedValue)) {
      return 'Kode OTP harus berupa angka';
    }
    return null;
  }

  // Send OTP to email
  Future<void> sendOtp() async {
    // Validate email, NIK, and nama first
    if (emailController.text.trim().isEmpty ||
        nikController.text.trim().isEmpty ||
        namaController.text.trim().isEmpty) {
      Get.snackbar(
        'Validasi Gagal',
        'Mohon lengkapi Email, NIK, dan Nama terlebih dahulu',
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    // Validate email format
    if (validateEmail(emailController.text) != null) {
      Get.snackbar(
        'Validasi Gagal',
        'Format email tidak valid',
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    // Validate NIK
    if (validateNik(nikController.text) != null) {
      Get.snackbar(
        'Validasi Gagal',
        'NIK harus 16 digit angka',
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    // Validate nama
    if (validateNama(namaController.text) != null) {
      Get.snackbar(
        'Validasi Gagal',
        'Nama minimal 3 karakter',
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    isSendingOtp.value = true;

    try {
      final response = await _otpProvider.sendOtp(
        email: emailController.text.trim(),
      );

      if (response.success) {
        isOtpSent.value = true;
        _startResendTimer();
        Get.snackbar(
          'OTP Terkirim',
          'Kode OTP telah dikirim ke email ${emailController.text.trim()}',
          backgroundColor: Get.theme.colorScheme.primary,
          colorText: Get.theme.colorScheme.onPrimary,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Gagal Mengirim OTP',
        e.toString().replaceAll('Exception: ', ''),
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isSendingOtp.value = false;
    }
  }

  // Verify OTP code
  Future<void> verifyOtp() async {
    // Validate OTP
    if (validateOtp(otpController.text) != null) {
      Get.snackbar(
        'Validasi Gagal',
        'Kode OTP harus 6 digit angka',
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    isVerifyingOtp.value = true;

    try {
      final response = await _otpProvider.verifyOtp(
        email: emailController.text.trim(),
        otpCode: otpController.text.trim(),
      );

      if (response.success) {
        isOtpVerified.value = true;
        Get.snackbar(
          'OTP Terverifikasi',
          'Kode OTP berhasil diverifikasi. Silakan login.',
          backgroundColor: Get.theme.colorScheme.primary,
          colorText: Get.theme.colorScheme.onPrimary,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Verifikasi Gagal',
        e.toString().replaceAll('Exception: ', ''),
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isVerifyingOtp.value = false;
    }
  }

  // Resend OTP
  Future<void> resendOtp() async {
    if (resendTimer.value > 0) {
      Get.snackbar(
        'Tunggu Sebentar',
        'Silakan tunggu ${resendTimer.value} detik untuk kirim ulang OTP',
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    await sendOtp();
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

  // Login Non-PNS method (local storage only, requires OTP verification)
  Future<void> loginNonPns() async {
    // Check if OTP is verified
    if (!isOtpVerified.value) {
      Get.snackbar(
        'OTP Belum Terverifikasi',
        'Silakan verifikasi OTP terlebih dahulu',
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
      );
      return;
    }

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
