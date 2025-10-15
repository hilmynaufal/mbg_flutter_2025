import 'package:get/get.dart';
import '../controllers/form_success_controller.dart';

class FormSuccessBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FormSuccessController>(
      () => FormSuccessController(),
    );
  }
}
