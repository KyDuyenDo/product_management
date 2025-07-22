import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_management_client/core/utils/theme.dart';
import 'package:product_management_client/features/product/presentation/bloc/product_list_bloc/product_list_bloc.dart';
import 'package:product_management_client/features/product/presentation/bloc/product_list_bloc/product_list_state.dart';
import 'package:product_management_client/features/product/presentation/pages/product_list/content/empty_view.dart';
import 'package:product_management_client/features/product/presentation/pages/product_list/content/error_view.dart';
import 'package:product_management_client/features/product/presentation/pages/product_list/content/loading_view.dart';
import 'package:product_management_client/features/product/presentation/widgets/card_product.dart';

class ProductListContent extends StatelessWidget {
  const ProductListContent({
    super.key,
    this.onProductTap,
    this.onRefresh,
    this.onRetry,
  });

  final ValueChanged<int>? onProductTap;
  final VoidCallback? onRefresh;
  final VoidCallback? onRetry;

  static const double _listPadding = 20.0;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductListBloc, ProductListState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (_shouldShowLoading(state)) {
          return const ProductListLoadingView();
        }

        if (_shouldShowError(state)) {
          return ProductListErrorView(
            errorMessage: state.errorMessage!,
            onRetry: onRetry,
          );
        }

        return _buildRefreshableContent(state);
      },
    );
  }

  bool _shouldShowLoading(ProductListState state) {
    return state.isLoading && state.products.isEmpty;
  }

  bool _shouldShowError(ProductListState state) {
    return state.products.isEmpty && state.errorMessage != null;
  }

  Widget _buildRefreshableContent(ProductListState state) {
    return RefreshIndicator(
      onRefresh: () async {
        onRefresh?.call();
      },
      child: _buildProductListView(state),
    );
  }

  Widget _buildProductListView(ProductListState state) {
    if (state.products.isEmpty) {
      return ProductListEmptyView(searchQuery: state.searchQuery);
    }

    return Stack(
      children: [
        _buildProductList(state),
        if (_shouldShowLoadingOverlay(state)) _buildLoadingOverlay(),
        if (state.isRefreshing) _buildRefreshIndicator(),
      ],
    );
  }

  Widget _buildProductList(ProductListState state) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: _listPadding),
      itemCount: state.products.length,
      itemBuilder: (context, index) {
        final product = state.products[index];
        return GestureDetector(
          onTap: () => onProductTap?.call(product.id),
          child: CardProduct(
            index: index,
            productName: product.name,
            productDescription: product.description,
            price: product.price,
            stock: product.stock,
            thumbnail: product.thumbnail,
            images: product.images,
          ),
        );
      },
    );
  }

  bool _shouldShowLoadingOverlay(ProductListState state) {
    return state.isLoading && state.products.isNotEmpty;
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.white,
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(DefaultColors.buttonColor),
        ),
      ),
    );
  }

  Widget _buildRefreshIndicator() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        color: Colors.white.withValues(alpha: 0.1),
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              DefaultColors.buttonColor,
            ),
          ),
        ),
      ),
    );
  }
}
