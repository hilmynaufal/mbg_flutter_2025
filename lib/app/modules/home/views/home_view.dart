import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mbg_flutter_2025/app/core/utils/icon_mapper.dart';
import '../controllers/home_controller.dart';
import '../../../routes/app_routes.dart';
import '../../../core/widgets/banner_carousel_widget.dart';
import '../../../core/widgets/news_card_widget.dart';
import '../../../core/widgets/custom_snackbar.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[50], // Light background for better contrast
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildBannerSection(),
                  const SizedBox(height: 24),
                  _buildInfoSection(context),
                  const SizedBox(height: 24),
                  _buildServicesSection(context),
                  const SizedBox(height: 24),
                  _buildShortcutsSection(context),
                  const SizedBox(height: 24),
                  _buildNewsSection(context),
                  const SizedBox(height: 24),
                  _buildLogoutButton(context),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 120.0,
      floating: true,
      pinned: true,
      elevation: 0,
      backgroundColor: Theme.of(context).colorScheme.primary,
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
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: CircleAvatar(
                radius: 16,
                backgroundImage: AssetImage('assets/images/logo.png'),
                // Fallback if asset not found, maybe use icon
                onBackgroundImageError: (_, __) {},
              ),
            ),
            const SizedBox(width: 12),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selamat Datang,',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Obx(() => Text(
                      controller.user.value?.nmLengkap ?? 'Tamu',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )),
              ],
            ),
          ],
        ),
        background: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.primary.withOpacity(0.8),
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -20,
                top: -20,
                child: Icon(
                  FontAwesomeIcons.leaf,
                  size: 150,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {
            CustomSnackbar.info(
              title: 'Notifikasi',
              message: 'Belum ada notifikasi baru',
            );
          },
        ),
      ],
    );
  }

  Widget _buildBannerSection() {
    return Obx(() {
      if (controller.isLoadingBanners.value) {
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
                title: 'Banner',
                message: banner.title ?? 'Banner tapped',
              );
            },
          ),
        ),
      );
    });
  }

  Widget _buildInfoSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Informasi',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.90,
          children: [
            _buildServiceItem(
              context,
              icon: FontAwesomeIcons.circleInfo,
              title: 'Apa itu SPPG',
              color: Colors.blue,
              onTap: () => Get.toNamed(Routes.WEBVIEW, arguments: {
                'url': 'https://mbg-kabupaten-bandung-info-center.vercel.app/',
                'title': 'Apa itu SPPG'
              }),
            ),
            _buildServiceItem(
              context,
              icon: FontAwesomeIcons.chartPie,
              title: 'Jumlah SPPG',
              color: Colors.purple,
              onTap: () => Get.toNamed(Routes.WEBVIEW, arguments: {
                'url':
                    'https://mbg-kabupaten-bandung-info-center.vercel.app/#sppg',
                'title': 'Jumlah SPPG'
              }),
            ),
            _buildServiceItem(
              context,
              icon: FontAwesomeIcons.users,
              title: 'Sasaran',
              color: Colors.orange,
              // onTap: () {
              //   CustomSnackbar.info(
              //     title: 'Info',
              //     message: 'Fitur Sasaran akan segera hadir',
              //   );
              // },
              onTap: () => Get.toNamed(Routes.WEBVIEW, arguments: {
                'url':
                    'https://mbg-kabupaten-bandung-info-center.vercel.app/#penerima-manfaat',
                'title': 'Sasaran'
              }),
            ),
            _buildServiceItem(
              context,
              icon: FontAwesomeIcons.mapLocationDot,
              title: 'Lokasi SPPG',
              color: Colors.red,
              onTap: () => Get.toNamed(Routes.SPPG_LIST),
            ),
            _buildServiceItem(
              context,
              icon: FontAwesomeIcons.chartLine,
              title: 'Capaian',
              color: Colors.teal,
              onTap: () => Get.toNamed(Routes.WEBVIEW, arguments: {
                'url':
                    'https://mbg-kabupaten-bandung-info-center.vercel.app/#capaian',
                'title': 'Capaian'
              }),
            ),
            _buildServiceItem(
              context,
              icon: FontAwesomeIcons.headset,
              title: 'Kanal Pengaduan',
              color: Colors.green,
              onTap: () {
                controller.navigateToDynamicForm(
                    'kanal-pengaduan-mbg-kabupaten-bandung');
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildServicesSection(BuildContext context) {
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
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.90,
          children: [
            _buildServiceItem(
              context,
              icon: FontAwesomeIcons.layerGroup,
              title: 'Satgas MBG',
              color: Colors.blue,
              onTap: () => Get.toNamed(Routes.DASHBOARD_MBG),
            ),
            _buildServiceItem(
              context,
              icon: FontAwesomeIcons.hospital,
              title: 'Posyandu',
              color: Colors.redAccent,
              onTap: () => Get.toNamed(Routes.DASHBOARD_POSYANDU),
            ),
            _buildServiceItem(
              context,
              icon: FontAwesomeIcons.seedling,
              title: 'Bedas\nMenanam',
              color: Colors.green,
              onTap: () => Get.toNamed(Routes.DASHBOARD_BEDAS_MENANAM),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildServiceItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withOpacity(0.2)),
            ),
            child: FaIcon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  height: 1.2,
                ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildShortcutsSection(BuildContext context) {
    return Obx(() {
      if (controller.shortcuts.isEmpty) {
        return const SizedBox.shrink(); // Hide section if no shortcuts
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Menu Pintas',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
              ),
              if (controller.shortcuts.length > 3)
                TextButton(
                  onPressed: () {
                    _showAllShortcutsDialog(context);
                  },
                  child: const Text('Lihat Semua'),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: controller.shortcuts
                .take(6) // Show max 6 shortcuts
                .map((shortcut) => _buildShortcutItem(context, shortcut))
                .toList(),
          ),
        ],
      );
    });
  }

  Widget _buildShortcutItem(BuildContext context, shortcut) {
    log(shortcut.iconClass.toString());
    // Parse icon from icon_class
    final iconData = IconMapper.mapIcon(shortcut.iconClass);
    // Parse color from color_hex
    final color = _parseColor(shortcut.colorHex);

    return GestureDetector(
      onTap: () {
        _showShortcutActionBottomSheet(context, shortcut);
      },
      child: Container(
        width: (MediaQuery.of(context).size.width - 56) / 3, // 3 columns
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: FaIcon(iconData, color: color, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              shortcut.menu,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    height: 1.2,
                  ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  void _showShortcutActionBottomSheet(BuildContext context, dynamic shortcut) {
    final iconData = IconMapper.mapIcon(shortcut.iconClass);
    final color = _parseColor(shortcut.colorHex);

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
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: FaIcon(iconData, color: color, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        shortcut.menu,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (shortcut.deskripsi != null &&
                          shortcut.deskripsi!.isNotEmpty)
                        Text(
                          shortcut.deskripsi!,
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
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: const Text('Buat data baru'),
              onTap: () {
                Get.back();
                controller.navigateToDynamicFormFromShortcut(shortcut.slug);
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
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: const Text('Lihat daftar data yang sudah ada'),
              onTap: () {
                Get.back(); // Close bottom sheet

                // Check if menu has required_filter
                if (shortcut.requiredFilter != null &&
                    shortcut.requiredFilter.isNotEmpty &&
                    shortcut.requiredFilter != "0,0") {
                  // Navigate to filter page first
                  controller.navigateToFilterPageFromShortcut(shortcut);
                } else {
                  // Direct to data list (existing flow)
                  controller.navigateToDataListFromShortcut(
                      shortcut.slug, shortcut.menu);
                }
              },
            ),
            const SizedBox(height: 8),

            // Remove from shortcuts button
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.push_pin_outlined, color: Colors.red),
              ),
              title: const Text(
                'Hapus dari Menu Pintas',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: const Text('Hapus shortcut dari halaman utama'),
              onTap: () {
                Get.back();
                controller.removeShortcut(shortcut.slug);
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

  void _showAllShortcutsDialog(BuildContext context) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          constraints: const BoxConstraints(maxHeight: 600),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Semua Menu Pintas',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Obx(() => GridView.builder(
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.85,
                      ),
                      itemCount: controller.shortcuts.length,
                      itemBuilder: (context, index) {
                        final shortcut = controller.shortcuts[index];
                        return _buildShortcutItem(context, shortcut);
                      },
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _parseIconData(String iconClass) {
    // Import icon mapper utility
    final Map<String, IconData> iconMap = {
      'fa-university': FontAwesomeIcons.buildingColumns,
      'fa-building': FontAwesomeIcons.building,
      'fa-hospital': FontAwesomeIcons.hospital,
      'fa-file-alt': FontAwesomeIcons.fileLines,
      'fa-chart-bar': FontAwesomeIcons.chartBar,
      'fa-users': FontAwesomeIcons.users,
      'fa-cog': FontAwesomeIcons.gear,
      'fa-bell': FontAwesomeIcons.bell,
      'fa-envelope': FontAwesomeIcons.envelope,
      'fa-home': FontAwesomeIcons.house,
      'fa-search': FontAwesomeIcons.magnifyingGlass,
      'fa-plus': FontAwesomeIcons.plus,
      'fa-edit': FontAwesomeIcons.penToSquare,
      'fa-trash': FontAwesomeIcons.trash,
      'fa-check': FontAwesomeIcons.check,
      'fa-times': FontAwesomeIcons.xmark,
      'fa-arrow-left': FontAwesomeIcons.arrowLeft,
      'fa-arrow-right': FontAwesomeIcons.arrowRight,
      'fa-cutlery': FontAwesomeIcons.cutlery,
    };

    return iconMap[iconClass] ?? FontAwesomeIcons.circle;
  }

  Color _parseColor(String colorHex) {
    try {
      // Remove # if present
      final hex = colorHex.replaceAll('#', '');
      // Add FF for full opacity
      return Color(int.parse('FF$hex', radix: 16));
    } catch (e) {
      return const Color(0xFF14B8A6); // Default teal
    }
  }

  Widget _buildNewsSection(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Berita Terbaru',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
            ),
            TextButton(
              onPressed: () {
                CustomSnackbar.info(
                  title: 'Berita',
                  message: 'Halaman semua berita akan segera hadir',
                );
              },
              child: const Text('Lihat Semua'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Obx(() {
          if (controller.isLoadingNews.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.latestNews.isEmpty) {
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
            itemCount: controller.latestNews.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final news = controller.latestNews[index];
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

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {
          Get.dialog(
            AlertDialog(
              title: const Text('Konfirmasi Logout'),
              content: const Text('Apakah anda yakin ingin keluar aplikasi?'),
              actions: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text('Batal'),
                ),
                TextButton(
                  onPressed: () {
                    Get.back();
                    controller.logout();
                  },
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  child: const Text('Ya, Keluar'),
                ),
              ],
            ),
          );
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.red,
          side: const BorderSide(color: Colors.red),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: const Icon(Icons.logout),
        label: const Text('Keluar Aplikasi'),
      ),
    );
  }
}
