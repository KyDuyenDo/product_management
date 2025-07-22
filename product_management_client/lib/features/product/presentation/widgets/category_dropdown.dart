import 'package:flutter/material.dart';
import 'package:product_management_client/core/utils/theme.dart';
import 'package:product_management_client/features/product/domain/entities/category.dart';

class CategoryDropdown extends StatelessWidget {
  final int? selectedCategory;
  final List<Category> categories;
  final String? errorText;
  final ValueChanged<int?> onChanged;

  const CategoryDropdown({
    super.key,
    required this.selectedCategory,
    required this.categories,
    required this.onChanged,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(),
        const SizedBox(height: 8),
        _buildDropdownContainer(),
        if (errorText != null) _buildErrorText(),
      ],
    );
  }

  Widget _buildLabel() {
    return const Text.rich(
      TextSpan(
        text: 'Category',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
        children: [
          TextSpan(
            text: ' *',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownContainer() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border.all(
          color: errorText != null ? Colors.red : Colors.grey.withOpacity(0.3),
          width: errorText != null ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: selectedCategory,
          hint: Text(
            'Select category',
            style: TextStyle(color: Colors.grey[400], fontSize: 16),
          ),
          isExpanded: true,
          dropdownColor: Colors.white,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: DefaultColors.buttonColor,
          ),
          onChanged: onChanged,
          items:
              categories.map<DropdownMenuItem<int>>((category) {
                return DropdownMenuItem<int>(
                  value: category.id,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(category.name),
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }

  Widget _buildErrorText() {
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 12),
      child: Text(
        errorText!,
        style: const TextStyle(
          color: Colors.red,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
