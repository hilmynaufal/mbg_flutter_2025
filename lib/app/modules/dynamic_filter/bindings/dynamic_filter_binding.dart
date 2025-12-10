import 'package:get/get.dart';
import '../controllers/dynamic_filter_controller.dart';

class DynamicFilterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DynamicFilterController>(
      () => DynamicFilterController(),
    );
  }
}
