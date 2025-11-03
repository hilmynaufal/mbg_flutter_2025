import 'package:flutter/material.dart';

/// Widget for displaying images with fallback URL support
/// Tries loading from primary URL first, then fallback URL if primary fails
class FallbackImageWidget extends StatefulWidget {
  final String primaryUrl;
  final String? fallbackUrl;
  final double? height;
  final double? width;
  final BoxFit fit;

  const FallbackImageWidget({
    super.key,
    required this.primaryUrl,
    this.fallbackUrl,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
  });

  @override
  State<FallbackImageWidget> createState() => _FallbackImageWidgetState();
}

class _FallbackImageWidgetState extends State<FallbackImageWidget> {
  bool _primaryFailed = false;
  bool _fallbackFailed = false;

  @override
  void didUpdateWidget(FallbackImageWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reset error states if URLs change
    if (oldWidget.primaryUrl != widget.primaryUrl ||
        oldWidget.fallbackUrl != widget.fallbackUrl) {
      setState(() {
        _primaryFailed = false;
        _fallbackFailed = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // If primary failed and no fallback, show error
    if (_primaryFailed && widget.fallbackUrl == null) {
      return _buildErrorWidget();
    }

    // If primary failed and fallback also failed, show error
    if (_primaryFailed && _fallbackFailed) {
      return _buildErrorWidget();
    }

    // Try fallback URL if primary failed
    final imageUrl = _primaryFailed && widget.fallbackUrl != null
        ? widget.fallbackUrl!
        : widget.primaryUrl;

    return Image.network(
      imageUrl,
      height: widget.height,
      width: widget.width,
      fit: widget.fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }

        return Container(
          height: widget.height,
          width: widget.width,
          alignment: Alignment.center,
          color: Colors.grey[200],
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                : null,
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        // If primary URL failed and we have fallback, try fallback
        if (!_primaryFailed && widget.fallbackUrl != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _primaryFailed = true;
              });
            }
          });
          return Container(
            height: widget.height,
            width: widget.width,
            alignment: Alignment.center,
            color: Colors.grey[200],
            child: const CircularProgressIndicator(),
          );
        }

        // If fallback URL also failed, mark it
        if (_primaryFailed && !_fallbackFailed) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _fallbackFailed = true;
              });
            }
          });
        }

        return _buildErrorWidget();
      },
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      height: widget.height,
      width: widget.width,
      color: Colors.grey[200],
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.broken_image, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 8),
          Text(
            'Gagal memuat gambar',
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
        ],
      ),
    );
  }
}
