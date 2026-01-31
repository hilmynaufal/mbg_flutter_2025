import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../core/widgets/banner_carousel_widget.dart';
import '../../../core/widgets/custom_snackbar.dart';
import '../../../core/widgets/news_card_widget.dart';
import '../../../core/widgets/service_grid_item.dart';
import '../../../routes/app_routes.dart';
import '../controllers/dynamic_opd_dashboard_controller.dart';

class DynamicOpdDashboardView extends GetView<DynamicOpdDashboardController> {
  const DynamicOpdDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildBannerSection(),
                  const SizedBox(height: 24),
                  _buildStatisticsSection(context),
                  const SizedBox(height: 24),
                  _buildMenuSection(context),
                  const SizedBox(height: 24),
                  _buildNewsSection(context),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return Obx(() {
      final themeColor = controller.themeColor;
      final themeIcon = controller.themeIcon;

      return SliverAppBar(
        expandedHeight: 120.0,
        floating: true,
        pinned: true,
        elevation: 0,
        backgroundColor: themeColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        flexibleSpace: FlexibleSpaceBar(
          titlePadding: const EdgeInsets.only(left: 56, bottom: 16),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: FaIcon(
                  themeIcon,
                  size: 20,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  controller.parentMenu,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          background: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(30),
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  themeColor,
                  themeColor.withValues(alpha: 0.8),
                ],
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -20,
                  top: -20,
                  child: Icon(
                    themeIcon,
                    size: 150,
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildBannerSection() {
    return Obx(() {
      if (controller.isLoadingData.value) {
        return Container(
          height: 180,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Center(child: CircularProgressIndicator()),
        );
      }

      if (controller.banners.isEmpty) {
        return const SizedBox.shrink();
      }

      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BannerCarouselWidget(
            banners: controller.banners,
            height: 180,
            onBannerTap: (banner) {
              CustomSnackbar.info(
                title: 'Info',
                message: banner.title ?? 'Banner tapped',
              );
            },
          ),
        ),
      );
    });
  }

  Widget _buildStatisticsSection(BuildContext context) {
    return Obx(() {
      if (controller.statistics.isEmpty) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Statistik Data',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: controller.statistics.length,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final key = controller.statistics.keys.elementAt(index);
                final value = controller.statistics[key] ?? 0;

                // Get color from menu item
                final menuItem = controller.menuItems.firstWhere(
                  (menu) => menu.detail.menu == key,
                  orElse: () => controller.menuItems.first,
                );
                final menuColor = menuItem.detail.backgroundColor;

                return Container(
                  width: 140,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: menuColor.withValues(alpha: 0.3)),
                    boxShadow: [
                      BoxShadow(
                        color: menuColor.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        value.toString(),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: menuColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        key,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }

  Widget _buildMenuSection(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingData.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.menuItems.isEmpty) {
        return Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              Icon(Icons.menu, size: 48, color: Colors.grey[300]),
              const SizedBox(height: 16),
              Text(
                'Tidak ada menu tersedia',
                style: TextStyle(color: Colors.grey[500]),
              ),
            ],
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Menu ${controller.parentMenu}',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.85,
            ),
            itemCount: controller.menuItems.length,
            itemBuilder: (context, index) {
              final menu = controller.menuItems[index];
              final detail = menu.detail;

              return ServiceGridItem(
                icon: detail.iconData ?? FontAwesomeIcons.circle,
                title: detail.menu,
                description: detail.deskripsi,
                onTap: () {
                  // Check if menu kategori is "Webview"
                  if (detail.kategori.toLowerCase() == 'webview') {
                    // Navigate to webview with slug as URL
                    Get.toNamed(
                      Routes.WEBVIEW,
                      arguments: {
                        'url': detail.slug,
                        'title': detail.menu,
                      },
                    );
                  } else {
                    // Show bottom sheet for normal menus
                    _showMenuActionBottomSheet(context, detail);
                  }
                },
                showDescription: false,
                color: detail.backgroundColor,
              );
            },
          ),
        ],
      );
    });
  }

  Widget _buildNewsSection(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Berita & Kegiatan',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
            ),
            TextButton(
              onPressed: () {
                CustomSnackbar.info(
                  title: 'Info',
                  message: 'Fitur ini akan segera hadir',
                );
              },
              child: const Text('Lihat Semua'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Obx(() {
          if (controller.isLoadingData.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.newsList.isEmpty) {
            return Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  Icon(Icons.newspaper, size: 48, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada berita',
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.newsList.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final news = controller.newsList[index];
              return NewsCardWidget(
                news: news,
                onTap: () =>
                    Get.toNamed(Routes.NEWS_DETAIL, arguments: news.url),
              );
            },
          );
        }),
      ],
    );
  }

  /// Show bottom sheet with menu actions (Tambah/Lihat Data)
  void _showMenuActionBottomSheet(BuildContext context, dynamic menuDetail) {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header with icon and title
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: menuDetail.backgroundColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: FaIcon(
                    menuDetail.iconData ?? FontAwesomeIcons.circle,
                    color: menuDetail.backgroundColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        menuDetail.menu,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (menuDetail.deskripsi != null &&
                          menuDetail.deskripsi!.isNotEmpty)
                        Text(
                          menuDetail.deskripsi!,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Divider(height: 1),
            const SizedBox(height: 16),

            // Tambah Data button
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.add, color: Colors.green),
              ),
              title: const Text(
                'Tambah Data',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: const Text('Buat data baru'),
              onTap: () {
                Get.back(); // Close bottom sheet
                controller.navigateToDynamicForm(menuDetail.slug);
              },
            ),
            const SizedBox(height: 8),

            // Lihat Data button
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.list_alt, color: Colors.blue),
              ),
              title: const Text(
                'Lihat Data',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: const Text('Lihat daftar data yang sudah ada'),
              onTap: () {
                Get.back(); // Close bottom sheet

                // Check if menu has required_filter
                if (menuDetail.requiredFilter != null &&
                    menuDetail.requiredFilter.isNotEmpty &&
                    menuDetail.requiredFilter != "0,0") {
                  // Navigate to filter page first
                  controller.navigateToFilterPage(menuDetail);
                } else {
                  // Direct to data list (existing flow)
                  controller.navigateToDataList(
                      menuDetail.slug, menuDetail.menu);
                }
              },
            ),
            const SizedBox(height: 8),

            // Pin to Home button
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.push_pin, color: Colors.orange),
              ),
              title: const Text(
                'Pin ke Home',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: const Text('Tambahkan ke Menu Pintas di halaman utama'),
              onTap: () {
                Get.back(); // Close bottom sheet
                controller.pinToHome(menuDetail);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      isDismissible: true,
      enableDrag: true,
    );
  }
}
