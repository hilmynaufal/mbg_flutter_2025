# Version Update 0.2.1-alpha+{{ build number tanggal sekarang }}

Perubahan di versi ini:

# 1. Perubahan struktur module form_sppg

Untuk saat ini form_sppg hanya digunakan oleh form sppg (pelaporan-tugas-satgas-mbg), saya ingin membuat module ini dinamis karena akan ada beberapa form yang mempunyai struktur yang sama, ganti module ini menjadi lebih dinamis, misal di tombol nya kita memasukan paramter slug nya agar form akan sesuai dengan slug nya

# 2. Penambahan menu untuk form Pelaporan Tugas Satgas MBG - Dinkes - Laporan IKL
Saya ingin menambahkan menu ini, yang struktur nya sama dengan form pelaporan-tugas-satgas-mbg, gunakan slug pelaporan-tugas-satgas-mbg---dinkes---laporan-ikl (jika module form sudah di jadikan dinamis, ini tinggal kita tamahkan saja tombol nya di menu utama)

# 3. Pembuatan Widget custom untuk Snackbar
kita akan membuat widget custom untuk snackbar, contoh isi widget nya:
Get.showSnackbar(
                            GetSnackBar(
                              title: 'Banner',
                              message: banner.title ?? 'Banner tapped',
                              backgroundColor: Get.theme.colorScheme.primary,
                              snackPosition: SnackPosition.BOTTOM,
                              duration: const Duration(seconds: 3),
                            ),
                          );
Gunakan widget custom tersebut untuk digunakan di semua widget, icon, warna dan property lain bisa menyesuaikan, bisa juga dibuat khusus untuk error, success dan warning

