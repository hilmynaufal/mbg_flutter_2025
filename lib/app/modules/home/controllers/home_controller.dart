import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/storage_service.dart';
import '../../../data/models/user_model.dart';
import '../../../routes/app_routes.dart';
import '../../../core/widgets/banner_carousel_widget.dart';
import '../../../data/models/news_model.dart';
import '../../../data/dummy/news_dummy_data.dart';

class HomeController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final StorageService _storageService = Get.find<StorageService>();

  // Observable user
  Rx<UserModel?> user = Rx<UserModel?>(null);

  // Observable banners
  RxList<BannerItem> banners = <BannerItem>[].obs;

  // Observable news
  RxList<NewsModel> latestNews = <NewsModel>[].obs;

  // Observable report statistics
  RxInt reportCount = 0.obs;
  RxInt pendingReports = 0.obs;
  RxInt approvedReports = 0.obs;
  RxInt rejectedReports = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
    _loadBanners();
    _loadLatestNews();
    _loadReportCount();
  }

  // Load user data
  void _loadUserData() {
    user.value = _authService.getUser();
  }

  // Load banners
  void _loadBanners() {
    banners.value = [
      BannerItem(
        id: '1',
        imageUrl: 'https://via.placeholder.com/800x400/14B8A6/FFFFFF?text=Sistem+Pelaporan+SPPG',
        title: 'Sistem Pelaporan SPPG',
        description: 'Laporkan PHK dengan mudah dan cepat',
      ),
      BannerItem(
        id: '2',
        imageUrl: 'https://via.placeholder.com/800x400/2196F3/FFFFFF?text=Perlindungan+Pekerja',
        title: 'Perlindungan Hak Pekerja',
        description: 'Kami melindungi hak-hak ketenagakerjaan Anda',
      ),
      BannerItem(
        id: '3',
        imageUrl: 'https://via.placeholder.com/800x400/4CAF50/FFFFFF?text=Kabupaten+Bandung',
        title: 'Dinas Tenaga Kerja Kab. Bandung',
        description: 'Melayani dengan sepenuh hati',
      ),
      BannerItem(
        id: '4',
        imageUrl: 'https://via.placeholder.com/800x400/FF9800/FFFFFF?text=Konsultasi+Gratis',
        title: 'Layanan Konsultasi Gratis',
        description: 'Dapatkan bantuan hukum ketenagakerjaan',
      ),
    ];
  }

  // Load latest news
  void _loadLatestNews() {
    latestNews.value = NewsDummyData.getLatestNews(limit: 3);
  }

  // Load report count
  void _loadReportCount() {
    // TODO: Replace with actual API call
    // For now, using dummy data or from storage
    final storedCount = _storageService.readInt('report_count') ?? 0;
    final storedPending = _storageService.readInt('pending_reports') ?? 0;
    final storedApproved = _storageService.readInt('approved_reports') ?? 0;
    final storedRejected = _storageService.readInt('rejected_reports') ?? 0;

    reportCount.value = storedCount;
    pendingReports.value = storedPending;
    approvedReports.value = storedApproved;
    rejectedReports.value = storedRejected;
  }

  // Increment report count (akan dipanggil setelah submit form berhasil)
  Future<void> incrementReportCount() async {
    reportCount.value++;
    pendingReports.value++;
    await _storageService.writeInt('report_count', reportCount.value);
    await _storageService.writeInt('pending_reports', pendingReports.value);
  }

  // Refresh data
  Future<void> refreshData() async {
    _loadUserData();
    _loadBanners();
    _loadLatestNews();
    _loadReportCount();
  }

  // Navigate to Form SPPG
  void navigateToFormSppg() {
    Get.toNamed(Routes.FORM_SPPG);
  }

  // Logout
  Future<void> logout() async {
    // Show confirmation dialog
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Konfirmasi Logout'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _authService.logout();
      Get.offAllNamed(Routes.LOGIN);
      Get.snackbar(
        'Logout Berhasil',
        'Anda telah keluar dari aplikasi',
        snackPosition: SnackPosition.TOP,
      );
    }
  }
}
