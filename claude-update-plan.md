# Update Version 0.4.0-alpha: API Integration for Carousel & News

## Progress Tracking

- [ ] 1. Create/Update Data Models
- [ ] 2. Create API Provider
- [ ] 3. Update HomeController
- [ ] 4. Create News Detail Module
- [ ] 5. Update Routes
- [ ] 6. Update News Card Widget
- [ ] 7. Update Home View
- [ ] 8. Version & Documentation

---

## 1. Create/Update Data Models

### Create `lib/app/data/models/slide_model.dart`
- [ ] Create new file
- [ ] Map API response from `/api/site/12/slides`
- [ ] Fields needed:
  - `int id_slide`
  - `String name`
  - `String? description`
  - `String image_url`
  - `String? link`
  - `int status`
  - `DateTime created_at`
  - `int site_id`
- [ ] Implement `fromJson` factory
- [ ] Implement `toJson` method

### Update `lib/app/data/models/news_model.dart`
- [ ] Add new fields to match API:
  - `int id_post` (change id from String to int)
  - `String url` (slug for routing)
  - `String image_small_url`
  - `String image_middle_url`
  - `DateTime created_at`
  - `String? content` (HTML content)
  - `String? description_text` (plain text version)
- [ ] Update `fromJson` to parse API response structure
- [ ] Add helper to strip HTML tags from description
- [ ] Keep backward compatibility if needed

---

## 2. Create API Provider

### Create `lib/app/data/providers/content_provider.dart`
- [ ] Create new file
- [ ] Setup Dio with base URL: `https://api.bandungkab.go.id/api`
- [ ] Add logging interceptor
- [ ] Implement methods:
  - [ ] `Future<List<SlideModel>> getSlides()` - GET `/site/12/slides`
  - [ ] `Future<List<NewsModel>> getPosts({int? limit})` - GET `/site/12/posts`
  - [ ] `Future<NewsModel> getPostBySlug(String slug)` - GET `/site/12/post/{slug}`
- [ ] Add error handling (DioException, network errors)
- [ ] Parse `{"success": true, "message": "...", "data": [...]}`

---

## 3. Update HomeController

### Modify `lib/app/modules/home/controllers/home_controller.dart`
- [ ] Add ContentProvider injection: `final ContentProvider _contentProvider = Get.find<ContentProvider>();`
- [ ] Add loading states:
  - [ ] `RxBool isLoadingBanners = false.obs`
  - [ ] `RxBool isLoadingNews = false.obs`
- [ ] Update `_loadBanners()`:
  - [ ] Call `_contentProvider.getSlides()`
  - [ ] Convert `List<SlideModel>` to `List<BannerItem>`
  - [ ] Handle errors with try-catch
  - [ ] Show error message if failed
- [ ] Update `_loadLatestNews()`:
  - [ ] Call `_contentProvider.getPosts(limit: 3)`
  - [ ] Parse to `NewsModel` list
  - [ ] Handle errors with try-catch
- [ ] Remove dependency on `NewsDummyData`

---

## 4. Create News Detail Module

### Create `lib/app/modules/news_detail/controllers/news_detail_controller.dart`
- [ ] Create GetX controller
- [ ] Add properties:
  - [ ] `Rx<NewsModel?> newsDetail = Rx<NewsModel?>(null)`
  - [ ] `RxBool isLoading = false.obs`
  - [ ] `RxString errorMessage = ''.obs`
- [ ] Inject ContentProvider
- [ ] Implement `fetchNewsDetail(String slug)` method
- [ ] Handle loading states and errors

### Create `lib/app/modules/news_detail/views/news_detail_view.dart`
- [ ] Create StatelessWidget with GetView<NewsDetailController>
- [ ] Get slug from route arguments: `Get.arguments as String`
- [ ] Design layout:
  - [ ] AppBar with title
  - [ ] Hero image (full width)
  - [ ] Article title (large, bold)
  - [ ] Metadata (date, author, category)
  - [ ] HTML content rendering with `flutter_html` package
  - [ ] Loading indicator
  - [ ] Error message handling
- [ ] Add Obx for reactive updates

### Create `lib/app/modules/news_detail/bindings/news_detail_binding.dart`
- [ ] Create binding class
- [ ] Bind NewsDetailController
- [ ] Bind ContentProvider if not already global

---

## 5. Update Routes

### Modify `lib/app/routes/app_routes.dart`
- [ ] Add constant: `static const NEWS_DETAIL = '/news-detail';`

### Modify `lib/app/routes/app_pages.dart`
- [ ] Import NewsDetail module files
- [ ] Add GetPage for NEWS_DETAIL:
  ```dart
  GetPage(
    name: Routes.NEWS_DETAIL,
    page: () => const NewsDetailView(),
    binding: NewsDetailBinding(),
  )
  ```

---

## 6. Update News Card Widget

### Modify `lib/app/core/widgets/news_card_widget.dart`
- [ ] Add `VoidCallback? onTap` parameter to constructor
- [ ] Wrap card in GestureDetector/InkWell
- [ ] Call onTap when card is tapped
- [ ] Add visual feedback (splash effect)

---

## 7. Update Home View

### Modify `lib/app/modules/home/views/home_view.dart`
- [ ] Wrap carousel with Obx:
  - [ ] Show loading indicator when `controller.isLoadingBanners.value`
  - [ ] Show banners when loaded
  - [ ] Show error message if load failed
- [ ] Wrap news section with Obx:
  - [ ] Show loading indicator when `controller.isLoadingNews.value`
  - [ ] Show news cards when loaded
- [ ] Add onTap to news cards:
  ```dart
  onTap: () => Get.toNamed(Routes.NEWS_DETAIL, arguments: news.url)
  ```
- [ ] Update to use `news.image_small_url` for thumbnails

---

## 8. Version & Documentation

### Update `pubspec.yaml`
- [ ] Change version: `0.3.1-alpha+20251008` � `0.4.0-alpha+20251008`
- [ ] Add dependency: `flutter_html: ^3.0.0-beta.2`
- [ ] Run `flutter pub get`

### Update CHANGELOG.md
- [ ] Add section for v0.4.0-alpha
- [ ] Document features:
  - API integration for carousel (slides)
  - API integration for news/posts
  - News detail page with HTML rendering
  - Replace dummy data with live API data
- [ ] List endpoints used
- [ ] Technical changes

### Update CLAUDE.md
- [ ] Update current version to 0.4.0-alpha
- [ ] Add to project structure:
  - `slide_model.dart`
  - `content_provider.dart`
  - `news_detail/` module
- [ ] Update "Current Features" section:
  - Real-time carousel from API
  - Real-time news from API
  - News detail page
- [ ] Add API endpoints documentation

---

## Testing Checklist

- [ ] Test carousel loads from API
- [ ] Test carousel shows loading state
- [ ] Test carousel handles errors gracefully
- [ ] Test news list loads from API (limit 3)
- [ ] Test news card navigation to detail
- [ ] Test news detail page displays correctly
- [ ] Test HTML content renders properly
- [ ] Test back navigation from news detail
- [ ] Test app behavior when offline
- [ ] Test app behavior when API returns errors

---

## Commit & Release

- [ ] Test on real device/emulator
- [ ] Fix any bugs found
- [ ] Run `flutter analyze` - ensure no issues
- [ ] Commit changes with clear message
- [ ] Push to GitHub
- [ ] Create git tag: `v0.4.0-alpha+20251008`
- [ ] Verify GitHub Actions builds successfully
- [ ] Verify release is created with APK

---

## API Reference (from plan.md)

### Carousel/Slides API
**Endpoint:** `GET https://api.bandungkab.go.id/api/site/12/slides`

**Response:**
```json
{
  "success": true,
  "message": "Data ditemukan",
  "data": [
    {
      "id_slide": 36,
      "name": "Slide 2",
      "description": "Slide 2",
      "image": "frontend/slides/12/...",
      "link": null,
      "status": 1,
      "created_at": "2025-10-08T07:09:54.000000Z",
      "updated_at": "2025-10-08T07:09:54.000000Z",
      "site_id": 12,
      "image_url": "https://storageapi.bandungkab.go.id/..."
    }
  ]
}
```

### News/Posts List API
**Endpoint:** `GET https://api.bandungkab.go.id/api/site/12/posts`

**Response:**
```json
{
  "success": true,
  "message": "Data ditemukan",
  "data": [
    {
      "id_post": 314,
      "title": "...",
      "description": "...",
      "image": "...",
      "image_small": "...",
      "image_middle": "...",
      "url": "sukses-jalankan-program-mbg-kabupaten-bandung-jadi-percontohan",
      "tags": "...",
      "created_at": "2025-10-07T17:00:00.000000Z",
      "content": "<p>HTML content...</p>",
      "image_url": "https://...",
      "image_small_url": "https://...",
      "image_middle_url": "https://..."
    }
  ]
}
```

### News Detail API
**Endpoint:** `GET https://api.bandungkab.go.id/api/site/12/post/{slug}`

**Example:** `GET https://api.bandungkab.go.id/api/site/12/post/sukses-jalankan-program-mbg-kabupaten-bandung-jadi-percontohan`

**Response:** Same structure as posts list but returns single item in data array
