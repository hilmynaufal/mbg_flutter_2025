import 'package:get/get.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/form_sppg/bindings/form_sppg_binding.dart';
import '../modules/form_sppg/views/form_sppg_view.dart';
import '../modules/report_history/bindings/report_history_binding.dart';
import '../modules/report_history/views/report_history_view.dart';
import '../modules/report_detail/bindings/report_detail_binding.dart';
import '../modules/report_detail/views/report_detail_view.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.FORM_SPPG,
      page: () => const FormSppgView(),
      binding: FormSppgBinding(),
    ),
    GetPage(
      name: Routes.REPORT_HISTORY,
      page: () => const ReportHistoryView(),
      binding: ReportHistoryBinding(),
    ),
    GetPage(
      name: Routes.REPORT_DETAIL,
      page: () => const ReportDetailView(),
      binding: ReportDetailBinding(),
    ),
  ];
}
