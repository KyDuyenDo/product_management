import 'package:flutter/material.dart';
import 'package:product_management_client/core/utils/theme.dart';

class ProductListErrorView extends StatelessWidget {
  const ProductListErrorView({
    super.key,
    required this.errorMessage,
    this.onRetry,
  });

  final String errorMessage;
  final VoidCallback? onRetry;

  static const double _iconSize = 64.0;
  static const double _spacing = 16.0;
  static const String _errorPrefix = 'Error: ';
  static const String _retryButtonText = 'Retry';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildErrorIcon(),
          const SizedBox(height: _spacing),
          _buildErrorMessage(context),
          const SizedBox(height: _spacing),
          if (onRetry != null) _buildRetryButton(),
        ],
      ),
    );
  }

  Widget _buildErrorIcon() {
    return Icon(Icons.error_outline, size: _iconSize, color: Colors.red[300]);
  }

  Widget _buildErrorMessage(BuildContext context) {
    return Text(
      '$_errorPrefix$errorMessage',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.titleMedium,
    );
  }

  Widget _buildRetryButton() {
    return ElevatedButton(
      onPressed: onRetry,
      style: ElevatedButton.styleFrom(
        backgroundColor: DefaultColors.buttonColor,
        foregroundColor: Colors.white,
      ),
      child: const Text(_retryButtonText),
    );
  }
}
