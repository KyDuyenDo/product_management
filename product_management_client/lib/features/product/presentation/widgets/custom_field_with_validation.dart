import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:product_management_client/core/utils/theme.dart';

class CustomTextFieldWithValidation extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? placeholder;
  final int maxLines;
  final int? maxLength;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final bool isRequired;

  const CustomTextFieldWithValidation({
    super.key,
    required this.controller,
    required this.label,
    this.placeholder,
    this.maxLines = 1,
    this.maxLength,
    this.keyboardType,
    this.inputFormatters,
    this.validator,
    this.isRequired = true,
  });

  @override
  State<CustomTextFieldWithValidation> createState() =>
      _CustomTextFieldWithValidationState();
}

class _CustomTextFieldWithValidationState
    extends State<CustomTextFieldWithValidation> {
  String? _errorText;
  bool _hasBeenTouched = false;

  static const double _errorTextHeight = 16.0;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    if (_hasBeenTouched && widget.validator != null) {
      final error = widget.validator!(widget.controller.text);
      if (mounted) {
        setState(() {
          _errorText = error;
        });
      }
    }
  }

  void _onFocusLost() {
    setState(() {
      _hasBeenTouched = true;
    });
    if (widget.validator != null) {
      final error = widget.validator!(widget.controller.text);
      setState(() {
        _errorText = error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(),
        const SizedBox(height: 8),
        Focus(
          onFocusChange: (hasFocus) {
            if (!hasFocus) {
              _onFocusLost();
            }
          },
          child: TextFormField(
            controller: widget.controller,
            maxLines: widget.maxLines,
            maxLength: widget.maxLength,
            keyboardType: widget.keyboardType,
            inputFormatters: widget.inputFormatters,
            validator: widget.validator,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
            decoration: InputDecoration(
              hintText: widget.placeholder,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.grey.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color:
                      _errorText != null
                          ? Colors.red
                          : Colors.grey.withValues(alpha: 0.3),
                  width: _errorText != null ? 2 : 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color:
                      _errorText != null
                          ? Colors.red
                          : DefaultColors.buttonColor,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red, width: 2),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red, width: 2),
              ),
              filled: true,
              fillColor: Colors.grey[50],
              hintStyle: TextStyle(
                color: Colors.grey[400],
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              counterText: widget.maxLength != null ? null : '',
              errorStyle: const TextStyle(height: 0),
            ),
          ),
        ),
        const SizedBox(height: 2),

        SizedBox(
          height: _errorTextHeight,
          child:
              _errorText != null
                  ? Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _errorText!,
                      style: TextStyle(
                        color: Colors.red[600],
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                  : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildLabel() {
    return Text.rich(
      TextSpan(
        text: widget.label,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
        children: [
          if (widget.isRequired)
            const TextSpan(
              text: ' *',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
        ],
      ),
    );
  }
}
