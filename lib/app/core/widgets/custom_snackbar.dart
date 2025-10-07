import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Custom Snackbar Helper Class
/// Provides consistent snackbar styling across the application
class CustomSnackbar {
  // Private constructor to prevent instantiation
  CustomSnackbar._();

  /// Show success snackbar
  static void success({
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 3),
    SnackPosition position = SnackPosition.TOP,
  }) {
    Get.showSnackbar(
      GetSnackBar(
        title: title,
        message: message,
        icon: const Icon(
          Icons.check_circle,
          color: Colors.white,
        ),
        backgroundColor: Colors.green,
        snackPosition: position,
        duration: duration,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        isDismissible: true,
        dismissDirection: DismissDirection.horizontal,
      ),
    );
  }

  /// Show error snackbar
  static void error({
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 4),
    SnackPosition position = SnackPosition.TOP,
  }) {
    Get.showSnackbar(
      GetSnackBar(
        title: title,
        message: message,
        icon: const Icon(
          Icons.error,
          color: Colors.white,
        ),
        backgroundColor: Colors.red,
        snackPosition: position,
        duration: duration,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        isDismissible: true,
        dismissDirection: DismissDirection.horizontal,
      ),
    );
  }

  /// Show warning snackbar
  static void warning({
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 3),
    SnackPosition position = SnackPosition.TOP,
  }) {
    Get.showSnackbar(
      GetSnackBar(
        title: title,
        message: message,
        icon: const Icon(
          Icons.warning,
          color: Colors.white,
        ),
        backgroundColor: Colors.orange,
        snackPosition: position,
        duration: duration,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        isDismissible: true,
        dismissDirection: DismissDirection.horizontal,
      ),
    );
  }

  /// Show info snackbar
  static void info({
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 3),
    SnackPosition position = SnackPosition.BOTTOM,
  }) {
    Get.showSnackbar(
      GetSnackBar(
        title: title,
        message: message,
        icon: const Icon(
          Icons.info,
          color: Colors.white,
        ),
        backgroundColor: Get.theme.colorScheme.primary,
        snackPosition: position,
        duration: duration,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        isDismissible: true,
        dismissDirection: DismissDirection.horizontal,
      ),
    );
  }
}
