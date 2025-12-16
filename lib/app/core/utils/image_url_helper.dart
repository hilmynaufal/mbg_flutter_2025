/// Utility class for handling image URLs
/// Provides helpers to normalize and fix inconsistent image URLs from different API endpoints
class ImageUrlHelper {
  /// Check if URL already has AWS S3 signature query parameters
  static bool hasSignature(String url) {
    return url.contains('X-Amz-Signature') || url.contains('?');
  }

  /// Normalize image URL to ensure it can be displayed
  ///
  /// URLs from getOpdDataList already have AWS S3 signatures
  /// URLs from viewForm don't have signatures and might not load
  ///
  /// For now, we'll try to load both formats
  /// If unsigned URLs don't work, API needs to provide signed URLs
  static String normalizeImageUrl(String url) {
    if (url.isEmpty) return url;

    // If URL already has signature, return as-is
    if (hasSignature(url)) {
      return url;
    }

    // For unsigned URLs from viewForm, return as-is
    // Note: If these don't load, the API needs to provide signed URLs
    // We cannot generate valid AWS signatures client-side
    return url;
  }

  /// Get a fallback URL or placeholder if image fails to load
  static String getFallbackUrl() {
    return ''; // Return empty string to show broken image icon
  }
}
