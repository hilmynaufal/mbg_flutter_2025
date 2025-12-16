class VersionCheckResponseModel {
  final bool success;
  final VersionData data;

  VersionCheckResponseModel({
    required this.success,
    required this.data,
  });

  factory VersionCheckResponseModel.fromJson(Map<String, dynamic> json) {
    return VersionCheckResponseModel(
      success: json['success'] ?? false,
      data: VersionData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data.toJson(),
    };
  }
}

class VersionData {
  final String latestVersion;
  final String minimumVersion;
  final String? currentVersion;
  final bool forceUpdate;
  final bool optionalUpdate;
  final String? updateMessage;
  final DownloadUrl downloadUrl;

  VersionData({
    required this.latestVersion,
    required this.minimumVersion,
    this.currentVersion,
    required this.forceUpdate,
    required this.optionalUpdate,
    this.updateMessage,
    required this.downloadUrl,
  });

  factory VersionData.fromJson(Map<String, dynamic> json) {
    return VersionData(
      latestVersion: json['latest_version'] ?? '0.0.0',
      minimumVersion: json['minimum_version'] ?? '0.0.0',
      currentVersion: json['current_version'],
      forceUpdate: json['force_update'] ?? false,
      optionalUpdate: json['optional_update'] ?? false,
      updateMessage: json['update_message'],
      downloadUrl: DownloadUrl.fromJson(json['download_url'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latest_version': latestVersion,
      'minimum_version': minimumVersion,
      'current_version': currentVersion,
      'force_update': forceUpdate,
      'optional_update': optionalUpdate,
      'update_message': updateMessage,
      'download_url': downloadUrl.toJson(),
    };
  }
}

class DownloadUrl {
  final String android;
  final String ios;

  DownloadUrl({
    required this.android,
    required this.ios,
  });

  factory DownloadUrl.fromJson(Map<String, dynamic> json) {
    return DownloadUrl(
      android: json['android'] ?? '',
      ios: json['ios'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'android': android,
      'ios': ios,
    };
  }
}
