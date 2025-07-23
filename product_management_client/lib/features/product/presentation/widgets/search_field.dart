import 'package:flutter/material.dart';

class SearchField extends StatefulWidget {
  const SearchField({
    super.key,
    this.controller,
    this.onChanged,
    this.onSearch,
    this.hintText,
    this.enabled = true,
  });

  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onSearch;
  final String? hintText;
  final bool enabled;

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  late final TextEditingController _internalController;
  late final TextEditingController _effectiveController;
  late final FocusNode _focusNode;

  static const String defaultHintText = 'Search products';

  static const double containerHeight = 40.0;
  static const double containerLeftPadding = 12.0;
  static const double containerBorderRadius = 6.0;
  static const double textFontSize = 14.0;
  static const double hintFontSize = 14.0;
  static const double iconSize = 23.0;
  static const double borderAlpha = 0.2;

  static const Color containerBackgroundColor = Colors.white;
  static const Color borderColor = Colors.grey;

  @override
  void initState() {
    super.initState();
    _internalController = TextEditingController();
    _effectiveController = widget.controller ?? _internalController;
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    if (widget.controller == null) {
      _internalController.dispose();
    }
    super.dispose();
  }

  void _handleSearch() {
    _focusNode.unfocus();
    if (widget.onSearch != null) {
      widget.onSearch!();
    }
  }

  void _handleSubmitted(String value) {
    _handleSearch();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.enabled) {
          _focusNode.requestFocus();
        }
      },
      child: Container(
        height: containerHeight,
        padding: const EdgeInsets.only(left: containerLeftPadding),
        decoration: _buildContainerDecoration(),
        child: Row(children: [_buildTextField(), _buildSearchButton()]),
      ),
    );
  }

  BoxDecoration _buildContainerDecoration() {
    return BoxDecoration(
      color: containerBackgroundColor,
      borderRadius: BorderRadius.circular(containerBorderRadius),
      border: Border.all(
        color: borderColor.withAlpha((borderAlpha * 255).round()),
      ),
    );
  }

  Widget _buildTextField() {
    return Expanded(
      child: TextField(
        controller: _effectiveController,
        focusNode: _focusNode,
        enabled: widget.enabled,
        style: const TextStyle(
          fontSize: textFontSize,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
        decoration: InputDecoration(
          hintText: widget.hintText ?? defaultHintText,
          hintStyle: const TextStyle(
            fontSize: hintFontSize,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
          border: InputBorder.none,
          isDense: true,
        ),
        onChanged: widget.onChanged,
        onSubmitted: _handleSubmitted,
        textInputAction: TextInputAction.search,
      ),
    );
  }

  Widget _buildSearchButton() {
    return IconButton(
      iconSize: iconSize,
      icon: const Icon(Icons.search),
      onPressed: widget.enabled ? _handleSearch : null,
    );
  }
}
