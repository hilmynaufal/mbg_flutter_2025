import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import '../../../core/widgets/banner_carousel_widget.dart';
import '../../../data/models/news_model.dart';
import '../../../data/providers/content_provider.dart';

class PosyanduDashboardController extends GetxController {
  // Services
  final ContentProvider _contentProvider = Get.find<ContentProvider>();

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
            'https://images.unsplash.com/photo-1576765608535-5f04d1e3f289?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
        title: 'Posyandu Aktif',
        description: 'Layanan kesehatan ibu dan anak terpadu',
      ),
      BannerItem(
        id: '2',
        imageUrl:
            'https://images.unsplash.com/photo-1532938911079-1b06ac7ceec7?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
        title: 'Imunisasi Lengkap',
        description: 'Lindungi buah hati dengan imunisasi lengkap',
      ),
    ];

    // Statistics hidden - no data loaded
    statistics.value = {};

    // Load news from API (same as HomeController)
    try {
      final posts = await _contentProvider.getPosts(limit: 3);
      newsList.value = posts;
    } catch (e) {
      print('Error loading news: $e');
      // Silent failure - keep empty list
    }

    isLoadingData.value = false;
  }

  void navigateToPosyanduEdit() {
    Get.toNamed(
      Routes.POSYANDU_EDIT,
      arguments: {
        'slug': 'pendataan-profil-posyandu-aktif-di-kabupaten-bandung',
        'title': 'Edit Data Posyandu',
      },
    );
  }
}
