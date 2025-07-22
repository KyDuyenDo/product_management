import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_management_client/core/error/failures.dart';
import 'package:product_management_client/features/product/domain/usecase/delete_product.dart';
import 'package:product_management_client/features/product/domain/usecase/get_product_detail.dart';
import 'package:product_management_client/features/product/presentation/bloc/product_detail_bloc/product_detail_event.dart';
import 'package:product_management_client/features/product/presentation/bloc/product_detail_bloc/product_detail_state.dart';

class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  final GetProductDetail getProductDetail;
  final DeleteProduct deleteProduct;

  ProductDetailBloc({
    required this.getProductDetail,
    required this.deleteProduct,
  }) : super(ProductDetailState.initial()) {
    on<LoadProductDetailEvent>(_onLoadProductDetail);
    on<RefreshProductDetailEvent>(_onRefreshProductDetail);
    on<DeleteProductEvent>(_onDeleteProduct);
  }

  Future<void> _onLoadProductDetail(
    LoadProductDetailEvent event,
    Emitter<ProductDetailState> emit,
  ) async {
    emit(ProductDetailState.loading());
    final result = await getProductDetail(event.productId);
    result.fold(
      (failure) =>
          emit(ProductDetailState.error(_mapFailureToMessage(failure))),
      (product) => emit(ProductDetailState.loaded(product: product)),
    );
  }

  Future<void> _onRefreshProductDetail(
    RefreshProductDetailEvent event,
    Emitter<ProductDetailState> emit,
  ) async {
    if (state.product != null) {
      emit(state.copyWith(isRefreshing: true));
    } else {
      emit(ProductDetailState.loading());
    }

    final result = await getProductDetail(event.productId);
    result.fold(
      (failure) =>
          emit(ProductDetailState.error(_mapFailureToMessage(failure))),
      (product) => emit(ProductDetailState.loaded(product: product)),
    );
  }

  Future<void> _onDeleteProduct(
    DeleteProductEvent event,
    Emitter<ProductDetailState> emit,
  ) async {
    if (state.product != null) {
      emit(state.copyWith(isDeleting: true));

      try {
        final result = await deleteProduct(
          DeleteProductParams(id: event.productId),
        );
        result.fold(
          (failure) => emit(
            state.copyWith(
              isDeleting: false,
              errorMessage: _mapFailureToMessage(failure),
            ),
          ),
          (_) => emit(state.copyWith(isDeleted: true, isDeleting: false)),
        );
      } catch (e) {
        emit(state.copyWith(isDeleted: true, isDeleting: false));
      }
    }
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
