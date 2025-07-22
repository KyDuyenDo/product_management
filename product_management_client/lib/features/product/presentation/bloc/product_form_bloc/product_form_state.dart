import 'package:equatable/equatable.dart';
import 'package:product_management_client/features/product/domain/entities/category.dart';
import 'package:product_management_client/features/product/domain/entities/product.dart';

class ProductFormState extends Equatable {
  final bool isLoading;
  final bool isSubmitting;
  final bool isUploadingImages;
  final bool isChanged;
  final Product? product;
  final String? errorMessage;
  final List<Category> categories;
  final double uploadProgress;

  const ProductFormState({
    this.isLoading = false,
    this.isSubmitting = false,
    this.isUploadingImages = false,
    this.isChanged = false,
    this.product,
    this.errorMessage,
    List<Category>? categories,
    this.uploadProgress = 0.0,
  }) : categories = categories ?? const [];

  factory ProductFormState.initial() => const ProductFormState();

  factory ProductFormState.loading() => const ProductFormState(isLoading: true);
  factory ProductFormState.submitting() =>
      const ProductFormState(isSubmitting: true);

  factory ProductFormState.uploadingImages({double progress = 0.0}) =>
      ProductFormState(isUploadingImages: true, uploadProgress: progress);

  factory ProductFormState.isChanged() =>
      const ProductFormState(isChanged: true);

  factory ProductFormState.error(String message) =>
      ProductFormState(errorMessage: message);

  factory ProductFormState.loaded({
    bool isLoading = false,
    bool isChanged = false,
    List<Category> categories = const [],
    required Product product,
    String? errorMessage,
  }) {
    return ProductFormState(
      product: product,
      errorMessage: errorMessage,
      isChanged: isChanged,
      isLoading: isLoading,
      categories: categories,
    );
  }

  ProductFormState copyWith({
    bool? isLoading,
    bool? isUploadingImages,
    bool? isChanged,
    Product? product,
    String? errorMessage,
    List<Category>? categories,
    double? uploadProgress,
    bool? isSubmitting,
  }) {
    return ProductFormState(
      isLoading: isLoading ?? false,
      isUploadingImages: isUploadingImages ?? false,
      isChanged: isChanged ?? false,
      product: product ?? this.product,
      errorMessage: errorMessage,
      categories: categories ?? this.categories,
      uploadProgress: uploadProgress ?? 0.0,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isUploadingImages,
    isChanged,
    product,
    errorMessage,
    categories,
    uploadProgress,
    isSubmitting,
  ];
}
