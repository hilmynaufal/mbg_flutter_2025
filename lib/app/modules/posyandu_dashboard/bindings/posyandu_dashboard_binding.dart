import 'package:get/get.dart';
import '../controllers/posyandu_dashboard_controller.dart';

class PosyanduDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PosyanduDashboardController>(
      () => PosyanduDashboardController(),
    );
  }
}
