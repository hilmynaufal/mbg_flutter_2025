import 'package:get/get.dart';
import '../controllers/opd_data_list_controller.dart';

class OpdDataListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OpdDataListController>(
      () => OpdDataListController(),
    );
  }
}
