import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_management_client/core/utils/theme.dart';
import 'package:product_management_client/features/product/presentation/bloc/product_list_bloc/product_list_bloc.dart';
import 'package:product_management_client/features/product/presentation/bloc/product_list_bloc/product_list_state.dart';

class ProductListAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ProductListAppBar({super.key, this.onAddProduct});

  final VoidCallback? onAddProduct;

  static const double _scrolledUnderElevation = 0.0;
  static const double _elevation = 0.0;
  static const double _iconPadding = 8.0;
  static const double _iconSize = 24.0;
  static const double _titleSpacing = 12.0;
  static const double _titleFontSize = 20.0;
  static const double _subtitleFontSize = 12.0;
  static const double _actionMargin = 16.0;
  static const double _actionBorderRadius = 12.0;
  static const double _shadowBlurRadius = 8.0;
  static const double _shadowOffset = 2.0;
  static const double _actionShadowBlurRadius = 4.0;
  static const double _actionShadowOffset = 2.0;
  static const double _gradientOpacity = 0.8;
  static const double _iconBackgroundOpacity = 0.2;
  static const double _subtitleOpacity = 0.9;
  static const double _shadowOpacity = 0.3;
  static const double _actionShadowOpacity = 0.1;
  static const double _mediumButtonSize = 40.0;

  static const String _titleText = 'Product Store';
  static const String _itemsAvailableText = 'items available';
  static const String _addTooltipText = 'Add New Product';

  static const List<double> _gradientStops = [0.0, 0.7, 1.0];

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: _scrolledUnderElevation,
      elevation: _elevation,
      backgroundColor: Colors.transparent,
      flexibleSpace: _buildFlexibleSpace(),
      title: _buildTitle(),
      actions: [_buildAddButton()],
    );
  }

  Widget _buildFlexibleSpace() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            DefaultColors.buttonColor,
            DefaultColors.buttonColor.withValues(alpha: _gradientOpacity),
            DefaultColors.highlightTitle,
          ],
          stops: _gradientStops,
        ),
        boxShadow: [
          BoxShadow(
            color: DefaultColors.buttonColor.withValues(alpha: _shadowOpacity),
            blurRadius: _shadowBlurRadius,
            offset: const Offset(0, _shadowOffset),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Row(
      children: [
        _buildTitleIcon(),
        const SizedBox(width: _titleSpacing),
        _buildTitleContent(),
      ],
    );
  }

  Widget _buildTitleIcon() {
    return Container(
      padding: const EdgeInsets.all(_iconPadding),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: _iconBackgroundOpacity),
        borderRadius: BorderRadius.circular(_actionBorderRadius),
      ),
      child: const Icon(
        Icons.inventory_2_outlined,
        color: Colors.white,
        size: _iconSize,
      ),
    );
  }

  Widget _buildTitleContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          _titleText,
          style: TextStyle(
            color: Colors.white,
            fontSize: _titleFontSize,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        _buildSubtitle(),
      ],
    );
  }

  Widget _buildSubtitle() {
    return BlocBuilder<ProductListBloc, ProductListState>(
      builder: (context, state) {
        return Text(
          '${state.products.length} $_itemsAvailableText',
          style: TextStyle(
            color: Colors.white.withValues(alpha: _subtitleOpacity),
            fontSize: _subtitleFontSize,
            fontWeight: FontWeight.w400,
          ),
        );
      },
    );
  }

  Widget _buildAddButton() {
    return Container(
      height: _mediumButtonSize,
      width: _mediumButtonSize,
      margin: const EdgeInsets.only(right: _actionMargin),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_actionBorderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: _actionShadowOpacity),
            blurRadius: _actionShadowBlurRadius,
            offset: const Offset(0, _actionShadowOffset),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(
          Icons.add,
          color: DefaultColors.buttonColor,
          size: _iconSize,
        ),
        onPressed: onAddProduct,
        tooltip: _addTooltipText,
      ),
    );
  }
}
