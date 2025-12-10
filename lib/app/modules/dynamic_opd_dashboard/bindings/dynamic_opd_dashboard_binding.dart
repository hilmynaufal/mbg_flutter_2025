import 'package:get/get.dart';
import '../../../data/providers/content_provider.dart';
import '../../../data/providers/form_provider.dart';
import '../controllers/dynamic_opd_dashboard_controller.dart';

class DynamicOpdDashboardBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure providers are available
    if (!Get.isRegistered<ContentProvider>()) {
      Get.lazyPut<ContentProvider>(() => ContentProvider());
    }
    if (!Get.isRegistered<FormProvider>()) {
      Get.lazyPut<FormProvider>(() => FormProvider());
    }

    Get.lazyPut<DynamicOpdDashboardController>(
      () => DynamicOpdDashboardController(),
    );
  }
}
