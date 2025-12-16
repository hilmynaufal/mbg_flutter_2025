import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewController extends GetxController {
  // Arguments from route
  late final String url;
  late final String title;

  // Webview controller
  late final WebViewController webViewController;

  // Observable states
  final RxInt loadingProgress = 0.obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();

    // Extract arguments
    final args = Get.arguments as Map<String, dynamic>;
    url = args['url'] as String;
    title = args['title'] as String;

    // Initialize webview controller
    _initializeWebView();
  }

  void _initializeWebView() {
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            loadingProgress.value = progress;
            isLoading.value = progress < 100;
          },
          onPageStarted: (String url) {
            isLoading.value = true;
          },
          onPageFinished: (String url) {
            isLoading.value = false;
          },
          onWebResourceError: (WebResourceError error) {
            Get.snackbar(
              'Error',
              'Failed to load page: ${error.description}',
              snackPosition: SnackPosition.BOTTOM,
            );
          },
        ),
      )
      ..loadRequest(Uri.parse(url));
  }

  void reload() {
    webViewController.reload();
  }

  void goBack() async {
    if (await webViewController.canGoBack()) {
      webViewController.goBack();
    } else {
      Get.back();
    }
  }
}
