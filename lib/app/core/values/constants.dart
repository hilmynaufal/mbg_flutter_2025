class AppConstants {
  // API Base URLs
  static const String baseUrlSultan = 'https://sultan.bandungkab.go.id/api';
  static const String baseUrlApi = 'https://api.bandungkab.go.id/api';
  static const String baseUrlFallback = 'https://hirumi.xyz/fallback_api/api';

  // API Endpoints
  static const String loginEndpoint = '$baseUrlSultan/Login';
  static const String formEndpoint = '$baseUrlApi/form/format';
  static const String versionCheckEndpoint = '$baseUrlFallback/version/check';

  // Storage Keys
  static const String keyUser = 'user';
  static const String keyIsLoggedIn = 'is_logged_in';
  static const String keyToken = 'token';
  static const String keyReportIds = 'report_ids';
  static const String keyPenerimaMbgReports = 'penerima_mbg_reports';
  static const String keyBedasMenanamPassword = 'bedas_menanam_password';

  // Timeouts
  static const int connectionTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds

  // App Info
  static const String appName = 'Satgas MBG Kabupaten Bandung';
  static const String androidPackageName = 'com.bandungkab.mbg';
  static const String iosAppId = 'your-ios-app-id';

  // Play Store & App Store URLs
  static const String playStoreUrl = 'https://play.google.com/store/apps/details?id=$androidPackageName';
  static const String appStoreUrl = 'https://apps.apple.com/app/$iosAppId';
}
