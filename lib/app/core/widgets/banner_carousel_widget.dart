import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart' as carousel;
import '../theme/app_colors.dart';

class BannerItem {
  final String id;
  final String imageUrl;
  final String? title;
  final String? description;

  BannerItem({
    required this.id,
    required this.imageUrl,
    this.title,
    this.description,
  });
}

class BannerCarouselWidget extends StatefulWidget {
  final List<BannerItem> banners;
  final double height;
  final bool autoPlay;
  final Duration autoPlayInterval;
  final void Function(BannerItem)? onBannerTap;

  const BannerCarouselWidget({
    super.key,
    required this.banners,
    this.height = 180,
    this.autoPlay = true,
    this.autoPlayInterval = const Duration(seconds: 5),
    this.onBannerTap,
  });

  @override
  State<BannerCarouselWidget> createState() => _BannerCarouselWidgetState();
}

class _BannerCarouselWidgetState extends State<BannerCarouselWidget> {
  int _currentIndex = 0;
  final carousel.CarouselSliderController _carouselController =
      carousel.CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    if (widget.banners.isEmpty) {
      return _buildEmptyBanner();
    }

    return Column(
      children: [
        carousel.CarouselSlider.builder(
          carouselController: _carouselController,
          itemCount: widget.banners.length,
          options: carousel.CarouselOptions(
            height: widget.height,
            viewportFraction: 0.9,
            enlargeCenterPage: true,
            autoPlay: widget.autoPlay,
            autoPlayInterval: widget.autoPlayInterval,
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          itemBuilder: (context, index, realIndex) {
            final banner = widget.banners[index];
            return _buildBannerItem(banner);
          },
        ),
        const SizedBox(height: 12),
        _buildIndicators(),
      ],
    );
  }

  Widget _buildBannerItem(BannerItem banner) {
    return GestureDetector(
      onTap: () => widget.onBannerTap?.call(banner),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Banner Image
              Image.network(
                banner.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppColors.greyLight,
                    child: const Center(
                      child: Icon(Icons.image, size: 64, color: AppColors.grey),
                    ),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: AppColors.greyLight,
                    child: const Center(child: CircularProgressIndicator()),
                  );
                },
              ),
              // Gradient Overlay (if title or description exists)
              if (banner.title != null || banner.description != null)
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),
              // Text Content
              if (banner.title != null || banner.description != null)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (banner.title != null)
                          Text(
                            banner.title!,
                            style: Theme.of(
                              context,
                            ).textTheme.titleMedium?.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        if (banner.description != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            banner.description!,
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall?.copyWith(
                              color: AppColors.white.withOpacity(0.9),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children:
          widget.banners.asMap().entries.map((entry) {
            final isActive = _currentIndex == entry.key;
            return GestureDetector(
              onTap: () => _carouselController.animateToPage(entry.key),
              child: Container(
                width: isActive ? 24 : 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color:
                      isActive
                          ? AppColors.primary
                          : AppColors.grey.withOpacity(0.3),
                ),
              ),
            );
          }).toList(),
    );
  }

  Widget _buildEmptyBanner() {
    return Container(
      height: widget.height,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.greyLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image, size: 64, color: AppColors.grey),
            SizedBox(height: 8),
            Text('Tidak ada banner', style: TextStyle(color: AppColors.grey)),
          ],
        ),
      ),
    );
  }
}
