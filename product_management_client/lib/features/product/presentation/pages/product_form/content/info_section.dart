import 'package:flutter/material.dart';
import 'package:product_management_client/core/utils/theme.dart';
import 'package:product_management_client/features/product/presentation/widgets/custom_field_with_validation.dart';

class BasicInfoSection extends StatelessWidget {
  final TextEditingController productNameController;
  final TextEditingController descriptionController;
  final String? Function(String?) productNameValidator;
  final String? Function(String?) descriptionValidator;

  static const String _sectionTitle = 'Basic Information';
  static const String _productNameLabel = 'Product Name';
  static const String _descriptionLabel = 'Description';
  static const String _productNamePlaceholder =
      'Enter product name (e.g., iPhone 15 Pro)';
  static const String _descriptionPlaceholder =
      'Enter detailed product description...';
  static const double _sectionPadding = 24.0;
  static const double _borderRadius = 20.0;
  static const double _iconPadding = 8.0;
  static const double _iconSize = 20.0;
  static const double _spacingSmall = 12.0;
  static const double _spacingBetweenFields = 12.0;

  const BasicInfoSection({
    super.key,
    required this.productNameController,
    required this.descriptionController,
    required this.productNameValidator,
    required this.descriptionValidator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
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
          const SizedBox(height: 20.0),
          CustomTextFieldWithValidation(
            controller: productNameController,
            label: _productNameLabel,
            placeholder: _productNamePlaceholder,
            validator: productNameValidator,
            maxLength: 100,
          ),
          const SizedBox(height: _spacingBetweenFields),
          CustomTextFieldWithValidation(
            controller: descriptionController,
            label: _descriptionLabel,
            placeholder: _descriptionPlaceholder,
            maxLines: 4,
            maxLength: 500,
            validator: descriptionValidator,
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
            Icons.info_outline,
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
}
