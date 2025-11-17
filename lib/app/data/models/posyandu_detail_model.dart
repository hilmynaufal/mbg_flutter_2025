class PosyanduDetailModel {
  final String tanggalPelapor;
  final String namaLengkapPelapor;
  final int noHpPelapor;
  final String namaPosyandu;
  final String kecamatan;
  final String desa;
  final String alamatLengkapPosyandu;
  final String titikLokasi;
  final String namaKetuaPosyandu;
  final int noWhatsappKetuaPosyandu;
  final String fotoPosyanduTampakDepan;
  final String fotoPosyanduTampakDalam;
  final int jumlahBumil;
  final int jumlahBusui;
  final int jumlahBalita;

  PosyanduDetailModel({
    required this.tanggalPelapor,
    required this.namaLengkapPelapor,
    required this.noHpPelapor,
    required this.namaPosyandu,
    required this.kecamatan,
    required this.desa,
    required this.alamatLengkapPosyandu,
    required this.titikLokasi,
    required this.namaKetuaPosyandu,
    required this.noWhatsappKetuaPosyandu,
    required this.fotoPosyanduTampakDepan,
    required this.fotoPosyanduTampakDalam,
    required this.jumlahBumil,
    required this.jumlahBusui,
    required this.jumlahBalita,
  });

  factory PosyanduDetailModel.fromJson(Map<String, dynamic> json) {
    return PosyanduDetailModel(
      tanggalPelapor: json['tanggal_pelapor'] ?? '',
      namaLengkapPelapor: json['nama_lengkap_pelapor'] ?? '',
      noHpPelapor: _parseToInt(json['no_hp_pelapor']),
      namaPosyandu: json['nama_posyandu'] ?? '',
      kecamatan: json['kecamatan'] ?? '',
      desa: json['desa'] ?? '',
      alamatLengkapPosyandu: json['alamat_lengkap_posyandu'] ?? '',
      titikLokasi: json['titik_lokasi'] ?? '',
      namaKetuaPosyandu: json['nama_ketua_posyandu'] ?? '',
      noWhatsappKetuaPosyandu: _parseToInt(json['no_whatsapp_ketua_posyandu']),
      fotoPosyanduTampakDepan: json['foto_posyandu_tampak_depan'] ?? '',
      fotoPosyanduTampakDalam: json['foto_posyandu_tampak_dalam'] ?? '',
      jumlahBumil: _parseToInt(json['jumlah_bumil']),
      jumlahBusui: _parseToInt(json['jumlah_busui']),
      jumlahBalita: _parseToInt(json['jumlah_balita']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tanggal_pelapor': tanggalPelapor,
      'nama_lengkap_pelapor': namaLengkapPelapor,
      'no_hp_pelapor': noHpPelapor,
      'nama_posyandu': namaPosyandu,
      'kecamatan': kecamatan,
      'desa': desa,
      'alamat_lengkap_posyandu': alamatLengkapPosyandu,
      'titik_lokasi': titikLokasi,
      'nama_ketua_posyandu': namaKetuaPosyandu,
      'no_whatsapp_ketua_posyandu': noWhatsappKetuaPosyandu,
      'foto_posyandu_tampak_depan': fotoPosyanduTampakDepan,
      'foto_posyandu_tampak_dalam': fotoPosyanduTampakDalam,
      'jumlah_bumil': jumlahBumil,
      'jumlah_busui': jumlahBusui,
      'jumlah_balita': jumlahBalita,
    };
  }

  // Helper method to safely parse int from dynamic
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

  // Get phone number with leading zero
  String get formattedNoHp => '0$noHpPelapor';
  String get formattedNoWhatsapp => '0$noWhatsappKetuaPosyandu';
}
