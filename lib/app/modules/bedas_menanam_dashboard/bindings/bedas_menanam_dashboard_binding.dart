import 'package:get/get.dart';
import '../controllers/bedas_menanam_dashboard_controller.dart';

class BedasMenanamDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BedasMenanamDashboardController>(
      () => BedasMenanamDashboardController(),
    );
  }
}
