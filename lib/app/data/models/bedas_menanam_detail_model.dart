class BedasMenanamDetailModel {
  final String namaLengkap;
  final String fotoLahanYangAkanDigunakan;
  final int rw;
  final String lokasiTaman;
  final String catatanKeterangan;
  final String namaLengkapPelapor;
  final int nomorWhatsappPelapor;
  final String kelompokPelapor;
  final int luasLahanYangTersediaMeterPersegi;
  final String jenisPangan;
  final String jenisHewanYangInginDibudidayakan;
  final String jenisIkanYangInginDibudidayakan;
  final String jikaSayuranLainnyaSebutkan;
  final String kecamatan;
  final String desa;
  final int rt;
  final int nomorWhatsapp;
  final String jenisSayuranYangInginDitanam;

  BedasMenanamDetailModel({
    required this.namaLengkap,
    required this.fotoLahanYangAkanDigunakan,
    required this.rw,
    required this.lokasiTaman,
    required this.catatanKeterangan,
    required this.namaLengkapPelapor,
    required this.nomorWhatsappPelapor,
    required this.kelompokPelapor,
    required this.luasLahanYangTersediaMeterPersegi,
    required this.jenisPangan,
    required this.jenisHewanYangInginDibudidayakan,
    required this.jenisIkanYangInginDibudidayakan,
    required this.jikaSayuranLainnyaSebutkan,
    required this.kecamatan,
    required this.desa,
    required this.rt,
    required this.nomorWhatsapp,
    required this.jenisSayuranYangInginDitanam,
  });

  factory BedasMenanamDetailModel.fromJson(Map<String, dynamic> json) {
    return BedasMenanamDetailModel(
      namaLengkap: json['nama_lengkap'] ?? '',
      fotoLahanYangAkanDigunakan: json['foto_lahan_yang_akan_digunakan'] ?? '',
      rw: _parseToInt(json['rw']),
      lokasiTaman: json['lokasi_taman'] ?? '',
      catatanKeterangan: json['catatan_keterangan'] ?? '',
      namaLengkapPelapor: json['nama_lengkap_pelapor'] ?? '',
      nomorWhatsappPelapor: _parseToInt(json['nomor_whatsapp_pelapor']),
      kelompokPelapor: json['kelompok_pelapor'] ?? '',
      luasLahanYangTersediaMeterPersegi: _parseToInt(json['luas_lahan_yang_tersedia_meter_persegi']),
      jenisPangan: json['jenis_pangan'] ?? '',
      jenisHewanYangInginDibudidayakan: json['jenis_hewan_yang_ingin_dibudidayakan'] ?? '',
      jenisIkanYangInginDibudidayakan: json['jenis_ikan_yang_ingin_dibudidayakan'] ?? '',
      jikaSayuranLainnyaSebutkan: json['jika_lainnya_sebutkan'] ?? '',
      kecamatan: json['kecamatan'] ?? '',
      desa: json['desa'] ?? '',
      rt: _parseToInt(json['rt']),
      nomorWhatsapp: _parseToInt(json['nomor_whatsapp']),
      jenisSayuranYangInginDitanam: json['jenis_sayuran_yang_ingin_ditanam'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama_lengkap': namaLengkap,
      'foto_lahan_yang_akan_digunakan': fotoLahanYangAkanDigunakan,
      'rw': rw,
      'lokasi_taman': lokasiTaman,
      'catatan_keterangan': catatanKeterangan,
      'nama_lengkap_pelapor': namaLengkapPelapor,
      'nomor_whatsapp_pelapor': nomorWhatsappPelapor,
      'kelompok_pelapor': kelompokPelapor,
      'luas_lahan_yang_tersedia_meter_persegi': luasLahanYangTersediaMeterPersegi,
      'jenis_pangan': jenisPangan,
      'jenis_hewan_yang_ingin_dibudidayakan': jenisHewanYangInginDibudidayakan,
      'jenis_ikan_yang_ingin_dibudidayakan': jenisIkanYangInginDibudidayakan,
      'jika_sayuran_lainnya_sebutkan': jikaSayuranLainnyaSebutkan,
      'kecamatan': kecamatan,
      'desa': desa,
      'rt': rt,
      'nomor_whatsapp': nomorWhatsapp,
      'jenis_sayuran_yang_ingin_ditanam': jenisSayuranYangInginDitanam,
    };
  }

  // Helper to safely parse int from dynamic
  static int _parseToInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is double) return value.toInt();
    return 0;
  }

  // Formatted phone number with leading zero
  String get formattedWhatsapp => nomorWhatsappPelapor > 0 ? '0$nomorWhatsappPelapor' : '';

  // Formatted nomor whatsapp
  String get formattedNomorWhatsapp => nomorWhatsapp > 0 ? '0$nomorWhatsapp' : '';
}
