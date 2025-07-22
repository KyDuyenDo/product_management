import 'package:equatable/equatable.dart';
import 'package:product_management_client/features/product/domain/entities/category.dart';
import 'package:product_management_client/features/product/domain/entities/product.dart';
import 'product_list_event.dart';

class ProductListState extends Equatable {
  final bool isLoading;
  final bool isRefreshing;
  final List<Product> products;
  final List<Category> categories;
  final String? searchQuery;
  final int? selectedCategoryId;
  final ProductSortType sortType;
  final String? errorMessage;

  const ProductListState({
    this.isLoading = false,
    this.isRefreshing = false,
    this.products = const [],
    this.categories = const [],
    this.searchQuery,
    this.selectedCategoryId,
    this.sortType = ProductSortType.none,
    this.errorMessage,
  });

  factory ProductListState.initial() => const ProductListState();

  factory ProductListState.loading() => const ProductListState(isLoading: true);

  factory ProductListState.error(String message) =>
      ProductListState(errorMessage: message);

  factory ProductListState.loaded({
    required List<Product> products,
    required List<Category> categories,
    String? searchQuery,
    int? selectedCategoryId,
    ProductSortType sortType = ProductSortType.none,
    bool isRefreshing = false,
  }) {
    return ProductListState(
      products: products,
      categories: categories,
      searchQuery: searchQuery,
      selectedCategoryId: selectedCategoryId,
      sortType: sortType,
      isRefreshing: isRefreshing,
    );
  }

  ProductListState copyWith({
    bool? isLoading,
    bool? isRefreshing,
    List<Product>? products,
    List<Category>? categories,
    String? searchQuery,
    int? selectedCategoryId,
    ProductSortType? sortType,
    String? errorMessage,
  }) {
    return ProductListState(
      isLoading: isLoading ?? false,
      isRefreshing: isRefreshing ?? false,
      products: products ?? this.products,
      categories: categories ?? this.categories,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      sortType: sortType ?? this.sortType,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isRefreshing,
    products,
    categories,
    searchQuery,
    selectedCategoryId,
    sortType,
    errorMessage,
  ];
}
