import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../controllers/dynamic_opd_dashboard_controller.dart';
import '../../../routes/app_routes.dart';
import '../../../core/widgets/news_card_widget.dart';

class DynamicOpdDashboardView extends GetView<DynamicOpdDashboardController> {
  const DynamicOpdDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => controller.onInit(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(context),
                _buildBannerSection(context),
                _buildStatisticsSection(context),
                _buildMenuSection(context),
                _buildNewsSection(context),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Obx(() {
      final themeColor = controller.themeColor;
      final themeIcon = controller.themeIcon;

      return Padding(
        padding: const EdgeInsets.fromLTRB(8, 16, 20, 16),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 20),
              onPressed: () => Get.back(),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: themeColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: FaIcon(themeIcon, color: themeColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Dashboard Layanan',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    controller.parentMenu,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildBannerSection(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingData.value) {
        return Container(
          height: 180,
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Center(child: CircularProgressIndicator()),
        );
      }

      if (controller.banners.isEmpty) {
        return const SizedBox.shrink();
      }

      return Container(
        height: 180,
        margin: const EdgeInsets.symmetric(vertical: 16),
        child: PageView.builder(
          itemCount: controller.banners.length,
          itemBuilder: (context, index) {
            final banner = controller.banners[index];
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      banner.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              controller.themeColor,
                              controller.themeColor.withOpacity(0.8),
                            ],
                          ),
                        ),
                        child: const Center(
                          child:
                              Icon(Icons.image, color: Colors.white, size: 50),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
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
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Text(
              'RINGKASAN AKTIVITAS',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
                letterSpacing: 1.1,
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: controller.statistics.entries.map((entry) {
                final key = entry.key;
                final value = entry.value;
                final index = controller.statistics.keys.toList().indexOf(key);

                // Color palette
                final List<Color> bgColors = [
                  Colors.blue.shade50.withOpacity(0.3),
                  Colors.indigo.shade50.withOpacity(0.3),
                  Colors.green.shade50.withOpacity(0.3),
                ];
                final List<Color> accentColors = [
                  Colors.blue.shade700,
                  Colors.indigo.shade700,
                  Colors.green.shade700,
                ];
                final List<IconData> icons = [
                  Icons.trending_up,
                  Icons.credit_card,
                  Icons.auto_awesome,
                ];

                final colorIndex = index % bgColors.length;

                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Container(
                    width: (MediaQuery.of(context).size.width - 64) / 3,
                    height: 110,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: accentColors[colorIndex].withOpacity(0.2)),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Stack(
                        children: [
                          Positioned(
                            bottom: -15,
                            right: -5,
                            child: Icon(
                              icons[colorIndex],
                              size: 70,
                              color: accentColors[colorIndex].withOpacity(0.08),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(width: double.infinity),
                                Text(
                                  key.toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade500,
                                    letterSpacing: 0.8,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  value.toString(),
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: accentColors[colorIndex],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildMenuSection(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingData.value) {
        return const SizedBox.shrink();
      }

      if (controller.menuItems.isEmpty) {
        return const SizedBox.shrink();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 32, 20, 16),
            child: Text(
              'OPSI LAYANAN',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
                letterSpacing: 1.1,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 2.1,
              ),
              itemCount: controller.menuItems.length,
              itemBuilder: (context, index) {
                final menu = controller.menuItems[index];
                final detail = menu.detail;

                return _buildServiceListItem(
                  context,
                  title: detail.menu,
                  subtitle: detail.deskripsi ?? 'Proses cepat',
                  icon: detail.iconData ?? FontAwesomeIcons.circle,
                  color: detail.backgroundColor.withOpacity(0.1),
                  iconColor: detail.backgroundColor,
                  onTap: () {
                    if (detail.kategori.toLowerCase() == 'webview') {
                      Get.toNamed(
                        Routes.WEBVIEW,
                        arguments: {
                          'url': detail.slug,
                          'title': detail.menu,
                        },
                      );
                    } else {
                      _showMenuActionBottomSheet(context, detail);
                    }
                  },
                );
              },
            ),
          ),
        ],
      );
    });
  }

  Widget _buildServiceListItem(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: FaIcon(icon, color: iconColor, size: 20),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'BERITA TERBARU',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                    letterSpacing: 1.1,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('LIHAT SEMUA',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          Obx(() {
            if (controller.isLoadingData.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.newsList.isEmpty) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(child: Text('Belum ada berita')),
              );
            }

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
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
      ),
    );
  }

  void _showMenuActionBottomSheet(BuildContext context, dynamic menuDetail) {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: menuDetail.backgroundColor.withOpacity(0.1),
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
                            color: Colors.grey.shade500,
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
            _buildActionItem(
              icon: Icons.add,
              color: Colors.green,
              title: 'Tambah Data',
              subtitle: 'Buat entri data baru',
              onTap: () {
                Get.back();
                controller.navigateToDynamicForm(menuDetail.slug);
              },
            ),
            const SizedBox(height: 12),
            _buildActionItem(
              icon: Icons.list_alt,
              color: Colors.blue,
              title: 'Lihat Data',
              subtitle: 'Lihat rincian dan daftar data',
              onTap: () {
                Get.back();
                if (menuDetail.requiredFilter != null &&
                    menuDetail.requiredFilter.isNotEmpty &&
                    menuDetail.requiredFilter != "0,0") {
                  controller.navigateToFilterPage(menuDetail);
                } else {
                  controller.navigateToDataList(
                      menuDetail.slug, menuDetail.menu);
                }
              },
            ),
            const SizedBox(height: 12),
            _buildActionItem(
              icon: Icons.push_pin_outlined,
              color: Colors.orange,
              title: 'Pin ke Beranda',
              subtitle: 'Akses cepat dari menu pintas',
              onTap: () {
                Get.back();
                controller.pinToHome(menuDetail);
              },
            ),
          ],
        ),
      ),
      isDismissible: true,
      enableDrag: true,
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}
