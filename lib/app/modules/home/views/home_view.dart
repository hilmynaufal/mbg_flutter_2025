import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../controllers/home_controller.dart';
import '../../../routes/app_routes.dart';
import '../../../core/widgets/banner_carousel_widget.dart';
import '../../../core/widgets/service_grid_item.dart';
import '../../../core/widgets/news_card_widget.dart';
import '../../../core/widgets/custom_snackbar.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MBG - Pelaporan SPPG'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: controller.logout,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Banner Carousel
            const SizedBox(height: 16),
            Obx(() {
              if (controller.isLoadingBanners.value) {
                return SizedBox(
                  height: 180,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (controller.banners.isEmpty) {
                return const SizedBox.shrink();
              }

              return BannerCarouselWidget(
                banners: controller.banners,
                height: 180,
                onBannerTap: (banner) {
                  // TODO: Handle banner tap
                  CustomSnackbar.info(
                    title: 'Banner',
                    message: banner.title ?? 'Banner tapped',
                  );
                },
              );
            }),
            const SizedBox(height: 24),

            // Content with padding
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // User Info Card - Hidden (will be moved to Profile page)
                  // Obx(
                  //   () => Card(
                  //     elevation: 4,
                  //     child: Padding(
                  //       padding: const EdgeInsets.all(16.0),
                  //       child: Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           Row(
                  //             children: [
                  //               CircleAvatar(
                  //                 radius: 30,
                  //                 backgroundColor:
                  //                     Theme.of(context).colorScheme.primary,
                  //                 child: Text(
                  //                   controller.user.value?.nmLengkap
                  //                           .substring(0, 1)
                  //                           .toUpperCase() ??
                  //                       'U',
                  //                   style: const TextStyle(
                  //                     fontSize: 24,
                  //                     fontWeight: FontWeight.bold,
                  //                     color: Colors.white,
                  //                   ),
                  //                 ),
                  //               ),
                  //               const SizedBox(width: 16),
                  //               Expanded(
                  //                 child: Column(
                  //                   crossAxisAlignment:
                  //                       CrossAxisAlignment.start,
                  //                   children: [
                  //                     Text(
                  //                       controller.user.value?.nmLengkap ??
                  //                           'User',
                  //                       style: Theme.of(
                  //                         context,
                  //                       ).textTheme.titleLarge?.copyWith(
                  //                         fontWeight: FontWeight.bold,
                  //                       ),
                  //                     ),
                  //                     const SizedBox(height: 4),
                  //                     Text(
                  //                       controller.user.value?.nip ?? '-',
                  //                       style: Theme.of(context)
                  //                           .textTheme
                  //                           .bodyMedium
                  //                           ?.copyWith(color: Colors.grey[600]),
                  //                     ),
                  //                   ],
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //           const Divider(height: 24),
                  //           _buildInfoRow(
                  //             context,
                  //             Icons.work,
                  //             'Jabatan',
                  //             controller.user.value?.jabatan ?? '-',
                  //           ),
                  //           const SizedBox(height: 8),
                  //           _buildInfoRow(
                  //             context,
                  //             Icons.business,
                  //             'SKPD',
                  //             controller.user.value?.skpdNama ?? '-',
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // const SizedBox(height: 16),

                  // Section Title
                  Text(
                    'Layanan Utama',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Services Grid
                  // GridView.count(
                  //   crossAxisCount: 3,
                  //   shrinkWrap: true,
                  //   physics: const NeverScrollableScrollPhysics(),
                  //   crossAxisSpacing: 4,
                  //   mainAxisSpacing: 4,
                  //   childAspectRatio: 0.85,
                  //   children: [
                  //     ServiceGridItem(
                  //       icon: FontAwesomeIcons.fileCirclePlus,
                  //       title: 'Buat Laporan',
                  //       description: 'Laporan SPPG baru',
                  //       onTap:
                  //           () => controller.navigateToDynamicForm(
                  //             'pelaporan-tugas-satgas-mbg',
                  //           ),
                  //       showDescription: false,
                  //     ),
                  //     ServiceGridItem(
                  //       icon: FontAwesomeIcons.fileMedical,
                  //       title: 'Laporan IKL',
                  //       description: 'Laporan IKL Dinkes',
                  //       onTap:
                  //           () => controller.navigateToDynamicForm(
                  //             'pelaporan-tugas-satgas-mbg---dinkes---laporan-ikl',
                  //           ),
                  //       showDescription: false,
                  //     ),
                  //     ServiceGridItem(
                  //       icon: FontAwesomeIcons.clockRotateLeft,
                  //       title: 'Lihat Laporan',
                  //       description: 'Riwayat laporan',
                  //       onTap: () => Get.toNamed(Routes.REPORT_HISTORY),
                  //       showDescription: false,
                  //     ),
                  //   ],
                  // ),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ServiceGridItem(
                        icon: FontAwesomeIcons.fileCirclePlus,
                        title: 'Buat Laporan',
                        description: 'Buat laporan baru',
                        onTap: () {
                          // Show dialog to choose form type
                          Get.dialog(
                            AlertDialog(
                              title: const Text('Pilih Jenis Laporan'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    leading: const Icon(FontAwesomeIcons.fileContract),
                                    title: const Text('Laporan SPPG'),
                                    onTap: () {
                                      Get.back();
                                      controller.navigateToDynamicForm(
                                        'pelaporan-tugas-satgas-mbg',
                                      );
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(FontAwesomeIcons.fileMedical),
                                    title: const Text('Laporan IKL Dinkes'),
                                    onTap: () {
                                      Get.back();
                                      controller.navigateToDynamicForm(
                                        'pelaporan-tugas-satgas-mbg---dinkes---laporan-ikl',
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        showDescription: false,
                      ),
                      ServiceGridItem(
                        icon: FontAwesomeIcons.fileLines,
                        title: 'Laporan SPPG',
                        description: 'Daftar Laporan SPPG',
                        onTap: () => Get.toNamed(Routes.REPORT_LIST, arguments: 'sppg'),
                        showDescription: false,
                      ),
                      ServiceGridItem(
                        icon: FontAwesomeIcons.notesMedical,
                        title: 'Laporan IKL',
                        description: 'Daftar Laporan IKL',
                        onTap: () => Get.toNamed(Routes.REPORT_LIST, arguments: 'ikl'),
                        showDescription: false,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Section Title - Berita Terbaru
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Berita Terbaru',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          // TODO: Navigate to news list page
                          CustomSnackbar.info(
                            title: 'Berita',
                            message: 'Halaman semua berita akan segera hadir',
                          );
                        },
                        icon: const FaIcon(
                          FontAwesomeIcons.arrowRight,
                          size: 14,
                        ),
                        label: const Text('Lihat Semua'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Latest News List
                  Obx(() {
                    if (controller.isLoadingNews.value) {
                      return Card(
                        elevation: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      );
                    }

                    if (controller.latestNews.isEmpty) {
                      return Card(
                        elevation: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Center(
                            child: Column(
                              children: [
                                const FaIcon(
                                  FontAwesomeIcons.newspaper,
                                  size: 48,
                                  color: Colors.grey,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Belum ada berita',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }

                    return Column(
                      children:
                          controller.latestNews.map((news) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 0.0),
                              child: NewsCardWidget(
                                news: news,
                                isHorizontal: true,
                                onTap: () => Get.toNamed(
                                  Routes.NEWS_DETAIL,
                                  arguments: news.url,
                                ),
                              ),
                            );
                          }).toList(),
                    );
                  }),
                  const SizedBox(height: 24),

                  // Logout Button
                  OutlinedButton.icon(
                    onPressed: controller.logout,
                    icon: const Icon(Icons.logout),
                    label: const Text('Logout'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.error,
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.error,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
              ),
              Text(value, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}
