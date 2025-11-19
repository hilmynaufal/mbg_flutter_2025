import 'package:get/get.dart';
import '../../../data/models/bedas_menanam_item_model.dart';
import '../../../routes/app_routes.dart';

class BedasMenanamDetailController extends GetxController {
  late BedasMenanamItemModel item;
  late String formSlug;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments as Map<String, dynamic>?;
    item = args?['item'] as BedasMenanamItemModel;
    formSlug = args?['formSlug'] as String? ?? '';
  }

  /// Navigate to edit form
  void editItem() {
    Get.toNamed(
      Routes.DYNAMIC_FORM,
      arguments: {
        'slug': formSlug,
        'isEditMode': true,
        'existingData': item,
      },
    );
  }
}
