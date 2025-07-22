import 'package:flutter/material.dart';

class Carousel extends StatefulWidget {
  final bool expandToFill;
  final double? height;
  final double? width;
  final List<String>? images;
  final ValueChanged<int>? onPageChanged;
  final Function(Object error, StackTrace? stackTrace)? onImageLoadError;

  const Carousel({
    super.key,
    this.expandToFill = true,
    this.height,
    this.width,
    this.images,
    this.onPageChanged,
    this.onImageLoadError,
  });

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  static const List<String> _defaultImages = [
    'https://images.squarespace-cdn.com/content/v1/53883795e4b016c956b8d243/1568455300105-1X8EOW3FLT27EN19OO30/chup-anh-san-pham-shynh2019-4.jpg',
    'https://www.chuphinhsanpham.vn/wp-content/uploads/2019/07/studio-chup-anh-my-pham-tphcm-1.jpg',
    'https://juro.com.vn/wp-content/uploads/chup-anh-san-pham-my-pham.jpg',
  ];

  List<String> get _effectiveImages => widget.images ?? _defaultImages;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
    widget.onPageChanged?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    final content = Stack(
      children: [
        PageView.builder(
          controller: _pageController,
          itemCount: _effectiveImages.length,
          onPageChanged: _onPageChanged,
          itemBuilder: (context, index) {
            return Image.network(
              _effectiveImages[index],
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: const Color(0xFFEEEEEE),
                  child: Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                widget.onImageLoadError?.call(error, stackTrace);
                return Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: const Color(0xFFE0E0E0),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 48, color: Colors.grey),
                        SizedBox(height: 8),
                        Text('Failed to load image', style: TextStyle(color: Colors.grey, fontSize: 14)),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
        Positioned(
          bottom: 30,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_effectiveImages.length, (index) {
              final isActive = _currentIndex == index;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: isActive ? 12 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: isActive ? 1.0 : 0.5),
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );

    if (widget.expandToFill && _isInFlexWidget()) {
      return Expanded(child: content);
    } else {
      return SizedBox(
        width: widget.width ?? double.infinity,
        height: widget.height ?? double.infinity,
        child: content,
      );
    }
  }

  bool _isInFlexWidget() {
    try {
      return context.findAncestorWidgetOfExactType<Flex>() != null ||
          context.findAncestorWidgetOfExactType<Column>() != null ||
          context.findAncestorWidgetOfExactType<Row>() != null;
    } catch (e) {
      return false;
    }
  }
}
