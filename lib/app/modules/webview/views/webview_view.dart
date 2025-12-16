import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../controllers/webview_controller.dart';

class WebviewView extends GetView<WebviewController> {
  const WebviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.title),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.reload,
            tooltip: 'Reload',
          ),
        ],
      ),
      body: Column(
        children: [
          // Loading progress bar
          Obx(() {
            if (controller.isLoading.value) {
              return LinearProgressIndicator(
                value: controller.loadingProgress.value / 100,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              );
            }
            return const SizedBox.shrink();
          }),

          // WebView
          Expanded(
            child: WebViewWidget(
              controller: controller.webViewController,
            ),
          ),
        ],
      ),
    );
  }
}
