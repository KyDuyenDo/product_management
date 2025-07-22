import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_management_client/core/enum/product_change_type.dart';
import 'package:product_management_client/core/error/failures.dart';
import 'package:product_management_client/core/services/upload_api_image.dart';
import 'package:product_management_client/core/usecase/usecase.dart';
import 'package:product_management_client/features/product/domain/entities/product.dart';
import 'package:product_management_client/features/product/domain/usecase/add_product.dart';
import 'package:product_management_client/features/product/domain/usecase/get_category.dart';
import 'package:product_management_client/features/product/domain/usecase/get_product_detail.dart';
import 'package:product_management_client/features/product/domain/usecase/update_product.dart';
import 'package:product_management_client/features/product/presentation/bloc/product_form_bloc/product_form_event.dart';
import 'package:product_management_client/features/product/presentation/bloc/product_form_bloc/product_form_state.dart';

class ProductFormBloc extends Bloc<ProductFormEvent, ProductFormState> {
  final GetProductDetail getProductDetail;
  final UpdateProduct updateProduct;
  final AddProduct addProduct;
  final GetCategories getCategories;
  final ImgBBUploadService uploadApiImage;

  ProductFormBloc({
    required this.getProductDetail,
    required this.addProduct,
    required this.updateProduct,
    required this.getCategories,
    required this.uploadApiImage,
  }) : super(ProductFormState.initial()) {
    on<LoadProductFormEvent>(_onLoadProductFormEvent);
    on<AddProductEvent>(_onAddProductEvent);
    on<EditProductEvent>(_onEditProductEvent);
    on<LoadCategoriesFormEvent>(_onLoadCategories);
  }

  Future<void> _onLoadProductFormEvent(
    LoadProductFormEvent event,
    Emitter<ProductFormState> emit,
  ) async {
    if (event.type == ProductChangeType.editProduct) {
      emit(ProductFormState.loading());
      final result = await getProductDetail(event.productId);
      result.fold(
        (failure) =>
            emit(ProductFormState.error(_mapFailureToMessage(failure))),
        (product) => emit(
          ProductFormState.loaded(
            product: product,
            categories: state.categories,
          ),
        ),
      );
    }
  }

  Future<void> _onAddProductEvent(
    AddProductEvent event,
    Emitter<ProductFormState> emit,
  ) async {
    emit(state.copyWith(isSubmitting: true, isChanged: false));

    try {
      List<String> imageUrls = [];

      if (event.images.isNotEmpty) {
        emit(state.copyWith(isUploadingImages: true, uploadProgress: 0.0));

        for (int i = 0; i < event.images.length; i++) {
          final image = event.images[i];
          final bytes = await image.readAsBytes();
          final filename =
              '${DateTime.now().millisecondsSinceEpoch}_${image.name}';

          emit(state.copyWith(uploadProgress: (i / event.images.length) * 0.8));

          final result = await uploadApiImage.uploadImage(bytes, filename);
          if (result != null && result['location'] != null) {
            imageUrls.add(result['location']);
          }
        }
        emit(state.copyWith(uploadProgress: 0.8));
      }

      final productWithImages = Product(
        id: event.product.id,
        name: event.product.name,
        description: event.product.description,
        price: event.product.price,
        stock: event.product.stock,
        categoryId: event.product.categoryId,
        categoryName: event.product.categoryName,
        thumbnail:
            imageUrls.isNotEmpty
                ? imageUrls.first
                : 'https://via.placeholder.com/300',
        images: imageUrls,
        stockStatus: event.product.stockStatus,
      );

      emit(state.copyWith(uploadProgress: 0.9));

      final result = await addProduct(
        AddProductParams(product: productWithImages),
      );
      result.fold(
        (failure) =>
            emit(ProductFormState.error(_mapFailureToMessage(failure))),
        (product) => emit(
          state.copyWith(
            isSubmitting: false,
            isUploadingImages: false,
            isChanged: true,
            product: product,
            uploadProgress: 1.0,
          ),
        ),
      );
    } catch (e) {
      emit(ProductFormState.error('Failed to upload images: ${e.toString()}'));
    }
  }

  Future<void> _onEditProductEvent(
    EditProductEvent event,
    Emitter<ProductFormState> emit,
  ) async {
    emit(state.copyWith(isSubmitting: true, isChanged: false));

    try {
      List<String> newImageUrls = [];

      if (event.images.isNotEmpty) {
        emit(state.copyWith(isUploadingImages: true, uploadProgress: 0.0));

        for (int i = 0; i < event.images.length; i++) {
          final image = event.images[i];
          final bytes = await image.readAsBytes();
          final filename =
              '${DateTime.now().millisecondsSinceEpoch}_${image.name}';

          emit(state.copyWith(uploadProgress: (i / event.images.length) * 0.8));

          final result = await uploadApiImage.uploadImage(bytes, filename);
          if (result != null && result['location'] != null) {
            newImageUrls.add(result['location']);
          }
        }
        emit(state.copyWith(uploadProgress: 0.8));
      }

      final allImages = [...event.product.images, ...newImageUrls];

      final productWithImages = Product(
        id: event.product.id,
        name: event.product.name,
        description: event.product.description,
        price: event.product.price,
        stock: event.product.stock,
        categoryId: event.product.categoryId,
        categoryName: event.product.categoryName,
        thumbnail:
            allImages.isNotEmpty ? allImages.first : event.product.thumbnail,
        images: allImages,
        stockStatus: event.product.stockStatus,
      );

      emit(state.copyWith(uploadProgress: 0.9));

      final result = await updateProduct(
        UpdateProductParams(product: productWithImages),
      );
      result.fold(
        (failure) =>
            emit(ProductFormState.error(_mapFailureToMessage(failure))),
        (product) => emit(
          state.copyWith(
            isSubmitting: false,
            isUploadingImages: false,
            isChanged: true,
            product: product,
            uploadProgress: 1.0,
          ),
        ),
      );
    } catch (e) {
      emit(ProductFormState.error('Failed to upload images: ${e.toString()}'));
    }
  }

  Future<void> _onLoadCategories(
    LoadCategoriesFormEvent event,
    Emitter<ProductFormState> emit,
  ) async {
    final result = await getCategories(NoParams());
    result.fold(
      (failure) {},
      (categories) => emit(state.copyWith(categories: categories)),
    );
  }

  String _mapFailureToMessage(dynamic failure) {
    switch (failure.runtimeType) {
      case ServerFailure _:
        return 'Server error occurred';
      case NetworkFailure _:
        return 'Network connection failed';
      case CacheFailure _:
        return 'Cache error occurred';
      default:
        return 'An unexpected error occurred';
    }
  }
}
