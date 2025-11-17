import 'package:get/get.dart';
import '../controllers/sppg_detail_controller.dart';

class SppgDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SppgDetailController>(
      () => SppgDetailController(),
    );
  }
}
