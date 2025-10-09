import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/storage_service.dart';
import '../../../data/providers/content_provider.dart';
import '../../../data/models/user_model.dart';
import '../../../routes/app_routes.dart';
import '../../../core/widgets/banner_carousel_widget.dart';
import '../../../data/models/news_model.dart';
import '../../../core/widgets/custom_snackbar.dart';

class HomeController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final StorageService _storageService = Get.find<StorageService>();
  final ContentProvider _contentProvider = Get.find<ContentProvider>();

  // Observable user
  Rx<UserModel?> user = Rx<UserModel?>(null);

  // Observable banners
  RxList<BannerItem> banners = <BannerItem>[].obs;
  RxBool isLoadingBanners = false.obs;

  // Observable news
  RxList<NewsModel> latestNews = <NewsModel>[].obs;
  RxBool isLoadingNews = false.obs;

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

  // Load banners from API
  Future<void> _loadBanners() async {
    try {
      isLoadingBanners.value = true;
      final slides = await _contentProvider.getSlides();

      // Convert SlideModel to BannerItem
      banners.value = slides
          .where((slide) => slide.status == 1) // Only active slides
          .map((slide) => BannerItem(
                id: slide.idSlide.toString(),
                imageUrl: slide.imageUrl,
                title: slide.name,
                description: slide.description ?? '',
              ))
          .toList();
    } catch (e) {
      print('Error loading banners: $e');
      CustomSnackbar.error(
        title: 'Gagal Memuat Banner',
        message: 'Tidak dapat memuat banner. $e',
      );
      // Fallback to empty list or keep existing banners
    } finally {
      isLoadingBanners.value = false;
    }
  }

  // Load latest news from API
  Future<void> _loadLatestNews() async {
    try {
      isLoadingNews.value = true;
      final posts = await _contentProvider.getPosts(limit: 3);
      latestNews.value = posts;
    } catch (e) {
      print('Error loading news: $e');
      CustomSnackbar.error(
        title: 'Gagal Memuat Berita',
        message: 'Tidak dapat memuat berita terbaru. $e',
      );
      // Fallback to empty list or keep existing news
    } finally {
      isLoadingNews.value = false;
    }
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

  // Navigate to Dynamic Form with slug
  void navigateToDynamicForm(String slug) {
    Get.toNamed(Routes.DYNAMIC_FORM, arguments: slug);
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
      CustomSnackbar.success(
        title: 'Logout Berhasil',
        message: 'Anda telah keluar dari aplikasi',
      );
    }
  }
}
