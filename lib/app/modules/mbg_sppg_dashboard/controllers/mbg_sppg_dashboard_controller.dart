import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../routes/app_routes.dart';
import '../../../core/widgets/banner_carousel_widget.dart';
import '../../../data/models/news_model.dart';

class MbgSppgDashboardController extends GetxController {
  // Dashboard Data
  final RxList<BannerItem> banners = <BannerItem>[].obs;
  final RxList<NewsModel> newsList = <NewsModel>[].obs;
  final RxMap<String, String> statistics = <String, String>{}.obs;
  final RxBool isLoadingData = false.obs;

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

    // Dummy Statistics
    statistics.value = {
      'Total Penerima': '45.2K',
      'SPPG Aktif': '128',
      'Sekolah': '350',
      'Paket Tersalur': '1.2M',
    };

    // Dummy News
    newsList.value = [
      NewsModel(
        idPost: 1,
        title: 'Monitoring Kualitas Makanan',
        description:
            'Tim Satgas MBG melakukan monitoring mendadak ke beberapa SPPG untuk memastikan kualitas makanan.',
        imageUrl:
            'https://images.unsplash.com/photo-1504674900247-0877df9cc836?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=60',
        imageSmallUrl: '',
        imageMiddleUrl: '',
        url: 'monitoring-mbg',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        author: 'Satgas MBG',
        category: 'Berita',
      ),
      NewsModel(
        idPost: 2,
        title: 'Sosialisasi Gizi Seimbang',
        description:
            'Edukasi pentingnya gizi seimbang bagi pertumbuhan anak usia sekolah.',
        imageUrl:
            'https://images.unsplash.com/photo-1490818387583-1baba5e638af?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=60',
        imageSmallUrl: '',
        imageMiddleUrl: '',
        url: 'sosialisasi-gizi',
        createdAt: DateTime.now().subtract(const Duration(days: 4)),
        author: 'Dinas Kesehatan',
        category: 'Edukasi',
      ),
    ];

    isLoadingData.value = false;
  }

  void navigateToDynamicForm(String slug) {
    Get.toNamed(Routes.DYNAMIC_FORM, arguments: slug);
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
