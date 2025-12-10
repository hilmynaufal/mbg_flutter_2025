import 'package:get/get.dart';
import '../../../data/providers/form_provider.dart';
import '../controllers/mbg_sppg_dashboard_controller.dart';

class MbgSppgDashboardBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure FormProvider is available
    if (!Get.isRegistered<FormProvider>()) {
      Get.lazyPut<FormProvider>(() => FormProvider());
    }

    Get.lazyPut<MbgSppgDashboardController>(
      () => MbgSppgDashboardController(),
    );
  }
}
