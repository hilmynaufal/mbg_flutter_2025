import 'package:get/get.dart';
import '../../../data/models/news_model.dart';
import '../../../data/providers/content_provider.dart';

class NewsDetailController extends GetxController {
  final ContentProvider _contentProvider = Get.find<ContentProvider>();

  // Observable properties
  Rx<NewsModel?> newsDetail = Rx<NewsModel?>(null);
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Get slug from route arguments
    final String? slug = Get.arguments as String?;
    if (slug != null && slug.isNotEmpty) {
      fetchNewsDetail(slug);
    } else {
      errorMessage.value = 'Slug berita tidak ditemukan';
    }
  }

  /// Fetch news detail by slug
  Future<void> fetchNewsDetail(String slug) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final news = await _contentProvider.getPostBySlug(slug);
      newsDetail.value = news;
    } catch (e) {
      print('Error fetching news detail: $e');
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  /// Retry loading news
  Future<void> retry() async {
    final String? slug = Get.arguments as String?;
    if (slug != null && slug.isNotEmpty) {
      await fetchNewsDetail(slug);
    }
  }
}
