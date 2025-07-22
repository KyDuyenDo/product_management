import 'package:flutter/material.dart';
import 'package:product_management_client/core/utils/theme.dart';
import 'package:product_management_client/features/product/presentation/model/image_item.dart';

class ImagesSection extends StatelessWidget {
  final List<ImageItem> selectedImages;
  final VoidCallback onAddImage;
  final ValueChanged<int> onRemoveImage;

  static const String _sectionTitle = 'Product Images';
  static const String _maxImagesText = 'Maximum 5 images';
  static const String _thumbnailBadge = 'Thumbnail';
  static const double _sectionPadding = 24.0;
  static const double _borderRadius = 20.0;
  static const double _iconPadding = 8.0;
  static const double _iconSize = 20.0;
  static const double _spacingSmall = 12.0;
  static const double _spacingLarge = 20.0;
  static const double _imageSize = 100.0;
  static const double _badgeHeight = 20.0;
  static const double _badgeFontSize = 10.0;
  static const double _removeButtonSize = 24.0;

  const ImagesSection({
    super.key,
    required this.selectedImages,
    required this.onAddImage,
    required this.onRemoveImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: _spacingLarge),
      padding: const EdgeInsets.all(_sectionPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(context),
          const SizedBox(height: _spacingLarge),
          if (selectedImages.isNotEmpty) _buildImageGrid(),
          const SizedBox(height: _spacingSmall),
          _buildAddImageButton(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(_iconPadding),
          decoration: BoxDecoration(
            color: DefaultColors.buttonColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            Icons.photo_library_outlined,
            color: DefaultColors.buttonColor,
            size: _iconSize,
          ),
        ),
        const SizedBox(width: _spacingSmall),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _sectionTitle,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                '$_maxImagesText (${selectedImages.length}/5)',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImageGrid() {
    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: selectedImages.length,
        itemBuilder: (context, index) {
          final imageItem = selectedImages[index];
          final isThumbnail = index == 0;

          return Container(
            margin: const EdgeInsets.only(right: _spacingSmall, top: 10),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                _buildImageContainer(imageItem, isThumbnail),
                _buildRemoveButton(index),
                _buildImageBadges(imageItem, isThumbnail),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildImageContainer(ImageItem imageItem, bool isThumbnail) {
    return Container(
      width: _imageSize,
      height: _imageSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              isThumbnail
                  ? DefaultColors.buttonColor
                  : Colors.grey.withValues(alpha: 0.3),
          width: isThumbnail ? 2 : 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: _buildImageWidget(imageItem),
      ),
    );
  }

  Widget _buildImageWidget(ImageItem imageItem) {
    switch (imageItem.type) {
      case ImageType.existing:
        return Image.network(
          imageItem.url!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey.withValues(alpha: 0.2),
              child: const Icon(
                Icons.broken_image,
                color: Colors.grey,
                size: 40,
              ),
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              color: Colors.grey.withValues(alpha: 0.1),
              child: Center(
                child: CircularProgressIndicator(
                  value:
                      loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                  strokeWidth: 2,
                ),
              ),
            );
          },
        );
      case ImageType.newFile:
        return Image.file(
          imageItem.file!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey.withValues(alpha: 0.2),
              child: const Icon(Icons.error, color: Colors.red, size: 40),
            );
          },
        );
    }
  }

  Widget _buildRemoveButton(int index) {
    return Positioned(
      top: -4,
      right: -4,
      child: GestureDetector(
        onTap: () => onRemoveImage(index),
        child: Container(
          width: _removeButtonSize,
          height: _removeButtonSize,
          decoration: const BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(Icons.close, color: Colors.white, size: 16),
        ),
      ),
    );
  }

  Widget _buildImageBadges(ImageItem imageItem, bool isThumbnail) {
    return Positioned(
      bottom: 4,
      left: 4,
      right: 4,
      child: Column(
        children: [
          if (isThumbnail)
            _buildBadge(_thumbnailBadge, DefaultColors.buttonColor),
          if (isThumbnail) const SizedBox(height: 2),
        ],
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      height: _badgeHeight,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: _badgeFontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildAddImageButton() {
    final canAddMore = selectedImages.length < 5;

    return GestureDetector(
      onTap: canAddMore ? onAddImage : null,
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          border: Border.all(
            color:
                canAddMore
                    ? DefaultColors.buttonColor.withValues(alpha: 0.3)
                    : Colors.grey.withValues(alpha: 0.3),
            width: 2,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(12),
          color:
              canAddMore
                  ? DefaultColors.buttonColor.withValues(alpha: 0.05)
                  : Colors.grey.withValues(alpha: 0.05),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color:
                    canAddMore
                        ? DefaultColors.buttonColor.withValues(alpha: 0.1)
                        : Colors.grey.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.add_photo_alternate_outlined,
                size: 20,
                color: canAddMore ? DefaultColors.buttonColor : Colors.grey,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              canAddMore ? 'Add More Images' : 'Maximum Images Reached',
              style: TextStyle(
                color: canAddMore ? DefaultColors.buttonColor : Colors.grey,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
