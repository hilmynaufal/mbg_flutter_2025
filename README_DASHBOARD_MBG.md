# Dashboard Pelaporan Penerima MBG

Dashboard web interaktif untuk memvisualisasikan data laporan penerimaan Makan Bergizi Gratis (MBG) di Kabupaten Bandung.

## 📋 Deskripsi

Dashboard ini dibuat untuk menampilkan dan menganalisis data pelaporan penerima MBG dari berbagai instansi/sekolah di Kabupaten Bandung. Data diambil secara real-time dari API Kabupaten Bandung.

## 🚀 Fitur Utama

### 1. Statistik Dashboard
- **Total Laporan**: Jumlah total laporan yang masuk
- **Total Paket Makanan**: Jumlah paket makanan yang didistribusikan
- **Total Siswa Penerima**: Jumlah siswa yang menerima MBG
- **Jumlah Kecamatan**: Coverage area penyaluran
- **Jumlah Instansi**: Jumlah sekolah/instansi penerima

### 2. Peta Interaktif
- Visualisasi lokasi penerimaan MBG menggunakan Leaflet Maps
- Marker untuk setiap lokasi penerimaan
- Layer GeoJSON untuk batas Kecamatan dan Desa
- Popup dengan informasi detail dan foto dokumentasi
- Kontrol layer untuk menampilkan/menyembunyikan overlay

### 3. Kartu Laporan
Setiap laporan ditampilkan dalam kartu yang berisi:
- **Informasi Instansi**: Nama sekolah/ponpes/unit
- **Status Laporan**: Badge dengan kategori (Sesuai/Tidak Sesuai/Tidak Diterima)
- **SPPG Pengirim**: Nama SPPG yang mengirimkan makanan
- **Data Penerimaan**:
  - Jumlah paket makanan diterima
  - Jumlah siswa penerima
  - Tanggal laporan
- **Detail Menu**: Jenis menu yang diterima
- **Penilaian Makanan**:
  - Variasi menu
  - Porsi makanan
  - Kebersihan/kelayakan
  - Cita rasa
- **Dokumentasi Foto**: Foto bukti penerimaan (dengan zoom preview)
- **Informasi Pelapor**: Nama, jabatan, dan kontak
- **Keterangan & Kendala**: Detail laporan dan usulan perbaikan

### 4. Filter & Pencarian
- **Search Box**: Cari berdasarkan nama instansi, SPPG, pelapor, kecamatan, atau desa
- **Filter Kecamatan**: Filter laporan berdasarkan kecamatan
- **Filter Jenis Laporan**: Filter berdasarkan status (Sesuai/Tidak Sesuai/Tidak Diterima)

### 5. Rekap Per Kecamatan
Tabel summary yang menampilkan:
- Total laporan per kecamatan
- Total paket makanan per kecamatan
- Total siswa penerima per kecamatan
- Total instansi per kecamatan

### 6. Notifikasi Laporan Terbaru
- Dropdown dengan 5 laporan terbaru
- Quick navigation ke kartu laporan
- Timestamp pembuatan laporan

### 7. Image Viewer Modal
- Full-screen image preview
- Zoom in/out controls
- Pan (drag) untuk navigasi gambar yang di-zoom
- Mouse wheel untuk zoom

## 🔧 Teknologi yang Digunakan

- **HTML5**: Struktur halaman
- **Tailwind CSS**: Styling dan responsiveness
- **JavaScript (Vanilla)**: Logic dan interaksi
- **Leaflet.js**: Peta interaktif dengan OpenStreetMap
- **Lucide Icons**: Icon library
- **Google Fonts**: Plus Jakarta Sans

## 📡 API Endpoint

```
Base URL: https://aplikasi.bandungkab.go.id/api
Endpoint: /data/pelaporan-penerima-mbg
Method: GET
```

### Struktur Response
```json
{
  "status": "success",
  "message": "Data retrieved successfully.",
  "pageTitle": "API Data Responses",
  "title": "Pelaporan Penerima MBG",
  "slug": "pelaporan-penerima-mbg",
  "description": "Laporan Pelaporan Penerima Program MBG: Makan Bergizi Gratis",
  "total": 833,
  "data": [...]
}
```

## 📊 Field Data yang Digunakan

Dari `item.detail`:
- `nama_instansi__sekolah__unit__ponpes` - Nama instansi penerima
- `nama_sppg` - Nama SPPG pengirim
- `tanggal_laporan` - Tanggal laporan dibuat
- `nama_pelapor` - Nama pelapor
- `no_hp_whatsapp_aktif` - Nomor kontak
- `jabatan` - Jabatan pelapor
- `titik_lokasi_penerimaan` - Koordinat lokasi (lat,lng)
- `alamat_lengkap__lokasi_penerimaan` - Alamat lengkap
- `jenis_laporan` - Kategori laporan
- `keterangan_laporan` - Keterangan detail
- `kecamatan` - Kecamatan
- `desa` - Desa
- `jumlah_paket_makanan_diterima` - Jumlah paket
- `jumlah_siswa_penerima` - Jumlah siswa
- `jenis_menu_yang_diterima` - Menu makanan
- `variasi_menu` - Penilaian variasi (Ya/Tidak)
- `porsi_makanan` - Penilaian porsi
- `kebersihan__kelayakan_makanan` - Penilaian kebersihan
- `cita_rasa_makanan` - Penilaian cita rasa
- `dokumentasi_foto` - URL foto dokumentasi
- `kendala__usulan_perbaikan_terkait_makanan` - Kendala dan usulan

## 🎨 Kategori Jenis Laporan

Dashboard menggunakan color-coding untuk jenis laporan:

| Jenis Laporan | Badge Color | Keterangan |
|--------------|-------------|------------|
| **DITERIMA SESUAI** | Hijau | Paket diterima lengkap dan sesuai |
| **DITERIMA TIDAK SESUAI** | Kuning | Paket diterima tapi ada ketidaksesuaian |
| **TIDAK DITERIMA** | Merah | Paket tidak diterima |

## 🗺️ GeoJSON Layers

Dashboard memuat 2 layer GeoJSON untuk overlay peta:

1. **Batas Kecamatan** (warna oranye)
   - Source: GitHub Gist
   - Weight: 2px
   - Opacity: 0.8

2. **Batas Desa** (warna hijau)
   - Source: GitHub Gist
   - Weight: 1px
   - Opacity: 0.7

Layer dapat di-toggle on/off melalui Layer Control di pojok kanan atas peta.

## 📱 Responsiveness

Dashboard fully responsive dengan breakpoints:
- **Mobile**: 1 kolom layout
- **Tablet (sm)**: 2 kolom stat cards
- **Desktop (lg)**: 5 kolom stat cards, 3 kolom layout untuk map + reports

## 🚀 Cara Menggunakan

1. **Buka file** `dashboard_pelaporan_mbg.html` di web browser modern (Chrome, Firefox, Edge, Safari)

2. **Dashboard akan otomatis**:
   - Memuat data dari API
   - Menampilkan statistik
   - Merender peta dan marker
   - Menampilkan kartu laporan
   - Membuat tabel rekap

3. **Gunakan filter** untuk mempersempit hasil:
   - Ketik keyword di search box
   - Pilih kecamatan dari dropdown
   - Pilih jenis laporan dari dropdown

4. **Interaksi dengan peta**:
   - Klik marker untuk melihat popup
   - Klik "Lihat Detail Lengkap" untuk scroll ke kartu
   - Gunakan Layer Control untuk toggle overlay

5. **Lihat detail laporan**:
   - Klik foto untuk zoom preview
   - Klik tombol expand untuk melihat detail penilaian/kendala
   - Klik "Lihat di Peta" untuk membuka Google Maps

## 🔍 Fitur Pencarian

Pencarian mendukung keyword dari field:
- Nama instansi/sekolah
- Nama SPPG
- Nama pelapor
- Kecamatan
- Desa

Search bersifat **case-insensitive** dan **real-time**.

## 🎯 Use Cases

Dashboard ini cocok untuk:
- **Monitoring**: Memantau distribusi MBG secara real-time
- **Evaluasi**: Menilai kualitas penyaluran MBG per wilayah
- **Pelaporan**: Membuat laporan rekap per kecamatan
- **Analisis**: Mengidentifikasi kendala dan pola distribusi
- **Transparansi**: Memberikan akses publik ke data penyaluran MBG

## 📝 Notes

- Dashboard menggunakan **loading placeholders** saat fetch data
- Error handling untuk **API failure** dan **image loading errors**
- **Animations** untuk smooth user experience (fade-in, transitions)
- **Image modal** dengan zoom/pan untuk dokumentasi foto
- **Auto-refresh date** di header
- **Notification badge** menampilkan jumlah laporan terbaru (fixed 5)

## 🔐 Keamanan & Performa

- Data diambil via HTTPS
- Tidak ada data disimpan di localStorage (privacy)
- Image lazy loading dengan error fallback
- Efficient filtering menggunakan Array methods
- GeoJSON loaded asynchronously untuk performa

## 🛠️ Pengembangan Lanjutan

Fitur yang bisa ditambahkan:
- Export data ke Excel/PDF
- Print-friendly view
- Date range filter
- Chart visualizations (pie, bar, line)
- Dark mode toggle
- Save filter preferences
- Real-time auto-refresh
- Multi-language support

## 📧 Kontak

Dashboard ini dibuat untuk **Satgas MBG Kabupaten Bandung**.

---

**Version**: 1.0.0
**Last Updated**: November 2025
**Created with**: Claude Code
