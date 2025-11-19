import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';
import '../../../core/widgets/gradient_button.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo Section
                Image.asset(
                  'assets/images/logo.png',
                  height: 120,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 48),

                // Login Form Card
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: controller.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Login',
                            style: Theme.of(context).textTheme.headlineSmall,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),

                          // Conditional Form Fields
                          Obx(
                            () => controller.isPnsLogin.value
                                ? _buildPnsForm(context)
                                : _buildNonPnsForm(context),
                          ),

                          const SizedBox(height: 24),

                          // Login Button (show always for PNS, show only when OTP verified for Non-PNS)
                          Obx(
                            () => (controller.isPnsLogin.value ||
                                    controller.isOtpVerified.value)
                                ? GradientButton(
                                    text: 'Login',
                                    onPressed: controller.login,
                                    isLoading: controller.isLoading.value,
                                    icon: Icons.login,
                                  )
                                : const SizedBox.shrink(),
                          ),

                          // Spacing (only show if login button is visible)
                          Obx(
                            () => (controller.isPnsLogin.value ||
                                    controller.isOtpVerified.value)
                                ? const SizedBox(height: 16)
                                : const SizedBox.shrink(),
                          ),

                          // Switch Login Type Text Link
                          Obx(
                            () => Center(
                              child: GestureDetector(
                                onTap: controller.toggleLoginType,
                                child: Text(
                                  controller.isPnsLogin.value
                                      ? 'Tidak mempunyai akun? Masuk menggunakan NIK'
                                      : 'Sudah punya akun? Login dengan Username',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: Get.theme.colorScheme.primary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Guest Login Button
                          Center(
                            child: OutlinedButton.icon(
                              onPressed: controller.showGuestLoginDialog,
                              icon: const Icon(Icons.person_outline),
                              label: const Text('Masuk sebagai Tamu'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Get.theme.colorScheme.primary,
                                side: BorderSide(
                                  color: Get.theme.colorScheme.primary,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Footer
                Text(
                  'Pemerintah Kabupaten Bandung',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Build PNS login form (Username + Password)
  Widget _buildPnsForm(BuildContext context) {
    return Column(
      children: [
        // Username Field
        TextFormField(
          controller: controller.usernameController,
          decoration: const InputDecoration(
            labelText: 'Username',
            hintText: 'Masukkan username',
            prefixIcon: Icon(Icons.person),
          ),
          validator: controller.validateUsername,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 16),

        // Password Field
        Obx(
          () => TextFormField(
            controller: controller.passwordController,
            obscureText: !controller.isPasswordVisible.value,
            decoration: InputDecoration(
              labelText: 'Password',
              hintText: 'Masukkan password',
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: IconButton(
                icon: Icon(
                  controller.isPasswordVisible.value
                      ? Icons.visibility
                      : Icons.visibility_off,
                ),
                onPressed: controller.togglePasswordVisibility,
              ),
            ),
            validator: controller.validatePassword,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => controller.login(),
          ),
        ),
      ],
    );
  }

  // Build Non-PNS login form (NIK + Nama + Email + OTP)
  Widget _buildNonPnsForm(BuildContext context) {
    return Column(
      children: [
        // Email Field
        TextFormField(
          controller: controller.emailController,
          decoration: const InputDecoration(
            labelText: 'Email',
            hintText: 'Masukkan email',
            prefixIcon: Icon(Icons.email),
          ),
          keyboardType: TextInputType.emailAddress,
          validator: controller.validateEmail,
          textInputAction: TextInputAction.next,
          enabled: !controller.isOtpSent.value, // Disable after OTP sent
        ),
        const SizedBox(height: 16),

        // NIK Field
        TextFormField(
          controller: controller.nikController,
          decoration: const InputDecoration(
            labelText: 'NIK',
            hintText: 'Masukkan NIK (16 digit)',
            prefixIcon: Icon(Icons.badge),
          ),
          keyboardType: TextInputType.number,
          maxLength: 16,
          validator: controller.validateNik,
          textInputAction: TextInputAction.next,
          enabled: !controller.isOtpSent.value, // Disable after OTP sent
        ),
        const SizedBox(height: 16),

        // Nama Field
        TextFormField(
          controller: controller.namaController,
          decoration: const InputDecoration(
            labelText: 'Nama Lengkap',
            hintText: 'Masukkan nama lengkap',
            prefixIcon: Icon(Icons.person_outline),
          ),
          textCapitalization: TextCapitalization.words,
          validator: controller.validateNama,
          textInputAction: TextInputAction.next,
          enabled: !controller.isOtpSent.value, // Disable after OTP sent
        ),
        const SizedBox(height: 16),

        // Send OTP Button (show before OTP sent)
        Obx(
          () => !controller.isOtpSent.value
              ? GradientButton(
                  text: 'Kirim OTP',
                  onPressed: controller.sendOtp,
                  isLoading: controller.isSendingOtp.value,
                  icon: Icons.send,
                )
              : const SizedBox.shrink(),
        ),

        // OTP Field (show after OTP sent)
        Obx(
          () => controller.isOtpSent.value
              ? Column(
                  children: [
                    // Info message
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Get.theme.colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Get.theme.colorScheme.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Kode OTP telah dikirim ke email Anda. Silakan cek inbox/spam.',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // OTP Input Field
                    TextFormField(
                      controller: controller.otpController,
                      decoration: InputDecoration(
                        labelText: 'Kode OTP',
                        hintText: 'Masukkan kode OTP (6 digit)',
                        prefixIcon: const Icon(Icons.vpn_key),
                        suffixIcon: controller.isOtpVerified.value
                            ? Icon(
                                Icons.check_circle,
                                color: Get.theme.colorScheme.primary,
                              )
                            : null,
                      ),
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      validator: controller.validateOtp,
                      textInputAction: TextInputAction.done,
                      enabled: !controller.isOtpVerified.value,
                      onFieldSubmitted: (_) => controller.verifyOtp(),
                    ),
                    const SizedBox(height: 16),

                    // Verify OTP Button (show if not verified)
                    if (!controller.isOtpVerified.value)
                      GradientButton(
                        text: 'Verifikasi OTP',
                        onPressed: controller.verifyOtp,
                        isLoading: controller.isVerifyingOtp.value,
                        icon: Icons.verified_user,
                      ),

                    const SizedBox(height: 12),

                    // Resend OTP Link (show if not verified)
                    if (!controller.isOtpVerified.value)
                      Obx(
                        () => TextButton(
                          onPressed: controller.resendTimer.value > 0
                              ? null
                              : controller.resendOtp,
                          child: Text(
                            controller.resendTimer.value > 0
                                ? 'Kirim Ulang OTP (${controller.resendTimer.value}s)'
                                : 'Kirim Ulang OTP',
                            style: TextStyle(
                              color: controller.resendTimer.value > 0
                                  ? Colors.grey
                                  : Get.theme.colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                  ],
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
