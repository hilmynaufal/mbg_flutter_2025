# Plan Implementasi Aplikasi MBG - Pelaporan SPPG

## Ringkasan Proyek
Aplikasi mobile MBG untuk Pemerintah Kabupaten Bandung dengan fitur core pelaporan SPPG untuk para Satgas SPPG.

## Fitur Utama
1. Login menggunakan API endpoint
2. Form Pelaporan SPPG yang dinamis berdasarkan API

## Tech Stack
- **State Management**: GetX
- **HTTP Client**: Dio
- **Local Storage**: SharedPreferences
- **Maps**: Google Maps Flutter
- **UI**: Material Design dengan custom theme MBG

---

## 1. Setup Dependencies & Konfigurasi

### Dependencies yang ditambahkan:
- `get: ^4.6.6` - State management
- `dio: ^5.4.0` - HTTP client untuk API calls
- `shared_preferences: ^2.2.2` - Menyimpan token/session
- `google_maps_flutter: ^2.5.3` - Untuk field map/koordinat
- `intl: ^0.19.0` - Untuk date formatting
- `flutter_spinkit: ^5.2.0` - Loading indicator

---

## 2. Struktur Folder (GetX Pattern)

```
lib/
├── main.dart
├── app/
│   ├── data/
│   │   ├── models/
│   │   │   ├── user_model.dart
│   │   │   ├── form_field_model.dart
│   │   │   ├── form_response_model.dart
│   │   │   └── validation_rules_model.dart
│   │   ├── providers/
│   │   │   ├── auth_provider.dart
│   │   │   └── form_provider.dart
│   │   └── services/
│   │       ├── auth_service.dart
│   │       └── storage_service.dart
│   ├── modules/
│   │   ├── login/
│   │   │   ├── controllers/
│   │   │   │   └── login_controller.dart
│   │   │   ├── views/
│   │   │   │   └── login_view.dart
│   │   │   └── bindings/
│   │   │       └── login_binding.dart
│   │   ├── home/
│   │   │   ├── controllers/
│   │   │   │   └── home_controller.dart
│   │   │   ├── views/
│   │   │   │   └── home_view.dart
│   │   │   └── bindings/
│   │   │       └── home_binding.dart
│   │   └── form_sppg/
│   │       ├── controllers/
│   │       │   └── form_sppg_controller.dart
│   │       ├── views/
│   │       │   └── form_sppg_view.dart
│   │       └── bindings/
│   │           └── form_sppg_binding.dart
│   ├── routes/
│   │   ├── app_pages.dart
│   │   └── app_routes.dart
│   └── core/
│       ├── theme/
│       │   ├── app_theme.dart
│       │   ├── app_colors.dart
│       │   └── app_text_styles.dart
│       ├── values/
│       │   ├── constants.dart
│       │   └── strings.dart
│       └── widgets/
│           ├── custom_text_field.dart
│           ├── custom_number_field.dart
│           ├── custom_textarea.dart
│           ├── custom_dropdown.dart
│           ├── custom_date_picker.dart
│           ├── map_picker_widget.dart
│           └── dynamic_form_builder.dart
```

---

## 3. Implementasi Login

### API Endpoint
- **URL**: `https://sultan.bandungkab.go.id/api/Login`
- **Method**: POST
- **Body**:
  ```json
  {
    "username": "198704042019032004",
    "password": "081312229386"
  }
  ```
- **Response**:
  ```json
  {
    "code": 200,
    "dataUsers": [
      {
        "id": 14216,
        "username": "198704042019032004",
        "nm_lengkap": "NOVITA NOVIANA PRIATNA S.I.Kom",
        "nip": "198704042019032004",
        "email": "novitanpriatna@yahoo.com",
        "jabatan": "PENELAAH TEKNIS KEBIJAKAN",
        "skpdnama": "SEKRETARIAT DAERAH"
      }
    ]
  }
  ```

### Langkah-langkah:
1. **Buat UserModel** (`lib/app/data/models/user_model.dart`)
   - Parse response dari API
   - Method `fromJson()` dan `toJson()`

2. **Buat AuthProvider** (`lib/app/data/providers/auth_provider.dart`)
   - Setup Dio instance
   - Method `login(username, password)` untuk hit API

3. **Buat AuthService** (`lib/app/data/services/auth_service.dart`)
   - Manage session dengan SharedPreferences
   - Save/get/delete user data dan token
   - Method `isLoggedIn()`, `getUser()`, `logout()`

4. **Buat StorageService** (`lib/app/data/services/storage_service.dart`)
   - Wrapper untuk SharedPreferences
   - Init pada app startup

5. **Buat LoginController** (`lib/app/modules/login/controllers/login_controller.dart`)
   - TextEditingController untuk username & password
   - Reactive variables untuk loading state
   - Method `login()` dengan validasi
   - Error handling

6. **Buat LoginView** (`lib/app/modules/login/views/login_view.dart`)
   - TextField untuk username dan password
   - Button login dengan loading indicator
   - Error message display
   - UI sesuai theme MBG

7. **Buat LoginBinding** (`lib/app/modules/login/bindings/login_binding.dart`)
   - Dependency injection untuk LoginController

---

## 4. Implementasi Theme MBG

### Warna Tema (perkiraan branding Kabupaten Bandung):
- **Primary Color**: Hijau (#2E7D32 atau sesuai branding)
- **Secondary Color**: Biru/Orange
- **Background**: White/Light grey
- **Text**: Dark grey/Black

### File yang dibuat:
1. **app_colors.dart** - Definisi semua warna
2. **app_text_styles.dart** - Text styles (heading, body, caption)
3. **app_theme.dart** - ThemeData untuk MaterialApp

### Implementasi di main.dart:
```dart
MaterialApp(
  theme: AppTheme.lightTheme,
  ...
)
```

---

## 5. Implementasi Routing dengan GetX

### Routes (lib/app/routes/app_routes.dart):
```dart
class Routes {
  static const LOGIN = '/login';
  static const HOME = '/home';
  static const FORM_SPPG = '/form-sppg';
}
```

### Pages (lib/app/routes/app_pages.dart):
```dart
class AppPages {
  static final routes = [
    GetPage(
      name: Routes.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.FORM_SPPG,
      page: () => FormSppgView(),
      binding: FormSppgBinding(),
    ),
  ];
}
```

---

## 6. Implementasi Menu Utama/Home

### Fitur:
- Tampilkan info user yang login (nama, jabatan, SKPD)
- Card/Button menu "Pelaporan SPPG"
- Logout button
- AppBar dengan logo/title MBG

### Controller:
- Get user data dari AuthService
- Method logout()

---

## 7. Implementasi Dynamic Form Builder

### API Endpoint
- **URL**: `https://api.bandungkab.go.id/api/form/format/lapor-phk`
- **Method**: GET

### Response Structure:
```json
{
  "pageTitle": "API Form Builder",
  "module": "Ref Disnaker PHK",
  "title": "Lapor PHK",
  "description": "Layanan Lapor Pemutusan Hubungan Kerja (PHK)",
  "slug": "lapor-phk",
  "total_questions": 11,
  "data": [
    {
      "id": 659,
      "question_text": "NIK",
      "question_type": "number",
      "question_description": "Nomor Induk Kependudukan",
      "question_placeholder": "320437260394XXXXX",
      "validation_rules": {
        "required": 1,
        "min_length": 16,
        "max_length": 16
      },
      "options": null
    }
  ]
}
```

### Question Types:
1. **text** - TextField biasa
2. **number** - TextField dengan keyboard numeric
3. **textarea** - TextField multiline
4. **dropdown** - DropdownButton dengan options dari API
5. **date** - DatePicker
6. **map** - Google Maps picker untuk koordinat

### Langkah-langkah:

1. **Buat Models**:
   - `FormResponseModel` - Untuk response utama
   - `FormFieldModel` - Untuk setiap field
   - `ValidationRulesModel` - Untuk validation rules

2. **Buat FormProvider** (`lib/app/data/providers/form_provider.dart`)
   - Method `getFormStructure(slug)` untuk fetch form dari API

3. **Buat Widget Components**:
   - `CustomTextField` - Untuk type text
   - `CustomNumberField` - Untuk type number
   - `CustomTextArea` - Untuk type textarea
   - `CustomDropdown` - Untuk type dropdown
   - `CustomDatePicker` - Untuk type date
   - `MapPickerWidget` - Untuk type map (Google Maps)

4. **Buat DynamicFormBuilder Widget**:
   - Terima list FormFieldModel
   - Loop dan render widget sesuai question_type
   - Handle validation untuk setiap field
   - Return Map<String, dynamic> berisi semua answers

5. **Implementasi Validation**:
   - `required`: Field wajib diisi
   - `min_length` & `max_length`: Validasi panjang karakter
   - `min_value` & `max_value`: Validasi nilai numerik
   - `regex_pattern`: Validasi dengan regex (jika ada)

---

## 8. Implementasi Form SPPG Page

### FormSppgController:
- Fetch form structure dari API saat init
- Manage form state (loading, error, success)
- Map untuk menyimpan answers
- Method `submitForm()` untuk submit data
- Validasi semua field sebelum submit

### FormSppgView:
- AppBar dengan title dari API response
- Description text
- DynamicFormBuilder dengan scroll
- Submit button
- Loading overlay saat submit

---

## 9. Implementasi Submission Form

### Endpoint API Submit Form
- **URL**: `{{baseUrl}}/api/form/create/pelaporan-tugas-satgas-mbg`
- **Method**: POST (multipart/form-data)
- **Body Format**:
  ```json
  {
    "uri": "https://api.bandungkab.go.id/api/form/create/pelaporan-tugas-satgas-mbg",
    "answers[789]": "Nilai jawaban"
  }
  ```
  - `uri`: Full URL endpoint
  - `answers[{id}]`: Format untuk setiap jawaban (id = field id dari API)

### Implementasi:
- FormProvider.submitForm() - Handle multipart/form-data untuk upload image
- FormSppgController - Format data dengan "uri" dan "answers[id]"
- Handle berbagai tipe data:
  - DateTime → yyyy-MM-dd format
  - Map coordinates → "lat,lng" format
  - File → MultipartFile untuk image upload
  - String/Number → toString()

---

## 10. Testing & Polish

### Checklist Testing:
- [ ] Login flow (success, error, validation)
- [ ] Session management (auto login jika sudah login)
- [ ] Home page navigation
- [ ] Form loading dari API
- [ ] Setiap question type render dengan benar
- [ ] Validation rules berfungsi (required, min/max length/value)
- [ ] Map picker berfungsi
- [ ] Date picker berfungsi
- [ ] Dropdown options
- [ ] Form submission (setelah endpoint tersedia)
- [ ] Logout functionality
- [ ] Error handling (no internet, API error, timeout)
- [ ] Loading states di semua page
- [ ] UI responsive di berbagai ukuran layar

### UI/UX Polish:
- Spacing dan padding konsisten
- Color scheme sesuai tema MBG
- Smooth transitions
- User feedback (snackbar, dialog)
- Input focus management
- Keyboard handling

---

## Catatan Penting

1. **State Management**: Semua menggunakan GetX (GetxController, Obx, Get.to, Get.find)
2. **Theme**: Maksimalkan penggunaan ThemeData di MaterialApp
3. **UI**: Simple tapi menarik, konsisten dengan Material Design
4. **Code Quality**:
   - Separation of concerns (provider, service, controller terpisah)
   - Reusable widgets
   - Proper error handling
   - Comments untuk code yang kompleks

---

## Progress Tracking

### ✅ Completed Steps
1. ✅ **Setup dependencies** - Dependencies ditambahkan ke pubspec.yaml
2. ✅ **Struktur folder** - Folder structure sesuai GetX pattern sudah dibuat
3. ✅ **Models** - Semua models dibuat (UserModel, FormFieldModel, FormResponseModel, ValidationRulesModel, LoginResponseModel, KecamatanModel, DesaModel)
4. ✅ **Theme setup** - Theme MBG (app_colors.dart, app_text_styles.dart, app_theme.dart) dan sudah diintegrasikan ke main.dart
5. ✅ **Routing** - Setup GetX routing (app_routes.dart, app_pages.dart) dengan placeholder views/controllers/bindings untuk login, home, dan form_sppg
6. ✅ **Auth Services** - StorageService, AuthProvider (dengan Dio), AuthService, dan constants.dart sudah dibuat dan diinisialisasi di main.dart
7. ✅ **Login page** - LoginController (dengan validasi, loading state, error handling), LoginView (UI lengkap dengan theme MBG), LoginBinding sudah siap
8. ✅ **Home page** - HomeController (load user data, logout dengan konfirmasi, navigasi ke form), HomeView (user info card, menu card pelaporan SPPG, logout button), HomeBinding sudah siap
9. ✅ **Form Provider** - FormProvider dengan method getFormStructure(slug) dan submitForm() yang sudah terintegrasi dengan endpoint API
10. ✅ **Dynamic form widgets** - Custom widgets untuk semua question types (text, number, textarea, dropdown, date, map, image) dengan validation
11. ✅ **Form SPPG page** - FormSppgController (fetch form, validation, submit dengan konfirmasi), FormSppgView (dynamic form builder, loading/error states), DynamicFormBuilder widget
12. ✅ **Image picker widget** - CustomImagePicker untuk upload foto dari kamera/galeri dengan preview dan validasi
13. ✅ **Submit form implementation** - Endpoint POST /form/create/{slug} dengan format body "uri" dan "answers[id]", support multipart/form-data untuk image upload
14. ✅ **Regional data hardcoding** - Hardcode 31 Kecamatan dan 280 Desa Kabupaten Bandung dengan dependent dropdown support
15. ✅ **Format data revisi** - Kecamatan/Desa simpan NAMA (uppercase), koordinat format "lat,lng", tanggal format "yyyy-MM-dd"

### ⏳ In Progress
- Tidak ada

### ☐ Pending Steps
16. ☐ **Testing & polish** - Testing semua fitur dan polish UI/UX

### 📝 Catatan Implementation
- Map picker menggunakan dialog input manual (TODO: integrasi Google Maps)
- Form validation sudah lengkap sesuai validation rules dari API
- Form slug: "pelaporan-tugas-satgas-mbg"
- Image picker mendukung kamera & galeri dengan preview dan optimasi (max 1920x1080, quality 85%)
- Submit form menggunakan multipart/form-data dengan format:
  - uri: Full API endpoint URL
  - answers[{id}]: Value untuk setiap field (support string, number, date, coordinates, image file)
- **Kecamatan & Desa data di-hardcode** dalam aplikasi:
  - 31 Kecamatan di Kabupaten Bandung
  - 280 Desa/Kelurahan
  - Dropdown otomatis menggunakan data hardcode jika field mengandung kata "kecamatan", "desa", atau "kelurahan"
  - **Menyimpan NAMA (uppercase), bukan ID** - contoh: "GANDASARI"
  - Dependent dropdown: Desa di-filter berdasarkan Kecamatan yang dipilih
  - Auto-clear desa selection saat kecamatan berubah
- **Format data submit**:
  - Tanggal: `yyyy-MM-dd` (contoh: "2025-10-06")
  - Koordinat: `lat,lng` tanpa spasi (contoh: "-7.0116659953509,107.53113714048")
  - Kecamatan/Desa: Nama dalam uppercase (contoh: "GANDASARI")

---

## Timeline Estimasi

1. ✅ Setup dependencies - 5 menit
2. ✅ Struktur folder - 10 menit
3. ✅ Models - 30 menit
4. ✅ Theme setup - 20 menit
5. ✅ Routing - 15 menit
6. ✅ Auth (Provider, Service) - 45 menit
7. ✅ Login page - 45 menit
8. ✅ Home page - 30 menit
9. ✅ Form Provider - 20 menit
10. ✅ Dynamic form widgets - 2 jam
11. ✅ Form validation (terintegrasi di widgets) - included
12. ✅ Form SPPG page - 1 jam
13. ✅ Image picker implementation - 30 menit
14. ✅ Submit form implementation - 30 menit
15. ✅ Regional data (Kecamatan & Desa) hardcoding - 30 menit
16. ✅ Format data revisi (nama Kecamatan/Desa, koordinat, tanggal) - 15 menit
17. ☐ Testing & polish - 1 jam

**Total**: ~9.75 jam
**Completed**: ~8 jam 25 menit
**Remaining**: ~1 jam (Testing & polish)
