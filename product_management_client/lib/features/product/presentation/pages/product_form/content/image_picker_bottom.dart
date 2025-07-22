import 'package:flutter/material.dart';
import 'package:product_management_client/core/utils/theme.dart';

class ImagePickerBottomSheet extends StatelessWidget {
  final VoidCallback onCameraSelected;
  final VoidCallback onGallerySelected;

  static const String _title = 'Select Image Source';
  static const String _cameraTitle = 'Camera';
  static const String _cameraSubtitle = 'Take a photo with camera';
  static const String _galleryTitle = 'Gallery';
  static const String _gallerySubtitle = 'Choose from gallery';
  static const double _borderRadius = 20.0;
  static const double _handleWidth = 40.0;
  static const double _handleHeight = 4.0;
  static const double _handleTopMargin = 12.0;
  static const double _contentPadding = 20.0;
  static const double _optionMargin = 8.0;
  static const double _optionPadding = 16.0;
  static const double _optionBorderRadius = 16.0;
  static const double _iconContainerPadding = 12.0;
  static const double _iconSize = 24.0;
  static const double _spacingSmall = 4.0;
  static const double _spacingMedium = 16.0;
  static const double _spacingLarge = 20.0;
  static const double _arrowIconSize = 16.0;

  const ImagePickerBottomSheet({
    super.key,
    required this.onCameraSelected,
    required this.onGallerySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(_borderRadius),
          topRight: Radius.circular(_borderRadius),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHandle(),
            const SizedBox(height: _spacingLarge),
            _buildTitle(context),
            const SizedBox(height: _spacingLarge),
            _buildImageSourceOption(
              context,
              Icons.photo_camera_outlined,
              _cameraTitle,
              _cameraSubtitle,
              onCameraSelected,
            ),
            _buildImageSourceOption(
              context,
              Icons.photo_library_outlined,
              _galleryTitle,
              _gallerySubtitle,
              onGallerySelected,
            ),
            const SizedBox(height: _spacingLarge),
          ],
        ),
      ),
    );
  }

  Widget _buildHandle() {
    return Container(
      width: _handleWidth,
      height: _handleHeight,
      margin: const EdgeInsets.only(top: _handleTopMargin),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      _title,
      style: Theme.of(
        context,
      ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildImageSourceOption(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: _contentPadding,
        vertical: _optionMargin,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(_optionBorderRadius),
        child: Container(
          padding: const EdgeInsets.all(_optionPadding),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[200]!),
            borderRadius: BorderRadius.circular(_optionBorderRadius),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(_iconContainerPadding),
                decoration: BoxDecoration(
                  color: DefaultColors.buttonColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: DefaultColors.buttonColor,
                  size: _iconSize,
                ),
              ),
              const SizedBox(width: _spacingMedium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: _spacingSmall),
                    Text(
                      subtitle,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey[400],
                size: _arrowIconSize,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
