import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../controllers/home_controller.dart';
import '../../../routes/app_routes.dart';
import '../../../core/widgets/news_card_widget.dart';
import '../../../core/widgets/custom_snackbar.dart';
import '../../../core/utils/icon_mapper.dart';

class HomeAlternativeView extends GetView<HomeController> {
  const HomeAlternativeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => controller.refreshData(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(context),
                // _buildSearchBar(context),
                _buildBannerSection(context),
                _buildInfoSection(context),
                _buildServicesSection(context),
                _buildShortcutsSection(context),
                _buildNewsSection(context),
                const SizedBox(height: 32),
                _buildLogoutButton(context),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade100, width: 2),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/logo.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                right: -2,
                bottom: -2,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Halo,',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                Obx(() => Text(
                      controller.user.value?.nmLengkap ?? 'Tamu',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Icon(Icons.location_on,
                      size: 16, color: Colors.blue.shade700),
                  const SizedBox(width: 4),
                  Text(
                    'LOKASI',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ],
              ),
              Obx(() => Text(
                    controller.user.value?.skpdNama ?? 'Kabupaten Bandung',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                    textAlign: TextAlign.right,
                  )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            Icon(Icons.search, color: Colors.grey.shade400),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Cari layanan atau informasi...',
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              height: 30,
              width: 1,
              color: Colors.grey.shade300,
            ),
            IconButton(
              icon: Icon(Icons.tune, color: Colors.blue.shade700, size: 20),
              onPressed: () {
                CustomSnackbar.info(
                    title: 'Filter',
                    message: 'Fitur filter pencarian akan segera hadir');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBannerSection(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingBanners.value) {
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'INFORMASI',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                  letterSpacing: 1.2,
                ),
              ),
              GestureDetector(
                onTap: () => _showInfoBottomSheet(context),
                child: Text(
                  'Lihat Semua',
                  style: TextStyle(
                      color: Colors.blue.shade700,
                      fontWeight: FontWeight.bold,
                      fontSize: 13),
                ),
              ),
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              _buildInfoCard(
                context,
                icon: Icons.lightbulb,
                title: 'Apa aplikasi ini?',
                subtitle: 'Pelajari selengkapnya',
                color: Colors.blue.shade50.withOpacity(0.5),
                iconColor: Colors.amber,
                onTap: () => Get.toNamed(Routes.WEBVIEW, arguments: {
                  'url':
                      'https://mbg-kabupaten-bandung-info-center.vercel.app/',
                  'title': 'Apa itu SPPG'
                }),
              ),
              const SizedBox(width: 16),
              _buildInfoCard(
                context,
                icon: Icons.wallet,
                title: 'Capaian Program',
                subtitle: 'Gunakan filter data',
                color: Colors.green.shade50.withOpacity(0.5),
                iconColor: Colors.blue.shade400,
                onTap: () => Get.toNamed(Routes.WEBVIEW, arguments: {
                  'url':
                      'https://mbg-kabupaten-bandung-info-center.vercel.app/#capaian',
                  'title': 'Capaian'
                }),
              ),
              const SizedBox(width: 16),
              _buildInfoCard(
                context,
                icon: Icons.people,
                title: 'Data Sasaran',
                subtitle: 'Penerima manfaat',
                color: Colors.orange.shade50.withOpacity(0.5),
                iconColor: Colors.orange,
                onTap: () => Get.toNamed(Routes.WEBVIEW, arguments: {
                  'url':
                      'https://mbg-kabupaten-bandung-info-center.vercel.app/#penerima-manfaat',
                  'title': 'Sasaran'
                }),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showInfoBottomSheet(BuildContext context) {
    final List<Map<String, dynamic>> infoItems = [
      {
        'title': 'Apa aplikasi ini?',
        'description':
            'Aplikasi MBG & SPPG adalah solusi satu pintu untuk pemantauan program Makan Bergizi Gratis di Kabupaten Bandung.',
        'icon': Icons.lightbulb,
        'iconColor': Colors.amber,
        'onTap': () => Get.toNamed(Routes.WEBVIEW, arguments: {
              'url': 'https://mbg-kabupaten-bandung-info-center.vercel.app/',
              'title': 'Apa itu SPPG'
            }),
      },
      {
        'title': 'Informasi Capaian',
        'description':
            'Pantau rekapitulasi data capaian program secara real-time dan transparan.',
        'icon': Icons.wallet,
        'iconColor': Colors.blue.shade400,
        'onTap': () => Get.toNamed(Routes.WEBVIEW, arguments: {
              'url':
                  'https://mbg-kabupaten-bandung-info-center.vercel.app/#capaian',
              'title': 'Capaian'
            }),
      },
      {
        'title': 'Pusat Bantuan',
        'description':
            'Butuh bantuan teknis? Hubungi tim dukungan kami yang siap membantu operasional program.',
        'icon': Icons.headset_mic,
        'iconColor': Colors.red.shade400,
        'onTap': () {},
      },
      {
        'title': 'Keamanan Akun',
        'description':
            'Tips menjaga keamanan akun Anda dan langkah-langkah verifikasi data petugas.',
        'icon': Icons.security,
        'iconColor': Colors.green.shade400,
        'onTap': () {},
      },
      {
        'title': 'Syarat & Ketentuan',
        'description':
            'Baca syarat dan ketentuan penggunaan aplikasi serta kebijakan privasi data pengguna.',
        'icon': Icons.assignment,
        'iconColor': Colors.purple.shade400,
        'onTap': () {},
      },
    ];

    Get.bottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 20, 16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                    onPressed: () => Get.back(),
                  ),
                  const Text(
                    'Pusat Informasi',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: infoItems.length,
                itemBuilder: (context, index) {
                  final item = infoItems[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade100),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: (item['iconColor'] as Color).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(item['icon'] as IconData,
                            color: item['iconColor'] as Color, size: 24),
                      ),
                      title: Text(
                        item['title'] as String,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          item['description'] as String,
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 13,
                            height: 1.4,
                          ),
                        ),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios,
                          size: 14, color: Colors.blue.shade700),
                      onTap: () {
                        if (item['onTap'] != null) {
                          Get.back();
                          (item['onTap'] as VoidCallback)();
                        }
                      },
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text('Selesai',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
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
        width: 200,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: iconColor.withOpacity(0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: iconColor, size: 28),
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
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServicesSection(BuildContext context) {
    final List<Map<String, dynamic>> services = [
      {
        'title': 'Satgas MBG',
        'icon': FontAwesomeIcons.layerGroup,
        'color': Colors.blue.shade50,
        'iconColor': Colors.blue.shade700,
        'onTap': () => Get.toNamed(Routes.DASHBOARD_MBG),
      },
      {
        'title': 'Posyandu',
        'icon': FontAwesomeIcons.hospital,
        'color': Colors.red.shade50,
        'iconColor': Colors.red.shade700,
        'onTap': () => Get.toNamed(Routes.DASHBOARD_POSYANDU),
      },
      {
        'title': 'Bedas\nMenanam',
        'icon': FontAwesomeIcons.seedling,
        'color': Colors.green.shade50,
        'iconColor': Colors.green.shade700,
        'onTap': () => Get.toNamed(Routes.DASHBOARD_BEDAS_MENANAM),
      },
      {
        'title': 'Pengaduan',
        'icon': FontAwesomeIcons.headset,
        'color': Colors.orange.shade50,
        'iconColor': Colors.orange.shade700,
        'onTap': () => controller
            .navigateToDynamicForm('kanal-pengaduan-mbg-kabupaten-bandung'),
      },
      {
        'title': 'Lokasi SPPG',
        'icon': FontAwesomeIcons.mapLocationDot,
        'color': Colors.indigo.shade50,
        'iconColor': Colors.indigo.shade700,
        'onTap': () => Get.toNamed(Routes.SPPG_LIST),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Layanan Kami',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              GestureDetector(
                onTap: () => _showAllServicesBottomSheet(context, services),
                child: Text(
                  'Lihat Semua',
                  style: TextStyle(
                      color: Colors.blue.shade700,
                      fontWeight: FontWeight.bold,
                      fontSize: 13),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              crossAxisSpacing: 12,
              mainAxisSpacing: 16,
              childAspectRatio: 0.65,
            ),
            itemCount: services.length,
            itemBuilder: (context, index) {
              final service = services[index];
              return _buildServiceItem(
                context,
                title: service['title'],
                icon: service['icon'],
                color: service['color'],
                iconColor: service['iconColor'],
                onTap: service['onTap'],
              );
            },
          ),
        ),
      ],
    );
  }

  void _showAllServicesBottomSheet(
      BuildContext context, List<Map<String, dynamic>> initialServices) {
    // Combine initial services with placeholders to match the screenshot style
    final List<Map<String, dynamic>> allServices = [
      ...initialServices,
    ];

    Get.bottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            // Handle bar
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 20, 16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                    onPressed: () => Get.back(),
                  ),
                  const Text(
                    'Semua Layanan',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            // Search Bar
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 20),
            //   child: Container(
            //     padding: const EdgeInsets.symmetric(horizontal: 16),
            //     decoration: BoxDecoration(
            //       color: Colors.grey.shade50,
            //       borderRadius: BorderRadius.circular(12),
            //       border: Border.all(color: Colors.grey.shade100),
            //     ),
            //     child: TextField(
            //       decoration: InputDecoration(
            //         hintText: 'Cari layanan...',
            //         hintStyle:
            //             TextStyle(color: Colors.grey.shade400, fontSize: 14),
            //         icon: Icon(Icons.search, color: Colors.grey.shade400),
            //         border: InputBorder.none,
            //         contentPadding: const EdgeInsets.symmetric(vertical: 14),
            //       ),
            //     ),
            //   ),
            // ),

            // const SizedBox(height: 24),

            // Grid
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 24,
                  childAspectRatio: 0.75,
                ),
                itemCount: allServices.length,
                itemBuilder: (context, index) {
                  final service = allServices[index];
                  return _buildServiceItem(
                    context,
                    title: service['title'],
                    icon: service['icon'],
                    color: service['color'],
                    iconColor: service['iconColor'],
                    onTap: () {
                      if (service['onTap'] != null) {
                        Get.back();
                        service['onTap']();
                      }
                    },
                  );
                },
              ),
            ),

            // Footer
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                'Layanan baru akan ditambahkan secara berkala.',
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
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
                child: FaIcon(icon, color: iconColor, size: 20),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 10,
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

  Widget _buildShortcutsSection(BuildContext context) {
    return Obx(() {
      if (controller.shortcuts.isEmpty) {
        return const SizedBox.shrink();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Menu Pintas',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    'Atur',
                    style: TextStyle(
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.bold,
                        fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: controller.shortcuts.length,
              itemBuilder: (context, index) {
                final shortcut = controller.shortcuts[index];
                final iconData = IconMapper.mapIcon(shortcut.iconClass);
                final color = _parseColor(shortcut.colorHex);

                return GestureDetector(
                  onTap: () => controller
                      .navigateToDynamicFormFromShortcut(shortcut.slug),
                  child: Container(
                    width: 80,
                    margin: const EdgeInsets.only(right: 12),
                    child: Column(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: FaIcon(iconData, color: color, size: 24),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          shortcut.menu,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }

  Widget _buildNewsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
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
              GestureDetector(
                onTap: () {},
                child: Text(
                  'Lihat Semua',
                  style: TextStyle(
                      color: Colors.blue.shade700,
                      fontWeight: FontWeight.bold,
                      fontSize: 13),
                ),
              ),
            ],
          ),
        ),
        Obx(() {
          if (controller.isLoadingNews.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.latestNews.isEmpty) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
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
            itemCount: controller.latestNews.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: OutlinedButton.icon(
        onPressed: () => controller.logout(),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.red,
          side: BorderSide(color: Colors.red.shade200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: const Icon(Icons.logout, size: 20),
        label: const Text('Keluar dari Akun',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  Color _parseColor(String colorHex) {
    try {
      final hex = colorHex.replaceAll('#', '');
      return Color(int.parse('FF$hex', radix: 16));
    } catch (e) {
      return const Color(0xFF14B8A6);
    }
  }
}
