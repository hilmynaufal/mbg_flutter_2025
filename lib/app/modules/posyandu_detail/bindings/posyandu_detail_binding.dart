import 'package:get/get.dart';
import '../controllers/posyandu_detail_controller.dart';

class PosyanduDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PosyanduDetailController>(
      () => PosyanduDetailController(),
    );
  }
}
