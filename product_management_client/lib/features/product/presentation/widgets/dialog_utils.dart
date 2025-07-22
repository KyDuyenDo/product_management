import 'package:flutter/material.dart';
import 'package:product_management_client/features/product/presentation/widgets/custom_dialog.dart';

class DialogUtils {
  static Future<void> showProductCreated(BuildContext context) {
    return CustomDialog.showSuccess(
      context: context,
      title: 'Success',
      message:
          'Product has been created successfully and is now available in your inventory.',
    );
  }

  static Future<void> showProductUpdated(BuildContext context) {
    return CustomDialog.showSuccess(
      context: context,
      title: 'Success',
      message: 'Product information has been updated successfully.',
    );
  }

  static Future<void> showProductDeleted(BuildContext context) {
    return CustomDialog.showSuccess(
      context: context,
      title: 'Success',
      message: 'Product has been deleted successfully from your inventory.',
    );
  }

  static Future<void> showImagesUploaded(BuildContext context) {
    return CustomDialog.showSuccess(
      context: context,
      title: 'Success',
      message: 'Product images have been uploaded successfully.',
    );
  }

  static Future<void> showNetworkError(
    BuildContext context, {
    VoidCallback? onRetry,
  }) {
    return CustomDialog.showError(
      context: context,
      title: 'Network Error',
      message:
          'Unable to connect to the server. Please check your internet connection and try again.',
      onTryAgain: onRetry,
    );
  }

  static Future<void> showServerError(
    BuildContext context, {
    VoidCallback? onRetry,
  }) {
    return CustomDialog.showError(
      context: context,
      title: 'Server Error',
      message:
          'Something went wrong on our end. Please try again in a few moments.',
      onTryAgain: onRetry,
    );
  }

  static Future<void> showValidationError(
    BuildContext context,
    String message,
  ) {
    return CustomDialog.showError(
      context: context,
      title: 'Validation Error',
      message: message,
      primaryButtonText: 'OK',
    );
  }

  static Future<void> showProductNotFound(BuildContext context) {
    return CustomDialog.showError(
      context: context,
      title: 'Product Not Found',
      message:
          'The requested product could not be found. It may have been deleted or moved.',
      primaryButtonText: 'OK',
    );
  }

  static Future<void> showImageUploadError(
    BuildContext context, {
    VoidCallback? onRetry,
  }) {
    return CustomDialog.showError(
      context: context,
      title: 'Upload Failed',
      message:
          'Failed to upload product images. Please check your connection and try again.',
      onTryAgain: onRetry,
    );
  }

  static Future<void> showProductDeleteFail(
    BuildContext context, {
    VoidCallback? onRetry,
  }) {
    return CustomDialog.showError(
      context: context,
      title: 'Delete Failed',
      message:
          'Failed to delete product. Please check your connection and try again.',
      onTryAgain: onRetry,
    );
  }

  static Future<bool?> showDeleteConfirmation(
    BuildContext context, {
    required String itemName,
    VoidCallback? onConfirm,
  }) {
    return CustomDialog.showWarning(
      context: context,
      title: 'Delete Product',
      message:
          'Are you sure you want to delete "$itemName"? This action cannot be undone.',
      primaryButtonText: 'Delete',
      secondaryButtonText: 'Cancel',
      onConfirm: onConfirm,
    );
  }

  static Future<bool?> showUnsavedChanges(BuildContext context) {
    return CustomDialog.showWarning(
      context: context,
      title: 'Unsaved Changes',
      message:
          'You have unsaved changes. Are you sure you want to leave without saving?',
      primaryButtonText: 'Leave',
      secondaryButtonText: 'Stay',
    );
  }

  static Future<bool?> showClearFormConfirmation(BuildContext context) {
    return CustomDialog.showWarning(
      context: context,
      title: 'Clear Form',
      message:
          'Are you sure you want to clear all form data? This action cannot be undone.',
      primaryButtonText: 'Clear',
      secondaryButtonText: 'Cancel',
    );
  }

  static Future<bool?> showLogoutConfirmation(BuildContext context) {
    return CustomDialog.showWarning(
      context: context,
      title: 'Logout',
      message:
          'Are you sure you want to logout? You will need to sign in again to access your account.',
      primaryButtonText: 'Logout',
      secondaryButtonText: 'Cancel',
    );
  }

  static Future<void> showGenericError(
    BuildContext context, {
    String? title,
    String? message,
    VoidCallback? onRetry,
  }) {
    return CustomDialog.showError(
      context: context,
      title: title ?? 'Error',
      message: message ?? 'An unexpected error occurred. Please try again.',
      onTryAgain: onRetry,
    );
  }

  static Future<void> showGenericSuccess(
    BuildContext context, {
    String? title,
    String? message,
    VoidCallback? onContinue,
  }) {
    return CustomDialog.showSuccess(
      context: context,
      title: title ?? 'Success',
      message: message ?? 'Operation completed successfully.',
      onContinue: onContinue,
    );
  }

  static Future<bool?> showGenericWarning(
    BuildContext context, {
    String? title,
    String? message,
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
  }) {
    return CustomDialog.showWarning(
      context: context,
      title: title ?? 'Warning',
      message: message ?? 'Are you sure you want to continue?',
      primaryButtonText: confirmText ?? 'Confirm',
      secondaryButtonText: cancelText ?? 'Cancel',
      onConfirm: onConfirm,
    );
  }

  static Future<bool?> showConfirmDeleteProduct(
    BuildContext context, {
    String? title,
    String? message,
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
  }) {
    return CustomDialog.showWarning(
      context: context,
      title: title ?? 'Delete Product',
      message: message ?? 'Are you sure you want to delete this product?',
      primaryButtonText: confirmText ?? 'Delete',
      secondaryButtonText: cancelText ?? 'Cancel',
      onConfirm: onConfirm,
    );
  }
}
