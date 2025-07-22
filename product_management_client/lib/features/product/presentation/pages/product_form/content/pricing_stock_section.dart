import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:product_management_client/core/utils/theme.dart';
import 'package:product_management_client/features/product/domain/entities/category.dart';
import 'package:product_management_client/features/product/presentation/widgets/category_dropdown.dart';
import 'package:product_management_client/features/product/presentation/widgets/custom_field_with_validation.dart';

class PricingStockSection extends StatelessWidget {
  final TextEditingController priceController;
  final TextEditingController stockController;
  final int? selectedCategory;
  final List<Category> categories;
  final String? categoryError;
  final String? Function(String?) priceValidator;
  final String? Function(String?) stockValidator;
  final ValueChanged<int?> onCategoryChanged;

  static const String _sectionTitle = 'Pricing & Stock';
  static const String _priceLabel = 'Price (\$)';
  static const String _stockLabel = 'Stock Quantity';
  static const String _pricePlaceholder = 'Enter price (e.g., 25000)';
  static const String _stockPlaceholder = 'Enter stock quantity (e.g., 100)';
  static const double _sectionPadding = 24.0;
  static const double _borderRadius = 20.0;
  static const double _iconPadding = 8.0;
  static const double _iconSize = 20.0;
  static const double _spacingSmall = 12.0;
  static const double _spacingBetweenFields = 12.0;
  static const double _spacingLarge = 20.0;

  const PricingStockSection({
    super.key,
    required this.priceController,
    required this.stockController,
    required this.selectedCategory,
    required this.categories,
    required this.categoryError,
    required this.priceValidator,
    required this.stockValidator,
    required this.onCategoryChanged,
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
          _buildPriceField(),
          const SizedBox(height: _spacingBetweenFields),
          _buildStockField(),
          const SizedBox(height: _spacingLarge),
          CategoryDropdown(
            selectedCategory: selectedCategory,
            categories: categories,
            errorText: categoryError,
            onChanged: onCategoryChanged,
          ),
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
            Icons.attach_money_outlined,
            color: DefaultColors.buttonColor,
            size: _iconSize,
          ),
        ),
        const SizedBox(width: _spacingSmall),
        Text(
          _sectionTitle,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildPriceField() {
    return CustomTextFieldWithValidation(
      controller: priceController,
      label: _priceLabel,
      placeholder: _pricePlaceholder,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: priceValidator,
    );
  }

  Widget _buildStockField() {
    return CustomTextFieldWithValidation(
      controller: stockController,
      label: _stockLabel,
      placeholder: _stockPlaceholder,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: stockValidator,
    );
  }
}
