import 'package:get/get.dart';
import '../../../data/models/posyandu_item_model.dart';
import '../../../routes/app_routes.dart';

class PosyanduDetailController extends GetxController {
  // Posyandu data from arguments
  late PosyanduItemModel posyandu;
  late String formSlug;

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
}
