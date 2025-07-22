import 'package:flutter/material.dart';

class ProductDetailEmptyView extends StatelessWidget {
  const ProductDetailEmptyView({super.key});

  static const double _iconSize = 64.0;
  static const double _spacing = 16.0;
  static const double _fontSize = 18.0;
  static const double _backgroundOpacity = 0.1;

  static const String _noDataText = 'No product data available';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.grey.withValues(alpha: _backgroundOpacity),
            Colors.white,
          ],
        ),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_outlined, size: _iconSize, color: Colors.grey),
            SizedBox(height: _spacing),
            Text(
              _noDataText,
              style: TextStyle(
                fontSize: _fontSize,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
