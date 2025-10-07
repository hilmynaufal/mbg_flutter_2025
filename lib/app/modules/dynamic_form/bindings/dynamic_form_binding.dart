import 'package:get/get.dart';
import '../controllers/dynamic_form_controller.dart';

class DynamicFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DynamicFormController>(
      () => DynamicFormController(),
    );
  }
}
