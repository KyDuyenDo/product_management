import 'package:flutter/material.dart';

class MaxImagesSnackBar {
  static const String _warningMessage = 'Maximum 5 images allowed';
  static const double _iconPadding = 6.0;
  static const double _iconBorderRadius = 8.0;
  static const double _iconSize = 20.0;
  static const double _spacingMedium = 12.0;
  static const double _snackBarBorderRadius = 12.0;
  static const double _snackBarMargin = 16.0;
  static const int _durationSeconds = 3;

  static SnackBar build() {
    return SnackBar(
      content: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(_iconPadding),
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(_iconBorderRadius),
            ),
            child: const Icon(
              Icons.warning_outlined,
              color: Colors.orange,
              size: _iconSize,
            ),
          ),
          const SizedBox(width: _spacingMedium),
          const Expanded(
            child: Text(
              _warningMessage,
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_snackBarBorderRadius),
      ),
      margin: const EdgeInsets.all(_snackBarMargin),
      elevation: 8,
      duration: const Duration(seconds: _durationSeconds),
    );
  }
}
