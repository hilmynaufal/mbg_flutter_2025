import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../routes/app_routes.dart';
import '../../../core/widgets/banner_carousel_widget.dart';
import '../../../data/models/news_model.dart';
import '../../../data/models/menu_opd_item_model.dart';
import '../../../data/providers/content_provider.dart';
import '../../../data/providers/form_provider.dart';

class MbgSppgDashboardController extends GetxController {
  // Services
  final ContentProvider _contentProvider = Get.find<ContentProvider>();
  final FormProvider _formProvider = Get.find<FormProvider>();

  // Dashboard Data
  final RxList<BannerItem> banners = <BannerItem>[].obs;
  final RxList<NewsModel> newsList = <NewsModel>[].obs;
  final RxMap<String, String> statistics = <String, String>{}.obs;
  final RxBool isLoadingData = false.obs;

  // OPD Menu Data
  final RxList<MenuOpdItemModel> opdMenus = <MenuOpdItemModel>[].obs;
  final RxMap<String, List<MenuOpdItemModel>> groupedOpdMenus =
      <String, List<MenuOpdItemModel>>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _loadDashboardData();
  }

  void _loadDashboardData() async {
    isLoadingData.value = true;
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

    // Dummy Banners
    banners.value = [
      BannerItem(
        id: '1',
        imageUrl:
            'https://images.unsplash.com/photo-1542838132-92c53300491e?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
        title: 'Makan Bergizi Gratis',
        description: 'Program makan bergizi gratis untuk siswa sekolah',
      ),
      BannerItem(
        id: '2',
        imageUrl:
            'https://images.unsplash.com/photo-1588072432836-e10032774350?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
        title: 'SPPG Berkualitas',
        description:
            'Satuan Pelayanan Pangan Gizi yang higienis dan terstandar',
      ),
    ];

    // Statistics hidden - no data loaded
    statistics.value = {};

    // Load news from API (same as HomeController)
    try {
      final posts = await _contentProvider.getPosts(limit: 3);
      newsList.value = posts;
    } catch (e) {
      print('Error loading news: $e');
      // Silent failure - keep empty list
    }

    // Load OPD menus from API
    try {
      final menuResponse = await _formProvider.getMenuOpdList();
      opdMenus.value = menuResponse.data;
      _groupMenusByParent();
    } catch (e) {
      print('Error loading OPD menus: $e');
      // Silent failure - keep empty list
    }

    isLoadingData.value = false;
  }

  /// Group OPD menus by parent_menu field
  void _groupMenusByParent() {
    final Map<String, List<MenuOpdItemModel>> grouped = {};

    for (var menu in opdMenus) {
      final parentMenu = menu.detail.parentMenu;
      if (!grouped.containsKey(parentMenu)) {
        grouped[parentMenu] = [];
      }
      grouped[parentMenu]!.add(menu);
    }

    groupedOpdMenus.value = grouped;
  }

  void navigateToDynamicForm(String slug) {
    Get.toNamed(Routes.DYNAMIC_FORM, arguments: slug);
  }

  void navigateToOpdDashboard(String parentMenu) {
    Get.toNamed(
      Routes.DASHBOARD_OPD,
      arguments: {'parentMenu': parentMenu},
    );
  }

  void showReportTypeDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Pilih Jenis Laporan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.description),
              title: const Text('Laporan SPPG'),
              onTap: () {
                Get.back();
                navigateToDynamicForm('pelaporan-tugas-satgas-mbg');
              },
            ),
            ListTile(
              leading: const Icon(Icons.medical_services),
              title: const Text('Laporan IKL Dinkes'),
              onTap: () {
                Get.back();
                navigateToDynamicForm(
                    'pelaporan-tugas-satgas-mbg---dinkes---laporan-ikl');
              },
            ),
          ],
        ),
      ),
    );
  }
}
