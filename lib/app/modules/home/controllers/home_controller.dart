import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/storage_service.dart';
import '../../../data/providers/content_provider.dart';
import '../../../data/providers/otp_provider.dart';
import '../../../data/models/user_model.dart';
import '../../../routes/app_routes.dart';
import '../../../core/widgets/banner_carousel_widget.dart';
import '../../../data/models/news_model.dart';
import '../../../core/widgets/custom_snackbar.dart';

class HomeController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final StorageService _storageService = Get.find<StorageService>();
  final ContentProvider _contentProvider = Get.find<ContentProvider>();
  final OtpProvider _otpProvider = OtpProvider();

  // Cached password from API
  String? _cachedPassword;
  DateTime? _passwordCacheTime;
  static const int _passwordCacheDurationMinutes = 30; // Cache for 30 minutes

  // Observable user
  Rx<UserModel?> user = Rx<UserModel?>(null);

  // Getter to check if current user is Guest
  bool get isGuestUser => user.value?.isGuest ?? false;

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

  // Password controller for Bedas Menanam protection
  final TextEditingController _bedasMenanamPasswordController = TextEditingController();
  final RxBool _isBedasMenanamPasswordVisible = false.obs;

  @override
  void onClose() {
    _bedasMenanamPasswordController.dispose();
    _bedasMenanamSearchPasswordController.dispose();
    super.onClose();
  }

  // Toggle password visibility for Bedas Menanam
  void toggleBedasMenanamPasswordVisibility() {
    _isBedasMenanamPasswordVisible.value = !_isBedasMenanamPasswordVisible.value;
  }

  // Show Bedas Menanam password protection dialog
  Future<void> showBedasMenanamPasswordDialog() async {
    _bedasMenanamPasswordController.clear();
    _isBedasMenanamPasswordVisible.value = false;

    await Get.dialog(
      AlertDialog(
        title: Row(
          children: [
            Icon(Icons.lock, color: Get.theme.colorScheme.primary),
            const SizedBox(width: 8),
            const Text('Akses Terbatas'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Form Bedas Menanam adalah form yang sangat sensitif. '
                'Anda harus memasukkan password yang tepat untuk mengakses form ini.',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              Obx(
                () => TextField(
                  controller: _bedasMenanamPasswordController,
                  obscureText: !_isBedasMenanamPasswordVisible.value,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Masukkan password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isBedasMenanamPasswordVisible.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: toggleBedasMenanamPasswordVisibility,
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) async => await _verifyBedasMenanamPassword(),
                ),
              ),
              const SizedBox(height: 12),
              TextButton.icon(
                onPressed: _contactCoordinator,
                icon: const Icon(Icons.phone, size: 18),
                label: const Text('Hubungi Koordinator Lapangan'),
                style: TextButton.styleFrom(
                  foregroundColor: Get.theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async => await _verifyBedasMenanamPassword(),
            child: const Text('Masuk'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  // Get password from API with caching
  Future<String?> _getPasswordFromApi() async {
    // Check cache first
    if (_cachedPassword != null && _passwordCacheTime != null) {
      final cacheAge = DateTime.now().difference(_passwordCacheTime!);
      if (cacheAge.inMinutes < _passwordCacheDurationMinutes) {
        return _cachedPassword;
      }
    }

    try {
      final response = await _otpProvider.getPassword();
      if (response.success && response.password.isNotEmpty) {
        _cachedPassword = response.password;
        _passwordCacheTime = DateTime.now();
        return _cachedPassword;
      } else {
        throw Exception('Invalid password response from API');
      }
    } catch (e) {
      CustomSnackbar.error(
        title: 'Gagal Memuat Password',
        message: 'Tidak dapat mengambil password dari server. Silakan coba lagi.',
      );
      return null;
    }
  }

  // Verify Bedas Menanam password
  Future<void> _verifyBedasMenanamPassword() async {
    final enteredPassword = _bedasMenanamPasswordController.text.trim();

    if (enteredPassword.isEmpty) {
      CustomSnackbar.error(
        title: 'Password Kosong',
        message: 'Mohon masukkan password terlebih dahulu',
      );
      return;
    }

    // Get password from API
    final correctPassword = await _getPasswordFromApi();
    if (correctPassword == null) {
      return; // Error already shown in _getPasswordFromApi
    }

    if (enteredPassword == correctPassword) {
      Get.back(); // Close dialog
      navigateToDynamicForm(
        'gerakan-menanam-komoditas-sayuran-untuk-ketahanan-pangan',
      );
      CustomSnackbar.success(
        title: 'Akses Diberikan',
        message: 'Anda dapat mengakses form Bedas Menanam',
      );
    } else {
      CustomSnackbar.error(
        title: 'Password Salah',
        message: 'Password yang Anda masukkan tidak benar. Silakan coba lagi atau hubungi koordinator lapangan.',
      );
    }
  }

  // Password controller for Bedas Menanam Search protection
  final TextEditingController _bedasMenanamSearchPasswordController = TextEditingController();
  final RxBool _isBedasMenanamSearchPasswordVisible = false.obs;

  // Toggle password visibility for Bedas Menanam Search
  void toggleBedasMenanamSearchPasswordVisibility() {
    _isBedasMenanamSearchPasswordVisible.value = !_isBedasMenanamSearchPasswordVisible.value;
  }

  // Show Bedas Menanam Search password protection dialog
  Future<void> showBedasMenanamSearchPasswordDialog() async {
    _bedasMenanamSearchPasswordController.clear();
    _isBedasMenanamSearchPasswordVisible.value = false;

    await Get.dialog(
      AlertDialog(
        title: Row(
          children: [
            Icon(Icons.lock, color: Get.theme.colorScheme.primary),
            const SizedBox(width: 8),
            const Text('Akses Terbatas'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Data Bedas Menanam adalah data yang sangat sensitif. '
                'Anda harus memasukkan password yang tepat untuk mengakses data ini.',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              Obx(
                () => TextField(
                  controller: _bedasMenanamSearchPasswordController,
                  obscureText: !_isBedasMenanamSearchPasswordVisible.value,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Masukkan password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isBedasMenanamSearchPasswordVisible.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: toggleBedasMenanamSearchPasswordVisibility,
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) async => await _verifyBedasMenanamSearchPassword(),
                ),
              ),
              const SizedBox(height: 12),
              TextButton.icon(
                onPressed: _contactCoordinator,
                icon: const Icon(Icons.phone, size: 18),
                label: const Text('Hubungi Koordinator Lapangan'),
                style: TextButton.styleFrom(
                  foregroundColor: Get.theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async => await _verifyBedasMenanamSearchPassword(),
            child: const Text('Masuk'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  // Verify Bedas Menanam Search password
  Future<void> _verifyBedasMenanamSearchPassword() async {
    final enteredPassword = _bedasMenanamSearchPasswordController.text.trim();

    if (enteredPassword.isEmpty) {
      CustomSnackbar.error(
        title: 'Password Kosong',
        message: 'Mohon masukkan password terlebih dahulu',
      );
      return;
    }

    // Get password from API
    final correctPassword = await _getPasswordFromApi();
    if (correctPassword == null) {
      return; // Error already shown in _getPasswordFromApi
    }

    if (enteredPassword == correctPassword) {
      Get.back(); // Close dialog
      Get.toNamed(Routes.BEDAS_MENANAM_SEARCH);
      CustomSnackbar.success(
        title: 'Akses Diberikan',
        message: 'Anda dapat mengakses data Bedas Menanam',
      );
    } else {
      CustomSnackbar.error(
        title: 'Password Salah',
        message: 'Password yang Anda masukkan tidak benar. Silakan coba lagi atau hubungi koordinator lapangan.',
      );
    }
  }

  // Contact coordinator (opens phone dialer or shows contact info)
  void _contactCoordinator() {
    Get.dialog(
      AlertDialog(
        title: const Text('Hubungi Koordinator Lapangan'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Jika Anda tidak mengetahui password, silakan hubungi koordinator lapangan Anda untuk mendapatkan akses.',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 16),
            Text(
              'Catatan:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '• Form ini sangat sensitif dan memerlukan otorisasi khusus\n'
              '• Hanya koordinator lapangan yang berwenang yang dapat memberikan password\n'
              '• Pastikan Anda memiliki izin sebelum mengakses form ini',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
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
