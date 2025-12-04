import 'package:get/get.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/dynamic_form/bindings/dynamic_form_binding.dart';
import '../modules/dynamic_form/views/dynamic_form_view.dart';
import '../modules/report_list/bindings/report_list_binding.dart';
import '../modules/report_list/views/report_list_view.dart';
import '../modules/report_history/bindings/report_history_binding.dart';
import '../modules/report_history/views/report_history_view.dart';
import '../modules/report_detail/bindings/report_detail_binding.dart';
import '../modules/report_detail/views/report_detail_view.dart';
import '../modules/news_detail/bindings/news_detail_binding.dart';
import '../modules/news_detail/views/news_detail_view.dart';
import '../modules/form_success/bindings/form_success_binding.dart';
import '../modules/form_success/views/form_success_view.dart';
import '../modules/sppg_list/bindings/sppg_list_binding.dart';
import '../modules/sppg_list/views/sppg_list_view.dart';
import '../modules/sppg_detail/bindings/sppg_detail_binding.dart';
import '../modules/sppg_detail/views/sppg_detail_view.dart';
import '../modules/posyandu_edit/bindings/posyandu_edit_binding.dart';
import '../modules/posyandu_edit/views/posyandu_edit_view.dart';
import '../modules/posyandu_detail/bindings/posyandu_detail_binding.dart';
import '../modules/posyandu_detail/views/posyandu_detail_view.dart';
import '../modules/bedas_menanam_search/bindings/bedas_menanam_search_binding.dart';
import '../modules/bedas_menanam_search/views/bedas_menanam_search_view.dart';
import '../modules/bedas_menanam_detail/bindings/bedas_menanam_detail_binding.dart';
import '../modules/bedas_menanam_detail/views/bedas_menanam_detail_view.dart';
import '../modules/mbg_sppg_dashboard/bindings/mbg_sppg_dashboard_binding.dart';
import '../modules/mbg_sppg_dashboard/views/mbg_sppg_dashboard_view.dart';
import '../modules/posyandu_dashboard/bindings/posyandu_dashboard_binding.dart';
import '../modules/posyandu_dashboard/views/posyandu_dashboard_view.dart';
import '../modules/bedas_menanam_dashboard/bindings/bedas_menanam_dashboard_binding.dart';
import '../modules/bedas_menanam_dashboard/views/bedas_menanam_dashboard_view.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
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
      name: Routes.DYNAMIC_FORM,
      page: () => const DynamicFormView(),
      binding: DynamicFormBinding(),
    ),
    GetPage(
      name: Routes.REPORT_LIST,
      page: () => const ReportListView(),
      binding: ReportListBinding(),
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
    GetPage(
      name: Routes.NEWS_DETAIL,
      page: () => const NewsDetailView(),
      binding: NewsDetailBinding(),
    ),
    GetPage(
      name: Routes.FORM_SUCCESS,
      page: () => const FormSuccessView(),
      binding: FormSuccessBinding(),
    ),
    GetPage(
      name: Routes.SPPG_LIST,
      page: () => const SppgListView(),
      binding: SppgListBinding(),
    ),
    GetPage(
      name: Routes.SPPG_DETAIL,
      page: () => const SppgDetailView(),
      binding: SppgDetailBinding(),
    ),
    GetPage(
      name: Routes.POSYANDU_EDIT,
      page: () => const PosyanduEditView(),
      binding: PosyanduEditBinding(),
    ),
    GetPage(
      name: Routes.POSYANDU_DETAIL,
      page: () => const PosyanduDetailView(),
      binding: PosyanduDetailBinding(),
    ),
    GetPage(
      name: Routes.BEDAS_MENANAM_SEARCH,
      page: () => const BedasMenanamSearchView(),
      binding: BedasMenanamSearchBinding(),
    ),
    GetPage(
      name: Routes.BEDAS_MENANAM_DETAIL,
      page: () => const BedasMenanamDetailView(),
      binding: BedasMenanamDetailBinding(),
    ),
    GetPage(
      name: Routes.DASHBOARD_MBG,
      page: () => const MbgSppgDashboardView(),
      binding: MbgSppgDashboardBinding(),
    ),
    GetPage(
      name: Routes.DASHBOARD_POSYANDU,
      page: () => const PosyanduDashboardView(),
      binding: PosyanduDashboardBinding(),
    ),
    GetPage(
      name: Routes.DASHBOARD_BEDAS_MENANAM,
      page: () => const BedasMenanamDashboardView(),
      binding: BedasMenanamDashboardBinding(),
    ),
  ];
}
