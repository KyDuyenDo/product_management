import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_management_client/features/product/presentation/bloc/product_list_bloc/product_list_bloc.dart';
import 'package:product_management_client/features/product/presentation/bloc/product_list_bloc/product_list_event.dart';
import 'package:product_management_client/features/product/presentation/bloc/product_list_bloc/product_list_state.dart';
import 'package:product_management_client/features/product/presentation/pages/product_list/content/appbar.dart';
import 'package:product_management_client/features/product/presentation/pages/product_list/content/content.dart';
import 'package:product_management_client/features/product/presentation/pages/product_list/content/search_section.dart';
import 'package:product_management_client/features/product/presentation/widgets/category_filter_chips.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key, this.onAddProduct, this.onProductTap});

  final VoidCallback? onAddProduct;
  final ValueChanged<int>? onProductTap;

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadInitialData() {
    context.read<ProductListBloc>().add(LoadProductsEvent());
  }

  void _clearSearch() {
    _searchController.clear();
    context.read<ProductListBloc>().add(const SearchProductsEvent(''));
  }

  void _handleSearch() {
    final query = _searchController.text;
    context.read<ProductListBloc>().add(SearchProductsEvent(query));
  }

  void _handleCategorySelected(int? categoryId) {
    context.read<ProductListBloc>().add(FilterByCategoryEvent(categoryId));
  }

  void _handleRefresh() {
    context.read<ProductListBloc>().add(RefreshProductsEvent());
  }

  void _handleRetry() {
    context.read<ProductListBloc>().add(LoadProductsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: ProductListAppBar(onAddProduct: widget.onAddProduct),
        body: Column(
          children: [
            BlocBuilder<ProductListBloc, ProductListState>(
              builder: (context, state) {
                return ProductListSearchSection(
                  searchController: _searchController,
                  searchQuery: state.searchQuery,
                  sortType: state.sortType,
                  onSearch: _handleSearch,
                  onClearSearch: _clearSearch,
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                );
              },
            ),
            BlocBuilder<ProductListBloc, ProductListState>(
              builder: (context, state) {
                if (state.categories.isNotEmpty) {
                  return CategoryFilterChips(
                    categories: state.categories,
                    selectedCategoryId: state.selectedCategoryId,
                    onCategorySelected: _handleCategorySelected,
                    isProductsLoading: state.isLoading,
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            Expanded(
              child: ProductListContent(
                onProductTap: widget.onProductTap,
                onRefresh: _handleRefresh,
                onRetry: _handleRetry,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
