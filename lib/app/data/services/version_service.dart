import 'dart:developer';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../providers/version_provider.dart';
import '../models/version_check_response_model.dart';

class VersionService extends GetxService {
  final VersionProvider _versionProvider = VersionProvider();

  /// Get current app version
  Future<String> getCurrentVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      return packageInfo.version; // e.g., "0.9.3"
      // return '0.9.3';
    } catch (e) {
      log('Error getting package info: $e', name: 'VersionService');
      return '0.0.0';
    }
  }

  /// Check for app updates
  /// Returns VersionData if successful, null if error
  Future<VersionData?> checkForUpdate() async {
    try {
      final currentVersion = await getCurrentVersion();
      log('Current app version: $currentVersion', name: 'VersionService');

      final response = await _versionProvider.checkVersion(
        currentVersion: currentVersion,
      );

      if (response.success) {
        log('Latest version: ${response.data.latestVersion}', name: 'VersionService');
        log('Minimum version: ${response.data.minimumVersion}', name: 'VersionService');
        log('Force update: ${response.data.forceUpdate}', name: 'VersionService');
        log('Optional update: ${response.data.optionalUpdate}', name: 'VersionService');

        return response.data;
      }

      return null;
    } catch (e) {
      log('Error checking version: $e', name: 'VersionService');
      return null;
    }
  }

  /// Compare two version strings
  /// Returns:
  ///   -1 if version1 < version2
  ///    0 if version1 == version2
  ///    1 if version1 > version2
  int compareVersions(String version1, String version2) {
    try {
      // Remove any suffix like "-alpha", "+20251118v3"
      final v1Clean = _cleanVersion(version1);
      final v2Clean = _cleanVersion(version2);

      final v1Parts = v1Clean.split('.').map(int.parse).toList();
      final v2Parts = v2Clean.split('.').map(int.parse).toList();

      // Ensure both have 3 parts (major.minor.patch)
      while (v1Parts.length < 3) {
        v1Parts.add(0);
      }
      while (v2Parts.length < 3) {
        v2Parts.add(0);
      }

      // Compare major, minor, patch
      for (int i = 0; i < 3; i++) {
        if (v1Parts[i] < v2Parts[i]) return -1;
        if (v1Parts[i] > v2Parts[i]) return 1;
      }

      return 0;
    } catch (e) {
      log('Error comparing versions: $e', name: 'VersionService');
      return 0;
    }
  }

  /// Clean version string by removing suffixes
  /// e.g., "0.9.3-alpha+20251118v3" -> "0.9.3"
  String _cleanVersion(String version) {
    // Remove everything after "-" or "+"
    String cleaned = version.split('-')[0].split('+')[0];
    return cleaned.trim();
  }

  /// Check if update is required based on version data
  /// Returns true if force update is needed
  bool isForceUpdateRequired(VersionData versionData) {
    return versionData.forceUpdate;
  }

  /// Check if optional update is available
  /// Returns true if optional update is available
  bool isOptionalUpdateAvailable(VersionData versionData) {
    return versionData.optionalUpdate;
  }

  /// Check if current version is below minimum version
  Future<bool> isBelowMinimumVersion(String minimumVersion) async {
    final currentVersion = await getCurrentVersion();
    return compareVersions(currentVersion, minimumVersion) < 0;
  }

  /// Check if current version is below latest version
  Future<bool> isBelowLatestVersion(String latestVersion) async {
    final currentVersion = await getCurrentVersion();
    return compareVersions(currentVersion, latestVersion) < 0;
  }
}
