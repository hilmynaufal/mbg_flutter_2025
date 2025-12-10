import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/posyandu_item_model.dart';
import '../../../data/providers/form_provider.dart';
import '../../../core/widgets/custom_snackbar.dart';
import '../../../routes/app_routes.dart';

class PosyanduDetailController extends GetxController {
  // Dependencies
  final FormProvider _formProvider = FormProvider();

  // Posyandu data from arguments
  late PosyanduItemModel posyandu;
  late String formSlug;

  // Loading state
  final isDeleting = false.obs;

  @override
  void onInit() {
    super.onInit();

    // Get arguments from route
    final args = Get.arguments as Map<String, dynamic>?;
    posyandu = args?['posyandu'] as PosyanduItemModel;
    formSlug = args?['formSlug'] as String? ?? '';
  }

  /// Navigate to edit form
  void editPosyandu() {
    Get.toNamed(
      Routes.DYNAMIC_FORM,
      arguments: {
        'slug': formSlug,
        'isEditMode': true,
        'existingData': posyandu,
      },
    );
  }

  /// Delete posyandu with confirmation dialog
  Future<void> deletePosyandu() async {
    // Show confirmation dialog
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Hapus Data Posyandu'),
        content: Text(
          'Apakah Anda yakin ingin menghapus data posyandu "${posyandu.detail.namaPosyandu}"?\n\nTindakan ini tidak dapat dibatalkan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    // If user cancelled, return
    if (confirmed != true) return;

    // Show loading
    isDeleting.value = true;

    try {
      // Call delete API
      await _formProvider.deleteForm(posyandu.id);

      // Show success message
      CustomSnackbar.success(
        title: 'Berhasil',
        message: 'Data posyandu berhasil dihapus',
      );

      // Navigate back to previous screen
      Get.back(result: true); // Pass true to indicate deletion success
    } catch (e) {
      // Show error message
      CustomSnackbar.error(
        title: 'Gagal',
        message: e.toString().replaceAll('Exception: ', ''),
      );
    } finally {
      isDeleting.value = false;
    }
  }
}
