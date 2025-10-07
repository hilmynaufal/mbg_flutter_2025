import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isDisabled;
  final IconData? icon;
  final double? width;
  final double height;
  final double borderRadius;
  final List<Color>? gradientColors;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;

  const GradientButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.width,
    this.height = 50,
    this.borderRadius = 8,
    this.gradientColors,
    this.textStyle,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final bool isButtonDisabled = isDisabled || isLoading || onPressed == null;
    final List<Color> effectiveGradientColors = gradientColors ??
      [AppColors.gradientStart, AppColors.gradientEnd];

    return Container(
      width: width ?? double.infinity,
      height: height,
      decoration: BoxDecoration(
        gradient: isButtonDisabled
            ? null
            : LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: effectiveGradientColors,
              ),
        color: isButtonDisabled ? AppColors.greyLight : null,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: isButtonDisabled
            ? null
            : [
                BoxShadow(
                  color: effectiveGradientColors.first.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isButtonDisabled ? null : onPressed,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Container(
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Center(
              child: isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (icon != null) ...[
                          Icon(
                            icon,
                            color: isButtonDisabled ? AppColors.grey : AppColors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          text,
                          style: textStyle ??
                              TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: isButtonDisabled ? AppColors.grey : AppColors.white,
                                letterSpacing: 0.5,
                              ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

// Variant: Outlined Gradient Button
class OutlinedGradientButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isDisabled;
  final IconData? icon;
  final double? width;
  final double height;
  final double borderRadius;
  final List<Color>? gradientColors;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;

  const OutlinedGradientButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.width,
    this.height = 50,
    this.borderRadius = 8,
    this.gradientColors,
    this.textStyle,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final bool isButtonDisabled = isDisabled || isLoading || onPressed == null;
    final List<Color> effectiveGradientColors = gradientColors ??
      [AppColors.gradientStart, AppColors.gradientEnd];
    final Color gradientColor = effectiveGradientColors.first;

    return Container(
      width: width ?? double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          width: 2,
          color: isButtonDisabled ? AppColors.greyLight : gradientColor,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isButtonDisabled ? null : onPressed,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Container(
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Center(
              child: isLoading
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(gradientColor),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (icon != null) ...[
                          Icon(
                            icon,
                            color: isButtonDisabled ? AppColors.grey : gradientColor,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          text,
                          style: textStyle ??
                              TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: isButtonDisabled ? AppColors.grey : gradientColor,
                                letterSpacing: 0.5,
                              ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
