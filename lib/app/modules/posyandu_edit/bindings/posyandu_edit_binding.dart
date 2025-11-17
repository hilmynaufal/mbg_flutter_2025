import 'package:get/get.dart';
import '../controllers/posyandu_edit_controller.dart';

class PosyanduEditBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PosyanduEditController>(
      () => PosyanduEditController(),
    );
  }
}
