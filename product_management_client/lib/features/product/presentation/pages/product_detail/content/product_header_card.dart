import 'package:flutter/material.dart';
import 'package:product_management_client/core/utils/theme.dart';

class ProductHeaderCard extends StatelessWidget {
  const ProductHeaderCard({super.key, required this.product});

  final dynamic product;

  static const double _containerMargin = 20.0;
  static const double _containerPadding = 24.0;
  static const double _borderRadius = 20.0;
  static const double _categoryBorderRadius = 20.0;
  static const double _priceBorderRadius = 15.0;
  static const double _spacing = 8.0;
  static const double _categoryPadding = 6.0;
  static const double _categoryHorizontalPadding = 12.0;
  static const double _priceVerticalPadding = 8.0;
  static const double _priceHorizontalPadding = 16.0;
  static const double _shadowBlurRadius = 10.0;
  static const double _shadowOffset = 5.0;
  static const double _shadowOpacity = 0.05;
  static const double _backgroundOpacity = 0.1;
  static const double _fontSize = 12.0;
  static const double _priceFontSize = 20.0;

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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: _spacing),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: _categoryHorizontalPadding,
                    vertical: _categoryPadding,
                  ),
                  decoration: BoxDecoration(
                    color: DefaultColors.buttonColor.withValues(
                      alpha: _backgroundOpacity,
                    ),
                    borderRadius: BorderRadius.circular(_categoryBorderRadius),
                  ),
                  child: Text(
                    product.categoryName,
                    style: TextStyle(
                      color: DefaultColors.buttonColor,
                      fontWeight: FontWeight.w600,
                      fontSize: _fontSize,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: _priceHorizontalPadding,
              vertical: _priceVerticalPadding,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  DefaultColors.buttonColor,
                  DefaultColors.highlightTitle,
                ],
              ),
              borderRadius: BorderRadius.circular(_priceBorderRadius),
            ),
            child: Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: _priceFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
