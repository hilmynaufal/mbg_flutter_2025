import 'package:get/get.dart';
import '../controllers/sppg_list_controller.dart';

class SppgListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SppgListController>(
      () => SppgListController(),
    );
  }
}
