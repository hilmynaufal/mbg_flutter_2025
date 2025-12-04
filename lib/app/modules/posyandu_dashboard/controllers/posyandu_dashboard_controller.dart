import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import '../../../core/widgets/banner_carousel_widget.dart';
import '../../../data/models/news_model.dart';

class PosyanduDashboardController extends GetxController {
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

    // Dummy Statistics
    statistics.value = {
      'Total Posyandu': '4,321',
      'Kader Aktif': '12.5K',
      'Balita Terdaftar': '85K',
      'Ibu Hamil': '15K',
    };

    // Dummy News
    newsList.value = [
      NewsModel(
        idPost: 1,
        title: 'Pekan Imunisasi Nasional',
        description:
            'Pemerintah Kabupaten Bandung menggelar Pekan Imunisasi Nasional serentak di seluruh Posyandu.',
        imageUrl:
            'https://images.unsplash.com/photo-1632053001128-93661129668d?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=60',
        imageSmallUrl: '',
        imageMiddleUrl: '',
        url: 'pekan-imunisasi',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        author: 'Dinas Kesehatan',
        category: 'Kesehatan',
      ),
      NewsModel(
        idPost: 2,
        title: 'Pemberian Makanan Tambahan',
        description:
            'Program pemberian makanan tambahan (PMT) untuk balita stunting terus digencarkan.',
        imageUrl:
            'https://images.unsplash.com/photo-1490818387583-1baba5e638af?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=60',
        imageSmallUrl: '',
        imageMiddleUrl: '',
        url: 'pmt-stunting',
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
        author: 'Dinas Kesehatan',
        category: 'Program',
      ),
    ];

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
