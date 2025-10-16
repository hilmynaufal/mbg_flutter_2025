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
                          const SizedBox(height: 24),

                          // Login Button
                          Obx(
                            () => GradientButton(
                              text: 'Login',
                              onPressed: controller.login,
                              isLoading: controller.isLoading.value,
                              icon: Icons.login,
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
}
