di @dynamic_opd_dashboard_view.dart kita membuat view berdasarkan data dari api @menu_opd_detail_model.dart , saya menambahkan field baru di api yaitu required_filter, field ini berfungsi untuk melihat data di @report_list_view.dart, dimana jika required_filter tidak kosong maka akan akan pergi ke halaman seperti @posyandu_edit_view.dart (buat saja view baru menyerupai @posyandu_edit_view.dart), yang terdapat filter kecamatan, desa dan no hp pelapor

nah saya mau kalau di required_filter tidak kosong, misalnya "no_hp_whatsapp_aktif", maka kita akan membuat filter untuk field itu, kita akan cocokan field dengan data api misal response nya
{
    "status": "success",
    "message": "Data retrieved successfully.",
    "pageTitle": "API Data Responses",
    "title": "Pelaporan Penerima MBG",
    "slug": "pelaporan-penerima-mbg",
    "description": "Laporan Pelaporan Penerima Program MBG: Makan Bergizi Gratis",
    "total": 2201,
    "data": [
        {
            "id": 73702,
            "status": null,
            "department_id": "Tamu",
            "department_nama": "Tamu",
            "asistant_nama": "Tamu",
            "created_by": "Tamu",
            "created_at": "2025-12-02 10:04:39",
            "updated_by": "Tamu",
            "updated_at": "2025-12-02 10:04:39",
            "detail": {
                "nama_sppg": "MARGAMUKTI",
                "nama_instansi__sekolah__unit__ponpes": "TK KERTA TERUNA",
                "tanggal_laporan": "2025-12-02",
                "nama_pelapor": "AI WISTRI",
                "no_hp_whatsapp_aktif": 82316316903,
                "jabatan": "GURU",
                "titik_lokasi_penerimaan": "-7.1905359121861885,107.60986619115656",
                "alamat_lengkap__lokasi_penerimaan": "KP. KERTAMANAH RT 01 RW 17",
                "jenis_laporan": "DITERIMA SESUAI - Paket makanan diterima lengkap, tepat waktu, menu sesuai, dan layak konsumsi",
                "keterangan_laporan": "aman",
                "kecamatan": "PANGALENGAN",
                "jumlah_paket_makanan_diterima": 55,
                "desa": "MARGAMUKTI",
                "jumlah_siswa_penerima": 55,
                "jenis_menu_yang_diterima": "nasi, chicken drum stik, jamur crispy, kacang polong, semangka",
                "variasi_menu": "Ya",
                "porsi_makanan": "Sesuai standar",
                "kebersihan__kelayakan_makanan": "Baik",
                "cita_rasa_makanan": "Baik",
                "dokumentasi_foto": "https://storageapi.bandungkab.go.id/dashboard-pimpinan/form-uploads/nhoh4QLibYgPi4rnkUshqhaWu4ywuT9qXcL74ppR.jpg?X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=I3baADsIJfGs0HkkjxBZ%2F20251210%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20251210T124131Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604800&X-Amz-Signature=9bc90748fbeba82ab6da92780d3d8eec274554636be5936e1ab8da048d06eb20",
                "kendala__usulan_perbaikan_terkait_makanan": "Alhamdulillah tidak ada kendala"
            }
        },
    ]
}

terlihat di response terdapat field no_hp_whatsapp_aktif, maka kita akan membuat filter untuk field itu, dimana user harus mengisi filter itu dulu secara lengkap, maka list data akan muncul

hal ini bertujuan untuk membatasi akses user sehingga mereka harus mengetahui isi dari field yang ada di required_filter terlebih dahulu untuk memunculkan data