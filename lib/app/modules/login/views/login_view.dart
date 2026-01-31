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

                          // Login Button (show always)
                          Obx(
                            () => GradientButton(
                              text: 'Login',
                              onPressed: controller.login,
                              isLoading: controller.isLoading.value,
                              icon: Icons.login,
                            ),
                          ),

                          // Spacing
                          const SizedBox(height: 16),

                          // Switch Login Type Text Link
                          Obx(
                            () => Center(
                              child: GestureDetector(
                                onTap: controller.toggleLoginType,
                                child: Text(
                                  controller.isPnsLogin.value
                                      ? 'Tidak mempunyai akun? Masuk menggunakan NIK'
                                      : 'Sudah punya akun? Login dengan Username',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
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

  // Build Non-PNS login form (NIK + Password)
  Widget _buildNonPnsForm(BuildContext context) {
    return Column(
      children: [
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
}
