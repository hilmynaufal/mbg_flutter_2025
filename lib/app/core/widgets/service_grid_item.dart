import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../theme/app_colors.dart';

class ServiceGridItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? backgroundColor;
  final bool showDescription;

  const ServiceGridItem({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
    this.iconColor,
    this.backgroundColor,
    this.showDescription = true,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveIconColor = Colors.white;
    final effectiveBgColor = iconColor ?? Theme.of(context).colorScheme.primary;

    return Card(
      // elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon Container
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: effectiveBgColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: FaIcon(icon, size: 24, color: effectiveIconColor),
                ),
              ),
              const SizedBox(height: 8),

              // Title
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              // Description (conditional)
              // if (showDescription) ...[
              //   const SizedBox(height: 4),
              //   Text(
              //     description,
              //     style: Theme.of(context).textTheme.bodySmall?.copyWith(
              //       color: AppColors.textSecondary,
              //     ),
              //     textAlign: TextAlign.center,
              //     maxLines: 2,
              //     overflow: TextOverflow.ellipsis,
              //   ),
              // ],
            ],
          ),
        ),
      ),
    );
  }
}
