#update versi 0.13.1

di update ini saya ingin menambahkan fitur hak akses, dimana di menu menu yang muncul di aplikasi ini akan di sesuaikan dengan hak akses user yang login.

di menu mbg_sppg_dashboard, kita mengambil data menu dari endpoint /data/menu-aplikasi-satgas-mbg, berikut adalah contoh respon
{
            "id": 173956,
            "status": null,
            "department_id": 1,
            "department_nama": "Pemerintah Kabupaten Bandung",
            "asistant_nama": "Tamu",
            "created_by": "Mugi Rachmat",
            "created_at": "2026-01-31 15:03:02",
            "updated_by": "Mugi Rachmat",
            "updated_at": "2026-01-31 15:03:02",
            "detail": {
                "menu": "Laporan PSAT",
                "slug": "data-sppg-yang-sudah-tersurveilans-psat-nitFP",
                "ikon": "fa fa-certificate",
                "warna_background": "#2980b9",
                "warna_teks": "#ffffff",
                "kategori": "Sub Menu",
                "deskripsi": "Pangan Segar Asal Tumbuhan",
                "parent_menu": "Dispakan",
                "hak_akses": "DINAS KETAHANAN PANGAN DAN PERIKANAN",
                "required_filter": "-"
            }
        }
    }
}

di detail ada hak akses, jadi kita harus memfilter menu berdasarkan hak akses user yang login. hak akses di tulis dengan format string, dan di pisah menggunakan tanda ; contohnya "DINAS KETAHANAN PANGAN DAN PERIKANAN;DINAS KESEHATAN"

cocokan dengan model user yang login, jika user login menggunakan metode PNS, maka cocokan dengan field "skpdnama", jika user login menggunakan metode Non ASN, maka cocokan dengan field "satuan_kerja"
