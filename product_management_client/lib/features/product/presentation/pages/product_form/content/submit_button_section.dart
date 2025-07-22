import 'package:flutter/material.dart';
import 'package:product_management_client/core/utils/theme.dart';

class SubmitButtonSection extends StatelessWidget {
  final String submitButtonText;
  final VoidCallback onSubmit;

  static const double _buttonHeight = 56.0;
  static const double _borderRadius = 16.0;
  static const double _horizontalMargin = 20.0;
  static const double _iconSize = 20.0;
  static const double _spacingSmall = 8.0;
  static const double _fontSize = 16.0;
  static const double _letterSpacing = 0.5;

  const SubmitButtonSection({
    super.key,
    required this.submitButtonText,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: _horizontalMargin),
      width: double.infinity,
      height: _buttonHeight,
      child: ElevatedButton(
        onPressed: onSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: DefaultColors.buttonColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_borderRadius),
          ),
          elevation: 0,
          shadowColor: DefaultColors.buttonColor.withValues(alpha: 0.3),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.save_outlined, size: _iconSize),
            const SizedBox(width: _spacingSmall),
            Text(
              submitButtonText,
              style: const TextStyle(
                fontSize: _fontSize,
                fontWeight: FontWeight.w600,
                letterSpacing: _letterSpacing,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
