import 'package:flutter/material.dart';
import 'product_stat_card.dart';

class ProductStatsRow extends StatelessWidget {
  const ProductStatsRow({super.key, required this.product});

  final dynamic product;

  static const double _containerMargin = 20.0;
  static const double _spacing = 16.0;
  static const double _stockThreshold = 10.0;

  static const String _stockQuantityTitle = 'Stock Quantity';
  static const String _statusTitle = 'Status';

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: _containerMargin),
      child: Row(
        children: [
          Expanded(
            child: ProductStatCard(
              title: _stockQuantityTitle,
              value: '${product.stock}',
              icon: Icons.inventory_2_outlined,
              color:
                  product.stock > _stockThreshold
                      ? Colors.green
                      : Colors.orange,
            ),
          ),
          const SizedBox(width: _spacing),
          Expanded(
            child: ProductStatCard(
              title: _statusTitle,
              value: product.stockStatus,
              icon: Icons.check_circle_outline,
              color:
                  product.stock > _stockThreshold
                      ? Colors.green
                      : Colors.orange,
            ),
          ),
        ],
      ),
    );
  }
}
