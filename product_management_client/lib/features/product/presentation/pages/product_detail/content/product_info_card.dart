import 'package:flutter/material.dart';

class ProductInfoCard extends StatelessWidget {
  const ProductInfoCard({super.key, required this.product});

  final dynamic product;

  static const double _containerMargin = 20.0;
  static const double _containerPadding = 24.0;
  static const double _borderRadius = 20.0;
  static const double _iconBorderRadius = 10.0;
  static const double _spacing = 16.0;
  static const double _smallSpacing = 12.0;
  static const double _iconPadding = 8.0;
  static const double _iconSize = 20.0;
  static const double _shadowBlurRadius = 10.0;
  static const double _shadowOffset = 5.0;
  static const double _shadowOpacity = 0.05;
  static const double _backgroundOpacity = 0.1;
  static const double _lineHeight = 1.6;

  static const String _productDescriptionTitle = 'Product Description';

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: _containerMargin),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(_iconPadding),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: _backgroundOpacity),
                  borderRadius: BorderRadius.circular(_iconBorderRadius),
                ),
                child: const Icon(
                  Icons.description_outlined,
                  color: Colors.blue,
                  size: _iconSize,
                ),
              ),
              const SizedBox(width: _smallSpacing),
              Text(
                _productDescriptionTitle,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: _spacing),
          Text(
            product.description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.grey[700],
              height: _lineHeight,
            ),
          ),
        ],
      ),
    );
  }
}
