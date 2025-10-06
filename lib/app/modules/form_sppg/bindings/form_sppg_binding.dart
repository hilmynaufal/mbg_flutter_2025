import 'package:get/get.dart';
import '../controllers/form_sppg_controller.dart';

class FormSppgBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FormSppgController>(
      () => FormSppgController(),
    );
  }
}
