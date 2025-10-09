# Update Version 0.5.0-alpha+{{ build number }}

beberapa penambahan & perbaikan pada versi ini

1. Pengambilan data laporan yang sudah masuk, gunakan Endpoint Berikut:
{{baseUrl}}/api/data/pelaporan-tugas-satgas-mbg 
dan
{{baseUrl}}/api/data/pelaporan-tugas-satgas-mbg---dinkes---laporan-ikl

Buat dua menu nya di home dan gunakan endpoint tersebut untuk get daftar laporan yang sudah di submit

contoh response:

{
    "status": "success",
    "message": "Data retrieved successfully.",
    "pageTitle": "API Data Responses",
    "title": "Pelaporan Tugas Satgas MBG - Dinkes - Laporan IKL",
    "slug": "pelaporan-tugas-satgas-mbg---dinkes---laporan-ikl",
    "description": "Formulir ini digunakan untuk melaporkan tugas Satuan Tugas Makanan dan Bahan Berbahaya (Satgas MBG) dari Dinas Kesehatan. Pastikan Anda mengisi data dengan lengkap dan akurat sesuai dengan hasil inspeksi di lapangan.",
    "total": 4,
    "data": [
        {
            "id": 34843,
            "department_id": "Tamu",
            "department_nama": "Tamu",
            "asistant_nama": "Tamu",
            "created_by": "Tamu",
            "created_at": "2025-10-09 10:54:35",
            "updated_by": "Tamu",
            "updated_at": "2025-10-09 10:54:35",
            "detail": {
                "nama_sppg": "SPPG Soreang",
                "alamat_sppg": "1.0,2.0",
                "kecamatan": "MARGAASIH",
                "desa": "NANJUNG",
                "puskesmas": "DINAS KOMUNIKASI INFORMATIKA DAN STATISTIK",
                "skor_inspeksi_kesehatan_lingkungan": 85,
                "temuan_di_lapangan": "test",
                "tanggal_inspeksi": "2025-10-09",
                "terdapat_sop": "Tidak",
                "terdapat_sumber_air": "Perpipaan",
                "terdapat_slhs": "Ya",
                "jumlah_penjamah_makanan": 3,
                "jumlah_penjamah_makanan_tersertifikasi": 2,
                "dokumentasi_foto": "https://storageapi.bandungkab.go.id/dashboard-pimpinan/form-uploads/j3aKRt555gHNOCul4N2X8TkCBbW3fdKD2Eu3n6iW.jpg?X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=I3baADsIJfGs0HkkjxBZ%2F20251009%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20251009T043253Z&X-Amz-SignedHeaders=host&X-Amz-Expires=60&X-Amz-Signature=19644540f20b24693df3e7cd420a80fcc70bd7b3d2ea42f3099075f02e7736af"
            }
        },
        {
            "id": 34466,
            "department_id": "Tamu",
            "department_nama": "Tamu",
            "asistant_nama": "Tamu",
            "created_by": "Tamu",
            "created_at": "2025-10-08 16:03:33",
            "updated_by": "Tamu",
            "updated_at": "2025-10-08 16:03:33",
            "detail": {
                "nama_sppg": "SPPG Katapang",
                "alamat_sppg": "1.0,2.0",
                "kecamatan": "KATAPANG",
                "desa": "KATAPANG",
                "puskesmas": "DINAS LINGKUNGAN HIDUP",
                "skor_inspeksi_kesehatan_lingkungan": 85,
                "temuan_di_lapangan": "oke",
                "tanggal_inspeksi": "2025-10-08",
                "terdapat_sop": "Tidak",
                "terdapat_sumber_air": "Lainnya",
                "terdapat_slhs": "Ya",
                "jumlah_penjamah_makanan": 3,
                "jumlah_penjamah_makanan_tersertifikasi": 2,
                "dokumentasi_foto": "https://storageapi.bandungkab.go.id/dashboard-pimpinan/form-uploads/c6pePTnKvnwSfi2ibJuPMkXU8V25Rswr8YLcE4JJ.jpg?X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=I3baADsIJfGs0HkkjxBZ%2F20251009%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20251009T043254Z&X-Amz-SignedHeaders=host&X-Amz-Expires=60&X-Amz-Signature=b0a7920180f594a6e2535d6ea1df857266ff42bccecb344d168d040cfe41546d"
            }
        },
        {
            "id": 34842,
            "department_id": "Tamu",
            "department_nama": "Tamu",
            "asistant_nama": "Tamu",
            "created_by": "Tamu",
            "created_at": "2025-10-09 10:54:23",
            "updated_by": "Tamu",
            "updated_at": "2025-10-09 10:54:23",
            "detail": {
                "nama_sppg": "SPPG Soreang",
                "alamat_sppg": "1.0,2.0",
                "kecamatan": "MARGAASIH",
                "desa": "NANJUNG",
                "puskesmas": "DINAS KOMUNIKASI INFORMATIKA DAN STATISTIK",
                "skor_inspeksi_kesehatan_lingkungan": 85,
                "temuan_di_lapangan": "test",
                "tanggal_inspeksi": "2025-10-09",
                "terdapat_sop": "Tidak",
                "terdapat_sumber_air": "Perpipaan",
                "terdapat_slhs": "Ya",
                "jumlah_penjamah_makanan": 3,
                "jumlah_penjamah_makanan_tersertifikasi": 2,
                "dokumentasi_foto": "https://storageapi.bandungkab.go.id/dashboard-pimpinan/form-uploads/GsRzxeYgEOawMjFx0MfAous91FOBStLh3Duecnhn.jpg?X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=I3baADsIJfGs0HkkjxBZ%2F20251009%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20251009T043254Z&X-Amz-SignedHeaders=host&X-Amz-Expires=60&X-Amz-Signature=7ae1fb07f4238c59ac87b33288c37da56bb8f54b167c1a79012a2d99e5894a51"
            }
        },
        {
            "id": 34844,
            "department_id": "Tamu",
            "department_nama": "Tamu",
            "asistant_nama": "Tamu",
            "created_by": "Tamu",
            "created_at": "2025-10-09 11:19:52",
            "updated_by": "Tamu",
            "updated_at": "2025-10-09 11:19:52",
            "detail": {
                "nama_sppg": "uu",
                "alamat_sppg": "0.0,0.0",
                "kecamatan": "BOJONGSOANG",
                "desa": "BOJONGSOANG",
                "puskesmas": "DINAS KOPERASI DAN USAHA KECIL DAN MENENGAH",
                "skor_inspeksi_kesehatan_lingkungan": 55,
                "temuan_di_lapangan": "ff",
                "tanggal_inspeksi": "2025-10-09",
                "terdapat_sop": "Ya",
                "terdapat_sumber_air": "Perpipaan",
                "terdapat_slhs": "Ya",
                "jumlah_penjamah_makanan": "0",
                "jumlah_penjamah_makanan_tersertifikasi": 8,
                "dokumentasi_foto": "https://storageapi.bandungkab.go.id/dashboard-pimpinan/form-uploads/mk12HEyyzUi3bPhgDLVMWxqFgC9HlYS8QaYO5edF.jpg?X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=I3baADsIJfGs0HkkjxBZ%2F20251009%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20251009T043254Z&X-Amz-SignedHeaders=host&X-Amz-Expires=60&X-Amz-Signature=3fe46b4264a25ef61c5a7db38c86fb232c394e16f19999942dfc260cdb79cae7"
            }
        }
    ]
}

nanti id nya akan digunakan untuk get view data, jdi tidak perlu menyimpan data di lokal lagi

