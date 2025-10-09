import '../models/news_model.dart';

class NewsDummyData {
  static List<NewsModel> getNewsData() {
    return [
      NewsModel(
        idPost: 1,
        title: 'Sosialisasi Pelaporan SPPG di Kabupaten Bandung',
        description: 'Pemerintah Kabupaten Bandung mengadakan sosialisasi sistem pelaporan SPPG untuk meningkatkan perlindungan pekerja.',
        imageUrl: 'https://via.placeholder.com/400x250/14B8A6/FFFFFF?text=Sosialisasi+SPPG',
        imageSmallUrl: 'https://via.placeholder.com/200x125/14B8A6/FFFFFF?text=Sosialisasi+SPPG',
        imageMiddleUrl: 'https://via.placeholder.com/300x188/14B8A6/FFFFFF?text=Sosialisasi+SPPG',
        url: 'sosialisasi-pelaporan-sppg-di-kabupaten-bandung',
        category: 'Ketenagakerjaan',
        createdAt: DateTime(2025, 10, 5),
        author: 'Dinas Tenaga Kerja Kab. Bandung',
        content: 'Pemerintah Kabupaten Bandung mengadakan sosialisasi sistem pelaporan SPPG untuk meningkatkan perlindungan pekerja di wilayah Kabupaten Bandung.',
      ),
      NewsModel(
        idPost: 2,
        title: 'Pentingnya Pelaporan PHK Sesuai Regulasi',
        description: 'Perusahaan wajib melaporkan setiap kasus PHK sesuai dengan regulasi ketenagakerjaan yang berlaku.',
        imageUrl: 'https://via.placeholder.com/400x250/2196F3/FFFFFF?text=Regulasi+PHK',
        imageSmallUrl: 'https://via.placeholder.com/200x125/2196F3/FFFFFF?text=Regulasi+PHK',
        imageMiddleUrl: 'https://via.placeholder.com/300x188/2196F3/FFFFFF?text=Regulasi+PHK',
        url: 'pentingnya-pelaporan-phk-sesuai-regulasi',
        category: 'Regulasi',
        createdAt: DateTime(2025, 10, 3),
        author: 'Tim Hukum Ketenagakerjaan',
        content: 'Setiap perusahaan wajib melaporkan kasus pemutusan hubungan kerja (PHK) sesuai dengan regulasi yang berlaku untuk melindungi hak-hak pekerja.',
      ),
      NewsModel(
        idPost: 3,
        title: 'Update Aplikasi Pelaporan SPPG Versi 0.2.0',
        description: 'Aplikasi pelaporan SPPG kini hadir dengan tampilan baru yang lebih user-friendly dan fitur berita terkini.',
        imageUrl: 'https://via.placeholder.com/400x250/4CAF50/FFFFFF?text=Update+Aplikasi',
        imageSmallUrl: 'https://via.placeholder.com/200x125/4CAF50/FFFFFF?text=Update+Aplikasi',
        imageMiddleUrl: 'https://via.placeholder.com/300x188/4CAF50/FFFFFF?text=Update+Aplikasi',
        url: 'update-aplikasi-pelaporan-sppg-versi-020',
        category: 'Teknologi',
        createdAt: DateTime(2025, 10, 1),
        author: 'Tim Pengembang MBG',
        content: 'Versi terbaru aplikasi pelaporan SPPG menghadirkan antarmuka yang lebih modern dan mudah digunakan serta fitur berita untuk informasi terkini.',
      ),
      NewsModel(
        idPost: 4,
        title: 'Perlindungan Hak Pekerja di Era Digital',
        description: 'Digitalisasi sistem pelaporan memudahkan pekerja untuk melaporkan pelanggaran hak-hak ketenagakerjaan.',
        imageUrl: 'https://via.placeholder.com/400x250/FF9800/FFFFFF?text=Hak+Pekerja',
        imageSmallUrl: 'https://via.placeholder.com/200x125/FF9800/FFFFFF?text=Hak+Pekerja',
        imageMiddleUrl: 'https://via.placeholder.com/300x188/FF9800/FFFFFF?text=Hak+Pekerja',
        url: 'perlindungan-hak-pekerja-di-era-digital',
        category: 'Ketenagakerjaan',
        createdAt: DateTime(2025, 9, 28),
        author: 'Dinas Tenaga Kerja',
        content: 'Sistem digital mempermudah pekerja dalam melaporkan pelanggaran dan mendapatkan perlindungan hukum yang lebih cepat dan efisien.',
      ),
      NewsModel(
        idPost: 5,
        title: 'Workshop Tata Cara Pelaporan SPPG untuk Perusahaan',
        description: 'Workshop khusus bagi HRD perusahaan untuk memahami prosedur pelaporan SPPG yang benar.',
        imageUrl: 'https://via.placeholder.com/400x250/9C27B0/FFFFFF?text=Workshop+HRD',
        imageSmallUrl: 'https://via.placeholder.com/200x125/9C27B0/FFFFFF?text=Workshop+HRD',
        imageMiddleUrl: 'https://via.placeholder.com/300x188/9C27B0/FFFFFF?text=Workshop+HRD',
        url: 'workshop-tata-cara-pelaporan-sppg-untuk-perusahaan',
        category: 'Pelatihan',
        createdAt: DateTime(2025, 9, 25),
        author: 'Dinas Tenaga Kerja Kab. Bandung',
        content: 'Workshop ini bertujuan memberikan pemahaman kepada HRD perusahaan tentang tata cara dan prosedur pelaporan SPPG yang sesuai regulasi.',
      ),
      NewsModel(
        idPost: 6,
        title: 'Statistik Pelaporan SPPG Triwulan III 2025',
        description: 'Jumlah pelaporan SPPG di Kabupaten Bandung mengalami penurunan pada triwulan III 2025.',
        imageUrl: 'https://via.placeholder.com/400x250/F44336/FFFFFF?text=Statistik+Q3',
        imageSmallUrl: 'https://via.placeholder.com/200x125/F44336/FFFFFF?text=Statistik+Q3',
        imageMiddleUrl: 'https://via.placeholder.com/300x188/F44336/FFFFFF?text=Statistik+Q3',
        url: 'statistik-pelaporan-sppg-triwulan-iii-2025',
        category: 'Data',
        createdAt: DateTime(2025, 9, 20),
        author: 'Bidang Data dan Informasi',
        content: 'Penurunan jumlah pelaporan SPPG menunjukkan adanya peningkatan kepatuhan perusahaan terhadap regulasi ketenagakerjaan.',
      ),
      NewsModel(
        idPost: 7,
        title: 'Layanan Konsultasi Ketenagakerjaan Gratis',
        description: 'Pemerintah menyediakan layanan konsultasi gratis bagi pekerja yang mengalami masalah ketenagakerjaan.',
        imageUrl: 'https://via.placeholder.com/400x250/00BCD4/FFFFFF?text=Konsultasi+Gratis',
        imageSmallUrl: 'https://via.placeholder.com/200x125/00BCD4/FFFFFF?text=Konsultasi+Gratis',
        imageMiddleUrl: 'https://via.placeholder.com/300x188/00BCD4/FFFFFF?text=Konsultasi+Gratis',
        url: 'layanan-konsultasi-ketenagakerjaan-gratis',
        category: 'Layanan',
        createdAt: DateTime(2025, 9, 15),
        author: 'Dinas Tenaga Kerja',
        content: 'Layanan konsultasi gratis tersedia setiap hari kerja untuk membantu pekerja menyelesaikan permasalahan ketenagakerjaan.',
      ),
      NewsModel(
        idPost: 8,
        title: 'Kerjasama Pengawasan Ketenagakerjaan dengan Kepolisian',
        description: 'Dinas Tenaga Kerja menjalin kerjasama dengan kepolisian untuk meningkatkan pengawasan ketenagakerjaan.',
        imageUrl: 'https://via.placeholder.com/400x250/795548/FFFFFF?text=Kerjasama',
        imageSmallUrl: 'https://via.placeholder.com/200x125/795548/FFFFFF?text=Kerjasama',
        imageMiddleUrl: 'https://via.placeholder.com/300x188/795548/FFFFFF?text=Kerjasama',
        url: 'kerjasama-pengawasan-ketenagakerjaan-dengan-kepolisian',
        category: 'Pengawasan',
        createdAt: DateTime(2025, 9, 10),
        author: 'Humas Disnaker',
        content: 'Kerjasama ini bertujuan untuk meningkatkan efektivitas pengawasan dan penegakan hukum di bidang ketenagakerjaan.',
      ),
    ];
  }

  static List<NewsModel> getLatestNews({int limit = 3}) {
    final allNews = getNewsData();
    allNews.sort((a, b) => b.publishedDate.compareTo(a.publishedDate));
    return allNews.take(limit).toList();
  }

  static NewsModel? getNewsById(String id) {
    try {
      return getNewsData().firstWhere((news) => news.id == id);
    } catch (e) {
      return null;
    }
  }

  static List<NewsModel> getNewsByCategory(String category) {
    return getNewsData().where((news) => news.category == category).toList();
  }
}
