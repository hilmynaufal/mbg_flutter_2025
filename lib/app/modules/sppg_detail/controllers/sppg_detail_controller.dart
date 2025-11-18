import 'package:get/get.dart';
import 'package:flutter/services.dart';
import '../../../data/models/sppg_item_model.dart';

class SppgDetailController extends GetxController {
  // Receive SPPG data from route arguments
  late SppgItemModel sppg;

  @override
  void onInit() {
    super.onInit();
    sppg = Get.arguments as SppgItemModel;
  }

  /// Copy text to clipboard
  Future<void> copyToClipboard(String text, String label) async {
    await Clipboard.setData(ClipboardData(text: text));
    Get.snackbar(
      'Berhasil',
      '$label telah disalin ke clipboard',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  /// Parse suplai makanan string into list
  List<String> get suplaiMakananList {
    if (sppg.detail.suplaiMakanan.isEmpty) return [];
    return sppg.detail.suplaiMakanan
        .split('\n')
        .where((line) => line.trim().isNotEmpty)
        .toList();
  }

  /// Open WhatsApp chat (returns URL for url_launcher if needed)
  String get whatsappUrl {
    final phoneNumber = sppg.detail.noWhatsappKetuaSppg.toString();
    return 'https://wa.me/62$phoneNumber';
  }

  /// Mask phone number (e.g., "08123456789" -> "08xxx789")
  String maskPhoneNumber(String phoneNumber) {
    if (phoneNumber.isEmpty) return '-';

    // Remove leading '0' if present for processing
    final cleanNumber = phoneNumber.startsWith('0')
        ? phoneNumber.substring(1)
        : phoneNumber;

    if (cleanNumber.length <= 4) {
      // Too short to mask meaningfully
      return '0${'x' * cleanNumber.length}';
    }

    // Format: 0 + first 1 digit + xxx + last 1 digit
    // Example: "08123456789" -> "08xxx9"
    final firstPart = cleanNumber.substring(0, 1); // "8"
    final lastPart = cleanNumber.substring(cleanNumber.length - 1); // "9"

    return '0$firstPart${'x' * 3}$lastPart';
  }

  /// Mask name (e.g., "Budiono Siregar" -> "Bud***r")
  String maskName(String name) {
    if (name.isEmpty) return '-';

    if (name.length <= 4) {
      // Too short to mask meaningfully
      return '${'x' * name.length}';
    }

    // Format: first 3 chars + *** + last 1 char
    // Example: "Budiono Siregar" -> "Bud***r"
    final firstPart = name.substring(0, 3);
    final lastPart = name.substring(name.length - 1);

    return '$firstPart***$lastPart';
  }

  /// Get masked WhatsApp number
  String get maskedWhatsappKetua {
    return maskPhoneNumber('0${sppg.detail.noWhatsappKetuaSppg}');
  }

  /// Get masked HP number
  String get maskedNoHpPelapor {
    return maskPhoneNumber('0${sppg.detail.noHp}');
  }

  /// Get masked ketua name
  String get maskedNamaKetua {
    return maskName(sppg.detail.namaKetuaSppg);
  }

  /// Get masked pelapor name
  String get maskedNamaPelapor {
    return maskName(sppg.detail.namaLengkap);
  }
}
