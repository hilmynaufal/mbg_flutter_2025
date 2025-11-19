import 'package:get/get.dart';
import '../controllers/bedas_menanam_search_controller.dart';

class BedasMenanamSearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BedasMenanamSearchController>(
      () => BedasMenanamSearchController(),
    );
  }
}
