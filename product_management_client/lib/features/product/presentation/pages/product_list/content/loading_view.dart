import 'package:flutter/material.dart';
import 'package:product_management_client/core/utils/theme.dart';

class ProductListLoadingView extends StatelessWidget {
  const ProductListLoadingView({super.key});

  static const double _spacing = 16.0;
  static const String _loadingText = 'Loading products...';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildLoadingIndicator(),
          const SizedBox(height: _spacing),
          _buildLoadingText(context),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      color: Colors.white,
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(DefaultColors.buttonColor),
        ),
      ),
    );
  }

  Widget _buildLoadingText(BuildContext context) {
    return Text(_loadingText, style: Theme.of(context).textTheme.bodyMedium);
  }
}
