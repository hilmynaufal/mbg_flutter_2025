import 'package:get/get.dart';
import '../controllers/mbg_sppg_dashboard_controller.dart';

class MbgSppgDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MbgSppgDashboardController>(
      () => MbgSppgDashboardController(),
    );
  }
}
