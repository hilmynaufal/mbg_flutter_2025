import 'package:get/get.dart';
import '../controllers/bedas_menanam_detail_controller.dart';

class BedasMenanamDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BedasMenanamDetailController>(
      () => BedasMenanamDetailController(),
    );
  }
}
