import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  const GradientBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final gradientColors = isDark
        ? [
            colors.surface, // base oscuro
            colors.surfaceContainerHigh, // transición
            colors.primary.withOpacity(0.3), // glow azul
          ]
        : [
            colors.primary,
            colors.primary.withOpacity(0.85),
            colors.surface.withOpacity(0.95),
          ];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: child,
    );
  }
}