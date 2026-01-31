import 'package:get/get.dart';
import 'package:mbg_flutter_2025/app/data/providers/content_provider.dart';
import 'package:mbg_flutter_2025/app/data/providers/form_provider.dart';
import '../controllers/dynamic_filter_controller.dart';

class DynamicFilterBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure providers are available
    if (!Get.isRegistered<ContentProvider>()) {
      Get.lazyPut<ContentProvider>(() => ContentProvider());
    }
    if (!Get.isRegistered<FormProvider>()) {
      Get.lazyPut<FormProvider>(() => FormProvider());
    }

    Get.lazyPut<DynamicFilterController>(
      () => DynamicFilterController(),
    );
  }
}
