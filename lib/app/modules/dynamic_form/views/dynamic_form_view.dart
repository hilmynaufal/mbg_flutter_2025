import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/dynamic_form_controller.dart';
import '../../../core/widgets/dynamic_form_builder.dart';
import '../../../core/widgets/gradient_button.dart';

class DynamicFormView extends GetView<DynamicFormController> {
  const DynamicFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Text(
            controller.formStructure.value?.title ?? 'Form SPPG',
          ),
        ),
      ),
      body: Obx(() {
        // Loading state
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // Error state
        if (controller.errorMessage.value.isNotEmpty &&
            controller.formStructure.value == null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Gagal memuat form',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    controller.errorMessage.value,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  GradientButton(
                    text: 'Coba Lagi',
                    onPressed: controller.retryLoadForm,
                    icon: Icons.refresh,
                    width: 200,
                  ),
                ],
              ),
            ),
          );
        }

        // Form loaded successfully
        final formData = controller.formStructure.value;
        if (formData == null) {
          return const Center(
            child: Text('No form data available'),
          );
        }

        return Column(
          children: [
            // Form description
            if (formData.description.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                child: Text(
                  formData.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),

            // Dynamic form
            Expanded(
              child: DynamicFormBuilder(
                fields: formData.data,
                formKey: controller.formKey,
                formValues: controller.formValues,
              ),
            ),

            // Submit button
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Obx(
                () => GradientButton(
                  text: 'Kirim Laporan',
                  onPressed: controller.submitForm,
                  isLoading: controller.isSubmitting.value,
                  icon: Icons.send,
                  height: 48,
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

