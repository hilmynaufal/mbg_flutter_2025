import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_html/flutter_html.dart';
import '../controllers/news_detail_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class NewsDetailView extends GetView<NewsDetailController> {
  const NewsDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Berita'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        forceMaterialTransparency: true,
        // elevation: 2,
      ),
      body: Obx(() {
        // Loading state
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // Error state
        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Gagal Memuat Berita',
                    style: AppTextStyles.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    controller.errorMessage.value,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: controller.retry,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Coba Lagi'),
                  ),
                ],
              ),
            ),
          );
        }

        // Content state
        final news = controller.newsDetail.value;
        if (news == null) {
          return const Center(
            child: Text('Berita tidak ditemukan'),
          );
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Image
              if (news.imageUrl.isNotEmpty)
                Image.network(
                  news.imageUrl,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 250,
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.broken_image,
                        size: 64,
                        color: Colors.grey,
                      ),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      width: double.infinity,
                      height: 250,
                      color: Colors.grey[200],
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  },
                ),

              // Content Container
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      news.title,
                      style: AppTextStyles.headlineMedium.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Metadata Row
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          DateFormat('dd MMMM yyyy', 'id_ID')
                              .format(news.createdAt),
                          style: AppTextStyles.bodySmall.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        if (news.author.isNotEmpty) ...[
                          const SizedBox(width: 16),
                          Icon(
                            Icons.person,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              news.author,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: Colors.grey[600],
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ],
                    ),

                    // Category Badge
                    if (news.category.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          news.category,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 16),

                    // HTML Content
                    if (news.content != null && news.content!.isNotEmpty)
                      Html(
                        data: news.content!,
                        style: {
                          "body": Style(
                            fontSize: FontSize(16),
                            lineHeight: const LineHeight(1.6),
                            margin: Margins.zero,
                            padding: HtmlPaddings.zero,
                          ),
                          "p": Style(
                            margin: Margins.only(bottom: 12),
                          ),
                          "h1, h2, h3, h4, h5, h6": Style(
                            fontWeight: FontWeight.bold,
                            margin: Margins.only(top: 16, bottom: 8),
                          ),
                          "img": Style(
                            width: Width.auto(),
                            height: Height.auto(),
                          ),
                        },
                      )
                    else
                      Text(
                        news.description,
                        style: AppTextStyles.bodyLarge.copyWith(
                          height: 1.6,
                        ),
                      ),

                    // Tags
                    if (news.tags != null && news.tags!.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      const Divider(),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: news.tags!
                            .split(',')
                            .map((tag) => Chip(
                                  label: Text(
                                    tag.trim(),
                                    style: AppTextStyles.bodySmall,
                                  ),
                                  backgroundColor: Colors.grey[200],
                                  padding: EdgeInsets.zero,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ))
                            .toList(),
                      ),
                    ],

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
