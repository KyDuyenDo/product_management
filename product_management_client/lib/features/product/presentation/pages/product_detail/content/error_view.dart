import 'package:flutter/material.dart';
import 'package:product_management_client/core/utils/theme.dart';

class ProductDetailErrorView extends StatelessWidget {
  const ProductDetailErrorView({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  static const double _containerMargin = 20.0;
  static const double _containerPadding = 24.0;
  static const double _borderRadius = 20.0;
  static const double _circularBorderRadius = 50.0;
  static const double _iconSize = 48.0;
  static const double _spacing = 20.0;
  static const double _smallSpacing = 12.0;
  static const double _largeSpacing = 24.0;
  static const double _shadowBlurRadius = 10.0;
  static const double _shadowOffset = 5.0;
  static const double _shadowOpacity = 0.1;
  static const double _backgroundOpacity = 0.1;
  static const double _iconPadding = 16.0;
  static const double _buttonPadding = 12.0;
  static const double _buttonHorizontalPadding = 24.0;

  static const String _errorTitle = 'Oops! Something went wrong';
  static const String _tryAgainText = 'Try Again';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.red.withValues(alpha: _backgroundOpacity),
            Colors.white,
          ],
        ),
      ),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(_containerMargin),
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
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(_iconPadding),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: _backgroundOpacity),
                  borderRadius: BorderRadius.circular(_circularBorderRadius),
                ),
                child: Icon(
                  Icons.error_outline,
                  size: _iconSize,
                  color: Colors.red[400],
                ),
              ),
              const SizedBox(height: _spacing),
              Text(
                _errorTitle,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: _smallSpacing),
              Text(
                message,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: _largeSpacing),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text(_tryAgainText),
                style: ElevatedButton.styleFrom(
                  backgroundColor: DefaultColors.buttonColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: _buttonHorizontalPadding,
                    vertical: _buttonPadding,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(_buttonPadding),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
