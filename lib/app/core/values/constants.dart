class AppConstants {
  // API Base URLs
  static const String baseUrlSultan = 'https://sultan.bandungkab.go.id/api';
  static const String baseUrlApi = 'https://api.bandungkab.go.id/api';

  // API Endpoints
  static const String loginEndpoint = '$baseUrlSultan/Login';
  static const String formEndpoint = '$baseUrlApi/form/format';

  // Storage Keys
  static const String keyUser = 'user';
  static const String keyIsLoggedIn = 'is_logged_in';
  static const String keyToken = 'token';
  static const String keyReportIds = 'report_ids';
  static const String keyPenerimaMbgReports = 'penerima_mbg_reports';

  // Timeouts
  static const int connectionTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds
}
