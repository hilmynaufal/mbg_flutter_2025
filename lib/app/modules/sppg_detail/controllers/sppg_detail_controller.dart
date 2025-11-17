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
}
