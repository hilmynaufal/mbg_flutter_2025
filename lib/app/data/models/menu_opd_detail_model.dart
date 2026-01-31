import 'package:flutter/material.dart';
import '../../core/utils/icon_mapper.dart';

/// Model for OPD menu detail data
/// Contains menu configuration including name, slug, icon, colors, and parent menu
class MenuOpdDetailModel {
  final String menu;
  final String slug;
  final String ikon;
  final String warnaBackground;
  final String warnaTeks;
  final String kategori;
  final String deskripsi;
  final String parentMenu;
  final String hakAkses;
  final String requiredFilter;

  MenuOpdDetailModel({
    required this.menu,
    required this.slug,
    required this.ikon,
    required this.warnaBackground,
    required this.warnaTeks,
    required this.kategori,
    required this.deskripsi,
    required this.parentMenu,
    required this.hakAkses,
    required this.requiredFilter,
  });

  factory MenuOpdDetailModel.fromJson(Map<String, dynamic> json) {
    return MenuOpdDetailModel(
      menu: json['menu'] ?? '',
      slug: json['slug'] ?? '',
      ikon: json['ikon'] ?? '',
      warnaBackground: json['warna_background'] ?? '',
      warnaTeks: json['warna_teks'] ?? '',
      kategori: json['kategori'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      parentMenu: json['parent_menu'] ?? '',
      hakAkses: json['hak_akses'] ?? '',
      requiredFilter: json['required_filter'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'menu': menu,
      'slug': slug,
      'ikon': ikon,
      'warna_background': warnaBackground,
      'warna_teks': warnaTeks,
      'kategori': kategori,
      'deskripsi': deskripsi,
      'parent_menu': parentMenu,
      'hak_akses': hakAkses,
      'required_filter': requiredFilter,
    };
  }

  /// Parse hex color string to Flutter Color
  ///
  /// Accepts formats:
  /// - "#e91e63"
  /// - "e91e63"
  /// - "#E91E63"
  ///
  /// Returns Color or fallback to Colors.blue if invalid
  static Color _parseColor(String hex) {
    if (hex.isEmpty) {
      return Colors.blue;
    }

    try {
      // Remove # if present
      String hexColor = hex.replaceAll('#', '');

      // Validate length (should be 6 characters)
      if (hexColor.length != 6) {
        return Colors.blue;
      }

      // Convert to uppercase and prepend FF for alpha channel
      hexColor = 'FF$hexColor'.toUpperCase();

      // Parse as integer and create Color
      final colorValue = int.parse(hexColor, radix: 16);
      return Color(colorValue);
    } catch (e) {
      // If parsing fails, return fallback color
      return Colors.blue;
    }
  }

  /// Get background color from warnaBackground hex string
  /// Returns parsed Color or Colors.blue as fallback
  Color get backgroundColor => _parseColor(warnaBackground);

  /// Get text color from warnaTeks hex string
  /// Returns parsed Color or Colors.white as fallback
  Color get textColor {
    if (warnaTeks.isEmpty) {
      return Colors.white;
    }
    return _parseColor(warnaTeks);
  }

  /// Get IconData from ikon FontAwesome string
  /// Returns mapped IconData or FontAwesomeIcons.circle as fallback
  IconData? get iconData => IconMapper.mapIcon(ikon);

  /// Check if this menu has a valid icon mapping
  bool get hasIconMapping => IconMapper.hasMapping(ikon);
}
