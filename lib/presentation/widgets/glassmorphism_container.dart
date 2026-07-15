import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class GlassmorphismContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final double blur;
  final double opacity;
  final Color? borderColor;
  final Color? tintColor;

  const GlassmorphismContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius = 16,
    this.blur = 20,
    this.opacity = 0.15,
    this.borderColor,
    this.tintColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultTint = tintColor ?? (isDark ? Colors.white : Colors.black);
    final defaultBorder = borderColor ?? (isDark ? Colors.white24 : Colors.black12);

    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: defaultTint.withOpacity(opacity),
        border: Border.all(color: defaultBorder.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: defaultTint.withOpacity(0.05),
            blurRadius: blur,
            spreadRadius: -blur / 4,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: child,
        ),
      ),
    );
  }
}
