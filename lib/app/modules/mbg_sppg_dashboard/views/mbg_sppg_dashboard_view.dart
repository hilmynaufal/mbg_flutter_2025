import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../controllers/mbg_sppg_dashboard_controller.dart';
import '../../../routes/app_routes.dart';
import '../../../core/widgets/news_card_widget.dart';

class MbgSppgDashboardView extends GetView<MbgSppgDashboardController> {
  const MbgSppgDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      builder: (context) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (controller.checkTourStatus()) {
            ShowCaseWidget.of(context).startShowCase([controller.menuKey]);
            controller.completeTour();
          }
        });

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
                    _buildInfoSection(context),
                    _buildMenuSection(context),
                    _buildOpdMenuSection(context),
                    _buildNewsSection(context),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
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
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: FaIcon(FontAwesomeIcons.layerGroup,
                color: Colors.blue.shade700, size: 20),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dashboard',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Satgas MBG',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
                        color: Colors.blue.shade700,
                        child: const Center(
                          child:
                              Icon(Icons.image, color: Colors.white, size: 50),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.5),
                        ],
                      ),
                    ),
                  ),
                  if (banner.title != null)
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            banner.title!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
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

  Widget _buildInfoSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Text(
            'INFORMASI PROGRAM',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
              letterSpacing: 1.2,
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              _buildInfoCard(
                context,
                icon: FontAwesomeIcons.mapLocationDot,
                title: 'Lokasi SPPG',
                subtitle: 'Cek titik lokasi',
                color: Colors.red.shade50,
                iconColor: Colors.red,
                onTap: () => Get.toNamed(Routes.SPPG_LIST),
              ),
              const SizedBox(width: 16),
              _buildInfoCard(
                context,
                icon: FontAwesomeIcons.chartLine,
                title: 'Capaian',
                subtitle: 'Statistik real-time',
                color: Colors.teal.shade50,
                iconColor: Colors.teal,
                onTap: () => Get.toNamed(Routes.WEBVIEW, arguments: {
                  'url':
                      'https://mbg-kabupaten-bandung-info-center.vercel.app/#capaian',
                  'title': 'Capaian'
                }),
              ),
              const SizedBox(width: 16),
              _buildInfoCard(
                context,
                icon: FontAwesomeIcons.users,
                title: 'Penerima',
                subtitle: 'Data sasaran',
                color: Colors.orange.shade50,
                iconColor: Colors.orange,
                onTap: () => Get.toNamed(Routes.WEBVIEW, arguments: {
                  'url':
                      'https://mbg-kabupaten-bandung-info-center.vercel.app/#penerima-manfaat',
                  'title': 'Penerima Manfaat'
                }),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FaIcon(icon, color: iconColor, size: 24),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    return const SizedBox
        .shrink(); // Legacy section, now using Info Section and OPD Menu Section
  }

  Widget _buildOpdMenuSection(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingData.value) {
        return const SizedBox.shrink();
      }

      if (controller.groupedOpdMenus.isEmpty) {
        return const SizedBox.shrink();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 24, 20, 16),
            child: Text(
              'Layanan Satgas',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          Showcase(
            key: controller.menuKey,
            description:
                'Menu layanan OPD sekarang disesuaikan dengan hak akses Anda.',
            title: 'Layanan Terpersonalisasi',
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 20,
                  childAspectRatio: 0.75,
                ),
                itemCount: controller.groupedOpdMenus.length,
                itemBuilder: (context, index) {
                  final parentMenu =
                      controller.groupedOpdMenus.keys.elementAt(index);
                  final menus = controller.groupedOpdMenus[parentMenu]!;
                  final firstMenu = menus.first.detail;

                  return _buildServiceItem(
                    context,
                    title: parentMenu,
                    icon: firstMenu.iconData ?? FontAwesomeIcons.circle,
                    color: firstMenu.backgroundColor.withOpacity(0.1),
                    iconColor: firstMenu.backgroundColor,
                    onTap: () => controller.navigateToOpdDashboard(parentMenu),
                  );
                },
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildServiceItem(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: FaIcon(icon, color: iconColor, size: 24),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              height: 1.2,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
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
                  'Berita Terbaru',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('Lihat Semua'),
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
}
