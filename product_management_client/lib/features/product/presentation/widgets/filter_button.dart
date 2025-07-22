import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_management_client/core/utils/theme.dart';
import 'package:product_management_client/features/product/presentation/bloc/product_list_bloc/product_list_bloc.dart';
import 'package:product_management_client/features/product/presentation/bloc/product_list_bloc/product_list_event.dart';

class FilterButton extends StatelessWidget {
  const FilterButton({
    super.key,
    this.enabled = true,
    this.iconColor,
    this.backgroundColor,
    this.currentSortType = ProductSortType.none,
    this.onClearSearch,
  });

  final bool enabled;
  final Color? iconColor;
  final Color? backgroundColor;
  final ProductSortType currentSortType;
  final VoidCallback? onClearSearch;

  static const double containerHeight = 40.0;
  static const double containerWidth = 40.0;
  static const double containerBorderRadius = 6.0;
  static const double iconSize = 20.0;
  static const double shadowSpreadRadius = 1.0;
  static const double shadowBlurRadius = 3.0;
  static const double shadowOffsetX = 0.0;
  static const double shadowOffsetY = 2.0;
  static const double shadowAlpha = 0.15;
  static const double disabledOpacity = 0.5;
  static const double popupMaxHeight = 300.0;
  static const double popupWidth = 250.0;

  static const Color defaultIconColor = Colors.white;
  static const Color shadowColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: containerHeight,
      width: containerWidth,
      decoration: _buildContainerDecoration(),
      child: _buildPopupMenuButton(context),
    );
  }

  BoxDecoration _buildContainerDecoration() {
    return BoxDecoration(
      color: backgroundColor ?? DefaultColors.buttonColor,
      borderRadius: BorderRadius.circular(containerBorderRadius),
      boxShadow: enabled ? _buildBoxShadow() : null,
    );
  }

  List<BoxShadow> _buildBoxShadow() {
    return [
      BoxShadow(
        color: shadowColor.withValues(alpha: shadowAlpha),
        spreadRadius: shadowSpreadRadius,
        blurRadius: shadowBlurRadius,
        offset: const Offset(shadowOffsetX, shadowOffsetY),
      ),
    ];
  }

  Widget _buildPopupMenuButton(BuildContext context) {
    return PopupMenuButton<String>(
      enabled: enabled,
      icon: Icon(
        Icons.sort,
        size: iconSize,
        color:
            enabled
                ? (iconColor ?? defaultIconColor)
                : (iconColor ?? defaultIconColor).withValues(
                  alpha: disabledOpacity,
                ),
      ),
      offset: const Offset(0, containerHeight + 5),
      constraints: const BoxConstraints(
        maxHeight: popupMaxHeight,
        maxWidth: popupWidth,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      elevation: 8,
      itemBuilder:
          (context) => [
            ...ProductSortType.values.map(
              (sortType) => PopupMenuItem<String>(
                value: 'sort_${sortType.name}',
                child: Row(
                  children: [
                    Icon(
                      currentSortType == sortType
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      color:
                          currentSortType == sortType
                              ? DefaultColors.buttonColor
                              : Colors.grey,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Icon(sortType.icon, size: 18, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        sortType.displayName,
                        style: TextStyle(
                          color:
                              currentSortType == sortType
                                  ? DefaultColors.buttonColor
                                  : Colors.black87,
                          fontWeight:
                              currentSortType == sortType
                                  ? FontWeight.w500
                                  : FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const PopupMenuDivider(),

            PopupMenuItem<String>(
              value: 'clear_sort',
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: const Row(
                  children: [
                    Icon(Icons.clear, color: Colors.red, size: 20),
                    SizedBox(width: 12),
                    Icon(Icons.refresh, size: 18, color: Colors.red),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Clear sorting',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
      onSelected: (value) {
        if (value.startsWith('sort_')) {
          final sortTypeName = value.substring(5);
          final sortType = ProductSortType.values.firstWhere(
            (type) => type.name == sortTypeName,
            orElse: () => ProductSortType.none,
          );
          context.read<ProductListBloc>().add(SortProductsEvent(sortType));
        } else if (value == 'clear_sort') {
          context.read<ProductListBloc>().add(
            SortProductsEvent(ProductSortType.none),
          );
          if (onClearSearch != null) {
            onClearSearch!();
          }
        }
      },
    );
  }
}
