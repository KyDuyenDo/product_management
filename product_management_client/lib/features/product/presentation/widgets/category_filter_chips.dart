import 'package:flutter/material.dart';
import 'package:product_management_client/core/utils/theme.dart';
import '../../domain/entities/category.dart';

class CategoryFilterChips extends StatefulWidget {
  final List<Category> categories;
  final int? selectedCategoryId; // External state (after data loads)
  final Function(int?) onCategorySelected;
  final bool isProductsLoading;
  final EdgeInsets? padding;
  final double? height;

  const CategoryFilterChips({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.onCategorySelected,
    this.isProductsLoading = false,
    this.padding,
    this.height = 50,
  });

  @override
  State<CategoryFilterChips> createState() => _CategoryFilterChipsState();
}

class _CategoryFilterChipsState extends State<CategoryFilterChips> {
  int? _internalSelectedId; // Internal state for quick UI feedback

  static const double _chipSpacing = 8.0;
  static const double _chipBorderRadius = 20.0;
  static const double _selectedOpacity = 0.2;
  static const EdgeInsets _defaultPadding = EdgeInsets.symmetric(
    horizontal: 16,
  );

  @override
  void initState() {
    super.initState();
    _internalSelectedId = widget.selectedCategoryId;
  }

  @override
  void didUpdateWidget(CategoryFilterChips oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!widget.isProductsLoading && oldWidget.isProductsLoading) {
      _internalSelectedId = widget.selectedCategoryId;
    } else if (widget.selectedCategoryId != oldWidget.selectedCategoryId) {
      _internalSelectedId = widget.selectedCategoryId;
    }
  }

  void _handleCategoryTap(int? categoryId) {
    setState(() {
      _internalSelectedId = categoryId;
    });

    widget.onCategorySelected(categoryId);
  }

  int? get _effectiveSelectedId {
    return widget.isProductsLoading
        ? _internalSelectedId
        : widget.selectedCategoryId;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.categories.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: widget.height ?? 50,
      child: Padding(
        padding: widget.padding ?? _defaultPadding,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            _buildAllCategoriesChip(),
            const SizedBox(width: _chipSpacing),
            ..._buildCategoryChips(),
          ],
        ),
      ),
    );
  }

  Widget _buildAllCategoriesChip() {
    final isSelected = _effectiveSelectedId == null;

    return _buildFilterChip(
      label: 'All',
      isSelected: isSelected,
      onTap: () => _handleCategoryTap(null),
    );
  }

  List<Widget> _buildCategoryChips() {
    return widget.categories.asMap().entries.map((entry) {
      final index = entry.key;
      final category = entry.value;
      final isSelected = _effectiveSelectedId == category.id;
      final isLast = index == widget.categories.length - 1;

      return Container(
        margin: EdgeInsets.only(right: isLast ? 0 : _chipSpacing),
        child: _buildFilterChip(
          label: category.name,
          isSelected: isSelected,
          onTap: () => _handleCategoryTap(category.id),
        ),
      );
    }).toList();
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      selectedColor: DefaultColors.buttonColor.withValues(
        alpha: _selectedOpacity,
      ),
      checkmarkColor: DefaultColors.buttonColor,
      backgroundColor: Colors.grey.shade100,
      disabledColor: Colors.grey.shade200,
      side: BorderSide(
        color: isSelected ? DefaultColors.buttonColor : Colors.grey.shade300,
        width: isSelected ? 2 : 1,
      ),
      labelStyle: TextStyle(
        color: isSelected ? DefaultColors.buttonColor : Colors.grey.shade700,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_chipBorderRadius),
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
      // Show loading state subtly
      elevation: widget.isProductsLoading && isSelected ? 1 : 0,
    );
  }
}
