class SppgDetailModel {
  final String tanggalLaporan;
  final String namaLengkap;
  final int noHp;
  final String namaSppg;
  final String namaMitraAtauYayasan;
  final String kecamatan;
  final String desa;
  final String alamatLengkapLokasi;
  final String titikLokasi;
  final String namaKetuaSppg;
  final int noWhatsappKetuaSppg;
  final String status;
  final String statusSppg;
  final String fotoSppgTampakDepan;
  final String fotoSppgTampakDalam;
  final String fotoSppgTampakDapur;
  final String suplaiMakanan;
  final int totalProduksi;

  SppgDetailModel({
    required this.tanggalLaporan,
    required this.namaLengkap,
    required this.noHp,
    required this.namaSppg,
    required this.namaMitraAtauYayasan,
    required this.kecamatan,
    required this.desa,
    required this.alamatLengkapLokasi,
    required this.titikLokasi,
    required this.namaKetuaSppg,
    required this.noWhatsappKetuaSppg,
    required this.status,
    required this.statusSppg,
    required this.fotoSppgTampakDepan,
    required this.fotoSppgTampakDalam,
    required this.fotoSppgTampakDapur,
    required this.suplaiMakanan,
    required this.totalProduksi,
  });

  factory SppgDetailModel.fromJson(Map<String, dynamic> json) {
    return SppgDetailModel(
      tanggalLaporan: json['tanggal_laporan'] ?? '',
      namaLengkap: json['nama_lengkap'] ?? '',
      noHp: _parseToInt(json['no_hp']),
      namaSppg: json['nama_sppg'] ?? '',
      namaMitraAtauYayasan: json['nama_mitra_atau_yayasan'] ?? '',
      kecamatan: json['kecamatan'] ?? '',
      desa: json['desa'] ?? '',
      alamatLengkapLokasi: json['alamat_lengkap_lokasi'] ?? '',
      titikLokasi: json['titik_lokasi'] ?? '',
      namaKetuaSppg: json['nama_ketua_sppg'] ?? '',
      noWhatsappKetuaSppg: _parseToInt(json['no_whatsapp_ketua_sppg']),
      status: json['status'] ?? '',
      statusSppg: json['status_sppg'] ?? '',
      fotoSppgTampakDepan: json['foto_sppg_tampak_depan'] ?? '',
      fotoSppgTampakDalam: json['foto_sppg_tampak_dalam'] ?? '',
      fotoSppgTampakDapur: json['foto_sppg_tampak_dapur'] ?? '',
      suplaiMakanan: json['suplai_makanan'] ?? '',
      totalProduksi: _parseToInt(json['total_produksi']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tanggal_laporan': tanggalLaporan,
      'nama_lengkap': namaLengkap,
      'no_hp': noHp,
      'nama_sppg': namaSppg,
      'nama_mitra_atau_yayasan': namaMitraAtauYayasan,
      'kecamatan': kecamatan,
      'desa': desa,
      'alamat_lengkap_lokasi': alamatLengkapLokasi,
      'titik_lokasi': titikLokasi,
      'nama_ketua_sppg': namaKetuaSppg,
      'no_whatsapp_ketua_sppg': noWhatsappKetuaSppg,
      'status': status,
      'status_sppg': statusSppg,
      'foto_sppg_tampak_depan': fotoSppgTampakDepan,
      'foto_sppg_tampak_dalam': fotoSppgTampakDalam,
      'foto_sppg_tampak_dapur': fotoSppgTampakDapur,
      'suplai_makanan': suplaiMakanan,
      'total_produksi': totalProduksi,
    };
  }

  // Helper method to safely parse int from dynamic (can be int or string)
  static int _parseToInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    return 0;
  }

  // Helper to parse coordinate from titikLokasi string
  List<double>? get coordinateValues {
    try {
      final parts = titikLokasi.split(',').map((e) => e.trim()).toList();
      if (parts.length != 2) return null;

      final lat = double.tryParse(parts[0]);
      final lng = double.tryParse(parts[1]);

      if (lat == null || lng == null) return null;

      // Validate coordinate ranges
      if (lat < -90 || lat > 90 || lng < -180 || lng > 180) return null;

      return [lat, lng];
    } catch (e) {
      return null;
    }
  }

  // Check if SPPG is active
  bool get isActive => statusSppg.toLowerCase() == 'aktif';
}
