import 'package:flutter/material.dart';
import 'package:product_management_client/core/utils/theme.dart';
import 'package:product_management_client/features/product/presentation/bloc/product_list_bloc/product_list_event.dart';
import 'package:product_management_client/features/product/presentation/widgets/search_field.dart';
import 'package:product_management_client/features/product/presentation/widgets/filter_button.dart';

class ProductListSearchSection extends StatelessWidget {
  const ProductListSearchSection({
    super.key,
    required this.searchController,
    required this.onSearch,
    required this.onClearSearch,
    this.searchQuery,
    this.sortType,
    this.padding,
  });

  final TextEditingController searchController;
  final VoidCallback onSearch;
  final VoidCallback onClearSearch;
  final String? searchQuery;
  final ProductSortType? sortType;
  final EdgeInsets? padding;

  // Constants
  static const double _buttonSpacing = 8.0;
  static const double _clearButtonFontSize = 14.0;
  static const FontWeight _clearButtonFontWeight = FontWeight.w500;
  static const String _clearButtonText = 'Clear';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Row(
        children: [
          Expanded(child: _buildSearchField()),
          const SizedBox(width: _buttonSpacing),
          if (_shouldShowClearButton()) _buildClearButton(),
          const SizedBox(width: _buttonSpacing),
          _buildFilterButton(),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return SearchField(
      controller: searchController,
      onChanged: (query) {},
      onSearch: onSearch,
    );
  }

  bool _shouldShowClearButton() {
    return searchQuery?.isNotEmpty == true;
  }

  Widget _buildClearButton() {
    return TextButton(
      onPressed: onClearSearch,
      style: TextButton.styleFrom(
        foregroundColor: DefaultColors.buttonColor,
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: const Text(
        _clearButtonText,
        style: TextStyle(
          fontSize: _clearButtonFontSize,
          fontWeight: _clearButtonFontWeight,
        ),
      ),
    );
  }

  Widget _buildFilterButton() {
    return FilterButton(
      currentSortType: sortType ?? ProductSortType.none,
      onClearSearch: onClearSearch,
    );
  }
}
