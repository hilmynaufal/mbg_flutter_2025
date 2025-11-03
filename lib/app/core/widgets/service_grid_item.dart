import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ServiceGridItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? backgroundColor;
  final bool showDescription;
  final bool showNewBadge;

  const ServiceGridItem({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
    this.iconColor,
    this.backgroundColor,
    this.showDescription = true,
    this.showNewBadge = false,
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
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon Container
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: effectiveBgColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: FaIcon(icon, size: 20, color: effectiveIconColor),
                    ),
                  ),
                  const SizedBox(height: 6),

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

            // NEW Badge
            if (showNewBadge)
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'NEW',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
