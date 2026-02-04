import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../controllers/mbg_sppg_dashboard_controller.dart';
import '../../../routes/app_routes.dart';
import '../../../core/widgets/service_grid_item.dart';
import '../../../core/widgets/banner_carousel_widget.dart';
import '../../../core/widgets/news_card_widget.dart';
import '../../../core/widgets/custom_snackbar.dart';

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
                      // Statistics section hidden
                      // _buildStatisticsSection(context),
                      // const SizedBox(height: 24),
                      _buildMenuSection(context),
                      const SizedBox(height: 24),
                      _buildOpdMenuSection(context),
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
      },
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 120.0,
      floating: true,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.blue.shade700,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const FaIcon(
                FontAwesomeIcons.layerGroup,
                size: 20,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Satgas MBG',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
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
                Colors.blue.shade700,
                Colors.blue.shade500,
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -20,
                top: -20,
                child: Icon(
                  FontAwesomeIcons.utensils,
                  size: 150,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
              color: Colors.black.withOpacity(0.05),
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
            'Statistik Terkini',
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
                final value = controller.statistics[key];
                return Container(
                  width: 140,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.blue.withOpacity(0.1)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.05),
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
                        value ?? '-',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Layanan Utama',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.85,
          children: [
            // ServiceGridItem(
            //   icon: FontAwesomeIcons.fileCirclePlus,
            //   title: 'Laporan\nHarian',
            //   description: 'Buat laporan penerima MBG',
            //   onTap: () =>
            //       controller.navigateToDynamicForm('pelaporan-penerima-mbg'),
            //   showDescription: false,
            //   color: Colors.blue,
            // ),
            // ServiceGridItem(
            //   icon: FontAwesomeIcons.clipboardCheck,
            //   title: 'Laporan\nSaya',
            //   description: 'Daftar Laporan Penerima MBG',
            //   onTap: () =>
            //       Get.toNamed(Routes.REPORT_LIST, arguments: 'penerima-mbg'),
            //   showDescription: false,
            //   color: Colors.blue,
            // ),
            ServiceGridItem(
              icon: FontAwesomeIcons.mapLocationDot,
              title: 'Lokasi\nSPPG',
              description: 'Direktori SPPG Aktif',
              onTap: () => Get.toNamed(Routes.SPPG_LIST),
              showDescription: false,
              color: Colors.red,
            ),
            ServiceGridItem(
              icon: FontAwesomeIcons.chartLine,
              title: 'Capaian',
              description: 'Statistik Capaian',
              onTap: () => Get.toNamed(Routes.WEBVIEW, arguments: {
                'url':
                    'https://mbg-kabupaten-bandung-info-center.vercel.app/#capaian',
                'title': 'Capaian'
              }),
              showDescription: false,
              color: Colors.teal,
            ),
            ServiceGridItem(
              icon: FontAwesomeIcons.users,
              title: 'Penerima\nManfaat',
              description: 'Data Penerima Manfaat',
              onTap: () => Get.toNamed(Routes.WEBVIEW, arguments: {
                'url':
                    'https://mbg-kabupaten-bandung-info-center.vercel.app/#penerima-manfaat',
                'title': 'Penerima Manfaat'
              }),
              showDescription: false,
              color: Colors.orange,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOpdMenuSection(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingData.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.groupedOpdMenus.isEmpty) {
        return const SizedBox.shrink();
      }

      return Showcase(
        key: controller.menuKey,
        description:
            'Menu layanan OPD sekarang disesuaikan dengan hak akses Anda.\nBeberapa menu mungkin tidak tampil jika Anda tidak memiliki akses.',
        title: 'Penyesuaian Menu Layanan',
        targetBorderRadius: BorderRadius.circular(20),
        tooltipBackgroundColor: Get.theme.colorScheme.primary,
        textColor: Get.theme.colorScheme.onPrimary,
        titleAlignment: TextAlign.start,
        descriptionAlignment: TextAlign.start,
        tooltipPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        tooltipBorderRadius: BorderRadius.circular(16),
        targetPadding: const EdgeInsets.all(8),
        titleTextStyle: TextStyle(
          color: Get.theme.colorScheme.onPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
        descTextStyle: TextStyle(
          color: Get.theme.colorScheme.onPrimary,
          fontSize: 14,
          height: 1.5,
        ),
        overlayOpacity: 0.7,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Layanan OPD',
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
              itemCount: controller.groupedOpdMenus.length,
              itemBuilder: (context, index) {
                final parentMenu =
                    controller.groupedOpdMenus.keys.elementAt(index);
                final menus = controller.groupedOpdMenus[parentMenu]!;
                final firstMenu = menus.first.detail;

                return ServiceGridItem(
                  icon: firstMenu.iconData ?? FontAwesomeIcons.circle,
                  title: parentMenu,
                  description: '${menus.length} menu',
                  onTap: () => controller.navigateToOpdDashboard(parentMenu),
                  showDescription: false,
                  color: firstMenu.backgroundColor,
                );
              },
            ),
          ],
        ),
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
}
