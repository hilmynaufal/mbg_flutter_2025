import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../routes/app_routes.dart';
import '../../../data/services/storage_service.dart';
import '../../../data/providers/otp_provider.dart';
import '../../../core/values/constants.dart';
import '../../../core/widgets/custom_snackbar.dart';
import '../../../core/widgets/banner_carousel_widget.dart';
import '../../../data/models/news_model.dart';

class BedasMenanamDashboardController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();
  final OtpProvider _otpProvider = OtpProvider();

  // Cached password from API
  String? _cachedPassword;
  DateTime? _passwordCacheTime;
  static const int _passwordCacheDurationMinutes = 30;

  // Password controllers
  final TextEditingController bedasMenanamPasswordController =
      TextEditingController();
  final RxBool isBedasMenanamPasswordVisible = false.obs;

  final TextEditingController bedasMenanamSearchPasswordController =
      TextEditingController();
  final RxBool isBedasMenanamSearchPasswordVisible = false.obs;

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

  @override
  void onClose() {
    bedasMenanamPasswordController.dispose();
    bedasMenanamSearchPasswordController.dispose();
    super.onClose();
  }

  void _loadDashboardData() async {
    isLoadingData.value = true;
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

    // Dummy Banners
    banners.value = [
      BannerItem(
        id: '1',
        imageUrl:
            'https://images.unsplash.com/photo-1592419044706-39796d40f98c?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
        title: 'Gerakan Bedas Menanam',
        description: 'Bersama hijaukan Kabupaten Bandung',
      ),
      BannerItem(
        id: '2',
        imageUrl:
            'https://images.unsplash.com/photo-1625246333195-78d9c38ad449?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
        title: 'Petani Milenial',
        description: 'Mewujudkan pertanian modern dan berkelanjutan',
      ),
    ];

    // Dummy Statistics
    statistics.value = {
      'Total Pohon': '15.4K',
      'Petani Aktif': '1,250',
      'Luas Lahan': '450 Ha',
      'Kecamatan': '31',
    };

    // Dummy News
    newsList.value = [
      NewsModel(
        idPost: 1,
        title: 'Bupati Bandung Tanam 1000 Pohon',
        description:
            'Bupati Bandung Dadang Supriatna memimpin aksi penanaman 1000 pohon di kawasan hulu sungai Citarum.',
        imageUrl:
            'https://images.unsplash.com/photo-1542601906990-b4d3fb778b09?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=60',
        imageSmallUrl: '',
        imageMiddleUrl: '',
        url: 'bupati-tanam-pohon',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        author: 'Humas',
        category: 'Kegiatan',
      ),
      NewsModel(
        idPost: 2,
        title: 'Panen Raya Jagung Hibrida',
        description:
            'Kelompok tani di Kecamatan Soreang berhasil melakukan panen raya jagung hibrida dengan hasil melimpah.',
        imageUrl:
            'https://images.unsplash.com/photo-1625246333195-78d9c38ad449?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=60',
        imageSmallUrl: '',
        imageMiddleUrl: '',
        url: 'panen-raya-jagung',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        author: 'Dinas Pertanian',
        category: 'Berita',
      ),
    ];

    isLoadingData.value = false;
  }

  void toggleBedasMenanamPasswordVisibility() {
    isBedasMenanamPasswordVisible.value = !isBedasMenanamPasswordVisible.value;
  }

  void toggleBedasMenanamSearchPasswordVisibility() {
    isBedasMenanamSearchPasswordVisible.value =
        !isBedasMenanamSearchPasswordVisible.value;
  }

  Future<bool> _checkSavedPassword() async {
    final savedPassword =
        _storageService.read(AppConstants.keyBedasMenanamPassword);
    if (savedPassword == null || savedPassword.isEmpty) {
      return false;
    }

    final correctPassword = await _getPasswordFromApi();
    if (correctPassword == null) {
      return false;
    }

    return savedPassword == correctPassword;
  }

  Future<String?> _getPasswordFromApi() async {
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
      print('Failed to get password from API, using local fallback: $e');
      CustomSnackbar.warning(
        title: 'Menggunakan Password Lokal',
        message:
            'Tidak dapat mengambil password dari server. Menggunakan password fallback.',
      );
      return 'bedas2025';
    }
  }

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

  Future<void> showBedasMenanamPasswordDialog() async {
    final isPasswordValid = await _checkSavedPassword();
    if (isPasswordValid) {
      Get.toNamed(Routes.DYNAMIC_FORM,
          arguments:
              'gerakan-menanam-komoditas-sayuran-untuk-ketahanan-pangan');
      return;
    }

    bedasMenanamPasswordController.clear();
    isBedasMenanamPasswordVisible.value = false;

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
                  controller: bedasMenanamPasswordController,
                  obscureText: !isBedasMenanamPasswordVisible.value,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Masukkan password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isBedasMenanamPasswordVisible.value
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

  Future<void> _verifyBedasMenanamPassword() async {
    final enteredPassword = bedasMenanamPasswordController.text.trim();

    if (enteredPassword.isEmpty) {
      CustomSnackbar.error(
        title: 'Password Kosong',
        message: 'Mohon masukkan password terlebih dahulu',
      );
      return;
    }

    final correctPassword = await _getPasswordFromApi();

    if (enteredPassword == correctPassword) {
      await _storageService.write(
        AppConstants.keyBedasMenanamPassword,
        enteredPassword,
      );

      Get.back();
      Get.toNamed(Routes.DYNAMIC_FORM,
          arguments:
              'gerakan-menanam-komoditas-sayuran-untuk-ketahanan-pangan');
      CustomSnackbar.success(
        title: 'Akses Diberikan',
        message: 'Anda dapat mengakses form Bedas Menanam',
      );
    } else {
      CustomSnackbar.error(
        title: 'Password Salah',
        message:
            'Password yang Anda masukkan tidak benar. Silakan coba lagi atau hubungi koordinator lapangan.',
      );
    }
  }

  Future<void> showBedasMenanamSearchPasswordDialog() async {
    final isPasswordValid = await _checkSavedPassword();
    if (isPasswordValid) {
      Get.toNamed(Routes.BEDAS_MENANAM_SEARCH);
      return;
    }

    bedasMenanamSearchPasswordController.clear();
    isBedasMenanamSearchPasswordVisible.value = false;

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
                  controller: bedasMenanamSearchPasswordController,
                  obscureText: !isBedasMenanamSearchPasswordVisible.value,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Masukkan password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isBedasMenanamSearchPasswordVisible.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: toggleBedasMenanamSearchPasswordVisibility,
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) async =>
                      await _verifyBedasMenanamSearchPassword(),
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

  Future<void> _verifyBedasMenanamSearchPassword() async {
    final enteredPassword = bedasMenanamSearchPasswordController.text.trim();

    if (enteredPassword.isEmpty) {
      CustomSnackbar.error(
        title: 'Password Kosong',
        message: 'Mohon masukkan password terlebih dahulu',
      );
      return;
    }

    final correctPassword = await _getPasswordFromApi();

    if (enteredPassword == correctPassword) {
      await _storageService.write(
        AppConstants.keyBedasMenanamPassword,
        enteredPassword,
      );

      Get.back();
      Get.toNamed(Routes.BEDAS_MENANAM_SEARCH);
      CustomSnackbar.success(
        title: 'Akses Diberikan',
        message: 'Anda dapat mengakses data Bedas Menanam',
      );
    } else {
      CustomSnackbar.error(
        title: 'Password Salah',
        message:
            'Password yang Anda masukkan tidak benar. Silakan coba lagi atau hubungi koordinator lapangan.',
      );
    }
  }
}
