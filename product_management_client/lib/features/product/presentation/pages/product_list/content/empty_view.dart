import 'package:flutter/material.dart';

class ProductListEmptyView extends StatelessWidget {
  const ProductListEmptyView({super.key, this.searchQuery});

  final String? searchQuery;

  static const double _iconSize = 64.0;
  static const double _spacing = 16.0;
  static const String _noProductsFoundText = 'No products found';
  static const String _noProductsForQueryPrefix = 'No products found for "';
  static const String _noProductsForQuerySuffix = '"';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildEmptyIcon(),
          const SizedBox(height: _spacing),
          _buildEmptyMessage(context),
        ],
      ),
    );
  }

  Widget _buildEmptyIcon() {
    return Icon(Icons.search_off, size: _iconSize, color: Colors.grey[400]);
  }

  Widget _buildEmptyMessage(BuildContext context) {
    final message = _getEmptyMessage();
    return Text(
      message,
      style: Theme.of(context).textTheme.titleMedium,
      textAlign: TextAlign.center,
    );
  }

  String _getEmptyMessage() {
    if (searchQuery?.isNotEmpty == true) {
      return '$_noProductsForQueryPrefix$searchQuery$_noProductsForQuerySuffix';
    }
    return _noProductsFoundText;
  }
}
