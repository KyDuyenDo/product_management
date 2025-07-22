import 'package:equatable/equatable.dart';
import 'package:product_management_client/features/product/domain/entities/product.dart';

class ProductDetailState extends Equatable {
  final bool isLoading;
  final bool isDeleting;
  final bool isRefreshing;
  final bool isDeleted;
  final Product? product;
  final String? errorMessage;

  const ProductDetailState({
    this.isLoading = false,
    this.isDeleting = false,
    this.isRefreshing = false,
    this.isDeleted = false,
    this.product,
    this.errorMessage,
  });

  factory ProductDetailState.initial() => const ProductDetailState();

  factory ProductDetailState.loading() =>
      const ProductDetailState(isLoading: true);

  factory ProductDetailState.deleted() =>
      const ProductDetailState(isDeleted: true);

  factory ProductDetailState.error(String message) =>
      ProductDetailState(errorMessage: message);

  factory ProductDetailState.loaded({
    required Product product,
    bool isDeleting = false,
    bool isRefreshing = false,
    String? errorMessage,
  }) {
    return ProductDetailState(
      product: product,
      isDeleting: isDeleting,
      isRefreshing: isRefreshing,
      errorMessage: errorMessage,
    );
  }

  ProductDetailState copyWith({
    bool? isLoading,
    bool? isDeleting,
    bool? isRefreshing,
    bool? isDeleted,
    Product? product,
    String? errorMessage,
  }) {
    return ProductDetailState(
      isLoading: isLoading ?? this.isLoading,
      isDeleting: isDeleting ?? this.isDeleting,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isDeleted: isDeleted ?? this.isDeleted,
      product: product ?? this.product,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isDeleting,
    isRefreshing,
    isDeleted,
    product,
    errorMessage,
  ];
}
