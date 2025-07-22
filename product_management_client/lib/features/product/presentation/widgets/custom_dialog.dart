import 'package:flutter/material.dart';

enum DialogType { success, error, warning }

class CustomDialog extends StatelessWidget {
  final DialogType type;
  final String title;
  final String message;
  final String primaryButtonText;
  final String? secondaryButtonText;
  final VoidCallback? onPrimaryPressed;
  final VoidCallback? onSecondaryPressed;
  final bool barrierDismissible;

  const CustomDialog({
    super.key,
    required this.type,
    required this.title,
    required this.message,
    required this.primaryButtonText,
    this.secondaryButtonText,
    this.onPrimaryPressed,
    this.onSecondaryPressed,
    this.barrierDismissible = true,
  });

  static Future<bool?> showSuccess({
    required BuildContext context,
    required String title,
    required String message,
    String primaryButtonText = 'Continue',
    VoidCallback? onContinue,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder:
          (context) => CustomDialog(
            type: DialogType.success,
            title: title,
            message: message,
            primaryButtonText: primaryButtonText,
            onPrimaryPressed: () {
              Navigator.of(context).pop(true);
              onContinue?.call();
            },
          ),
    );
  }

  static Future<bool?> showError({
    required BuildContext context,
    required String title,
    required String message,
    String primaryButtonText = 'Try Again',
    VoidCallback? onTryAgain,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder:
          (context) => CustomDialog(
            type: DialogType.error,
            title: title,
            message: message,
            primaryButtonText: primaryButtonText,
            onPrimaryPressed: () {
              Navigator.of(context).pop(true);
              onTryAgain?.call();
            },
          ),
    );
  }

  static Future<bool?> showWarning({
    required BuildContext context,
    required String title,
    required String message,
    String primaryButtonText = 'Confirm',
    String secondaryButtonText = 'Cancel',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder:
          (context) => CustomDialog(
            type: DialogType.warning,
            title: title,
            message: message,
            primaryButtonText: primaryButtonText,
            secondaryButtonText: secondaryButtonText,
            onPrimaryPressed: () {
              Navigator.of(context).pop(true);
              onConfirm?.call();
            },
            onSecondaryPressed: () {
              Navigator.of(context).pop(false);
              onCancel?.call();
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 340),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildIcon(),
              const SizedBox(height: 20),
              _buildTitle(),
              const SizedBox(height: 12),
              _buildMessage(),
              const SizedBox(height: 28),
              _buildButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    late Color backgroundColor;
    late Color iconColor;
    late IconData iconData;

    switch (type) {
      case DialogType.success:
        backgroundColor = const Color(0xFF4CAF50);
        iconColor = Colors.white;
        iconData = Icons.check;
        break;
      case DialogType.error:
        backgroundColor = const Color(0xFFF44336);
        iconColor = Colors.white;
        iconData = Icons.close;
        break;
      case DialogType.warning:
        backgroundColor = const Color(0xFFFF9800);
        iconColor = Colors.white;
        iconData = Icons.warning_outlined;
        break;
    }

    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(color: backgroundColor, shape: BoxShape.circle),
      child: Icon(iconData, color: iconColor, size: 32),
    );
  }

  Widget _buildTitle() {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Color(0xFF1A1A1A),
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildMessage() {
    return Text(
      message,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Color(0xFF666666),
        height: 1.4,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildButtons() {
    if (secondaryButtonText != null) {
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: onPrimaryPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: _getPrimaryButtonColor(),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                primaryButtonText,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton(
              onPressed: onSecondaryPressed,
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF666666),
                side: const BorderSide(color: Color(0xFFE0E0E0), width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                secondaryButtonText!,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          onPressed: onPrimaryPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: _getPrimaryButtonColor(),
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            primaryButtonText,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      );
    }
  }

  Color _getPrimaryButtonColor() {
    switch (type) {
      case DialogType.success:
        return const Color(0xFF4CAF50);
      case DialogType.error:
        return const Color(0xFFF44336);
      case DialogType.warning:
        return const Color(0xFFFF9800);
    }
  }
}
