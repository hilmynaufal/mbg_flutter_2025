import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../data/models/form_submit_response_model.dart';
import '../../../routes/app_routes.dart';
import '../../../core/widgets/custom_snackbar.dart';

class FormSuccessController extends GetxController {
  // Get report data and slug from arguments
  late final FormSubmitResponseModel reportData;
  String? reportSlug;

  @override
  void onInit() {
    super.onInit();

    // Get report data and slug from route arguments
    final args = Get.arguments;

    if (args is Map<String, dynamic>) {
      // New format: {response: FormSubmitResponseModel, slug: string}
      reportData = args['response'] as FormSubmitResponseModel;
      reportSlug = args['slug'] as String?;
    } else {
      // Old format: just FormSubmitResponseModel (for backward compatibility)
      reportData = args as FormSubmitResponseModel;
    }
  }

  /// Copy text to clipboard with feedback
  Future<void> copyToClipboard(String text, String label) async {
    await Clipboard.setData(ClipboardData(text: text));
    CustomSnackbar.success(
      title: 'Tersalin',
      message: '$label berhasil disalin ke clipboard',
      duration: const Duration(seconds: 2),
    );
  }

  /// Navigate to report detail page
  void viewReportDetail() {
    Get.offNamed(
      Routes.REPORT_DETAIL,
      arguments: {
        'id': reportData.id,
        'slug': reportSlug,
      },
    );
  }

  /// Create another report (back to form)
  void createAnotherReport() {
    // Go back twice: success screen → form screen → home
    // Then navigate to form again
    Get.until((route) => route.settings.name == Routes.HOME);
    Get.toNamed(
      Routes.DYNAMIC_FORM,
      arguments: Get.previousRoute.contains('sppg')
        ? 'pelaporan-tugas-satgas-mbg'
        : 'pelaporan-tugas-satgas-mbg---dinkes---laporan-ikl',
    );
  }

  /// Go back to home
  void backToHome() {
    Get.until((route) => route.settings.name == Routes.HOME);
  }
}
