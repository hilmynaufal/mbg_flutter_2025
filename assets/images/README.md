# Assets Images

Folder ini berisi gambar-gambar yang digunakan di aplikasi MBG Flutter 2025.

## Struktur Folder

### banners/
Berisi gambar untuk banner carousel di home page.
- Ukuran recommended: 800x400px (ratio 2:1)
- Format: PNG, JPG, atau WebP
- File yang dibutuhkan (opsional, saat ini menggunakan placeholder):
  - banner_1.png
  - banner_2.png
  - banner_3.png
  - banner_4.png

### news/
Berisi thumbnail/gambar untuk berita.
- Ukuran recommended: 400x250px (ratio 16:10)
- Format: PNG, JPG, atau WebP
- File naming: news_[id].[ext] (contoh: news_1.png, news_2.jpg)

## Catatan

Saat ini aplikasi menggunakan placeholder images dari `via.placeholder.com` untuk development:
- Banner: https://via.placeholder.com/800x400/[color]/FFFFFF?text=...
- News: https://via.placeholder.com/400x250/[color]/FFFFFF?text=...

Untuk production, replace placeholder URLs dengan local assets atau URLs dari API/CDN.

## Cara Mengganti dengan Local Assets

1. Tambahkan file gambar ke folder yang sesuai
2. Update URL di code:
   - Banner: `lib/app/modules/home/controllers/home_controller.dart` - method `_loadBanners()`
   - News: `lib/app/data/dummy/news_dummy_data.dart`

Contoh:
```dart
// Dari:
imageUrl: 'https://via.placeholder.com/800x400/...'

// Ke:
imageUrl: 'assets/images/banners/banner_1.png'
```

3. Run `flutter pub get` dan restart app
