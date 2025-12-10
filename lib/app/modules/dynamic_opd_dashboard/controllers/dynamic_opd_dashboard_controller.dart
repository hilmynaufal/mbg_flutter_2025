import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../core/widgets/banner_carousel_widget.dart';
import '../../../data/models/menu_opd_item_model.dart';
import '../../../data/models/news_model.dart';
import '../../../data/providers/content_provider.dart';
import '../../../data/providers/form_provider.dart';
import '../../../routes/app_routes.dart';

class DynamicOpdDashboardController extends GetxController {
  // Services
  final ContentProvider _contentProvider = Get.find<ContentProvider>();
  final FormProvider _formProvider = Get.find<FormProvider>();

  // Arguments from route
  final String parentMenu;

  // Dashboard Data
  final RxList<BannerItem> banners = <BannerItem>[].obs;
  final RxList<NewsModel> newsList = <NewsModel>[].obs;
  final RxList<MenuOpdItemModel> menuItems = <MenuOpdItemModel>[].obs;
  final RxMap<String, int> statistics =
      <String, int>{}.obs; // Menu title -> total count
  final RxBool isLoadingData = false.obs;

  // Constructor - extract parentMenu from arguments
  DynamicOpdDashboardController()
      : parentMenu =
            (Get.arguments as Map<String, dynamic>)['parentMenu'] as String;

  @override
  void onInit() {
    super.onInit();
    _loadDashboardData();
  }

  void _loadDashboardData() async {
    isLoadingData.value = true;

    // Load banners, news, and menu items in parallel
    await Future.wait([
      _loadBanners(),
      _loadNews(),
      _loadMenuItems(),
    ]);

    // Load statistics after menu items are loaded
    await _loadStatistics();

    isLoadingData.value = false;
  }

  Future<void> _loadBanners() async {
    try {
      final slides = await _contentProvider.getSlides();
      banners.value = slides
          .where((slide) => slide.status == 1) // status 1 = active
          .map((slide) => BannerItem(
                id: slide.idSlide.toString(),
                imageUrl: slide.imageUrl,
                title: slide.name,
                description: slide.description,
              ))
          .toList();
    } catch (e) {
      print('Error loading banners: $e');
      // Silent failure - keep empty list
    }
  }

  Future<void> _loadNews() async {
    try {
      final posts = await _contentProvider.getPosts(limit: 3);
      newsList.value = posts;
    } catch (e) {
      print('Error loading news: $e');
      // Silent failure - keep empty list
    }
  }

  Future<void> _loadMenuItems() async {
    try {
      final menuResponse = await _formProvider.getMenuOpdList();

      // Filter menus by parent_menu
      menuItems.value = menuResponse.data
          .where((menu) => menu.detail.parentMenu == parentMenu)
          .toList();
    } catch (e) {
      print('Error loading menu items: $e');
      // Silent failure - keep empty list
    }
  }

  Future<void> _loadStatistics() async {
    try {
      // Clear existing statistics
      statistics.clear();

      // Fetch statistics for each menu item in parallel
      final statsFutures = menuItems.map((menu) async {
        try {
          final count = await _formProvider.getFormStatistics(menu.detail.slug);
          return MapEntry(menu.detail.menu, count);
        } catch (e) {
          print('Error loading statistics for ${menu.detail.menu}: $e');
          return MapEntry(menu.detail.menu, 0);
        }
      }).toList();

      final stats = await Future.wait(statsFutures);

      // Update statistics map
      statistics.addAll(Map.fromEntries(stats));
    } catch (e) {
      print('Error loading statistics: $e');
      // Silent failure - keep empty map
    }
  }

  void navigateToDynamicForm(String slug) {
    Get.toNamed(Routes.DYNAMIC_FORM, arguments: slug);
  }

  void navigateToDataList(String slug, String menuTitle) {
    Get.toNamed(
      Routes.OPD_DATA_LIST,
      arguments: {
        'slug': slug,
        'menuTitle': menuTitle,
      },
    );
  }

  void navigateToFilterPage(dynamic menuDetail) {
    Get.toNamed(
      Routes.DYNAMIC_FILTER,
      arguments: {
        'slug': menuDetail.slug,
        'menuTitle': menuDetail.menu,
        'requiredFilter': menuDetail.requiredFilter,
      },
    );
  }

  /// Get theme color from first menu item
  /// Returns Color.blue as fallback if no menus
  Color get themeColor {
    if (menuItems.isEmpty) return Colors.blue;
    return menuItems.first.detail.backgroundColor;
  }

  /// Get theme icon from first menu item
  /// Returns FontAwesomeIcons.circle as fallback if no menus
  IconData get themeIcon {
    if (menuItems.isEmpty) return FontAwesomeIcons.circle;
    return menuItems.first.detail.iconData ?? FontAwesomeIcons.circle;
  }
}
