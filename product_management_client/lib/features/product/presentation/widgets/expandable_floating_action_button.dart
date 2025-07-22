import 'package:flutter/material.dart';
import 'package:product_management_client/core/utils/theme.dart';
import 'package:product_management_client/features/product/presentation/widgets/dialog_utils.dart';

class ExpandableFloatingActionButton extends StatefulWidget {
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ExpandableFloatingActionButton({super.key, this.onEdit, this.onDelete});

  @override
  State<ExpandableFloatingActionButton> createState() => _ExpandableFloatingActionButtonState();
}

class _ExpandableFloatingActionButtonState extends State<ExpandableFloatingActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleFab() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _showDeleteConfirmationDialog() {
    DialogUtils.showConfirmDeleteProduct(
      context,
      onConfirm: () {
        widget.onDelete?.call();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ScaleTransition(
          scale: _animation,
          child: FloatingActionButton(
            onPressed: () {
              widget.onEdit?.call();
              _toggleFab();
            },
            backgroundColor: Colors.amber,
            heroTag: "edit",
            mini: true,
            child: const Icon(Icons.edit, color: Colors.white),
          ),
        ),
        SizedBox(height: _isExpanded ? 16 : 0),
        ScaleTransition(
          scale: _animation,
          child: FloatingActionButton(
            onPressed: () {
              _showDeleteConfirmationDialog();
              _toggleFab();
            },
            backgroundColor: Colors.red,
            heroTag: "delete",
            mini: true,
            child: const Icon(Icons.delete, color: Colors.white),
          ),
        ),
        const SizedBox(height: 16),
        FloatingActionButton(
          onPressed: _toggleFab,
          backgroundColor: DefaultColors.buttonColor,
          child: AnimatedRotation(
            turns: _isExpanded ? 0.125 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: Icon(
              _isExpanded ? Icons.close : Icons.menu,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
