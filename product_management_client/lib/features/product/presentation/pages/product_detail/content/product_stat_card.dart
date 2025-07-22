import 'package:flutter/material.dart';

class ProductStatCard extends StatelessWidget {
  const ProductStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color color;

  static const double _containerPadding = 20.0;
  static const double _borderRadius = 16.0;
  static const double _iconBorderRadius = 12.0;
  static const double _spacing = 12.0;
  static const double _smallSpacing = 4.0;
  static const double _iconPadding = 12.0;
  static const double _iconSize = 24.0;
  static const double _shadowBlurRadius = 10.0;
  static const double _shadowOffset = 5.0;
  static const double _shadowOpacity = 0.05;
  static const double _backgroundOpacity = 0.1;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(_containerPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: _shadowOpacity),
            blurRadius: _shadowBlurRadius,
            offset: const Offset(0, _shadowOffset),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(_iconPadding),
            decoration: BoxDecoration(
              color: color.withValues(alpha: _backgroundOpacity),
              borderRadius: BorderRadius.circular(_iconBorderRadius),
            ),
            child: Icon(icon, color: color, size: _iconSize),
          ),
          const SizedBox(height: _spacing),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: _smallSpacing),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
