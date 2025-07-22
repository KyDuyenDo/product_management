import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_management_client/core/enum/product_change_type.dart';
import 'package:product_management_client/core/error/failures.dart';
import 'package:product_management_client/core/usecase/usecase.dart';
import 'package:product_management_client/features/product/domain/entities/category.dart';
import 'package:product_management_client/features/product/domain/entities/product.dart';
import 'package:product_management_client/features/product/domain/usecase/get_category.dart';
import 'package:product_management_client/features/product/domain/usecase/get_product.dart';
import 'package:product_management_client/features/product/presentation/bloc/product_list_bloc/product_list_event.dart';
import 'package:product_management_client/features/product/presentation/bloc/product_list_bloc/product_list_state.dart';

class ProductListBloc extends Bloc<ProductListEvent, ProductListState> {
  final GetProducts getProducts;
  final GetCategories getCategories;

  ProductListBloc({required this.getProducts, required this.getCategories})
    : super(ProductListState.initial()) {
    on<LoadProductsEvent>(_onLoadProducts);
    on<RefreshProductsEvent>(_onRefreshProducts);
    on<SearchProductsEvent>(_onSearchProducts);
    on<FilterByCategoryEvent>(_onFilterByCategory);
    on<SortProductsEvent>(_onSortProducts);
    on<ClearFiltersEvent>(_onClearFilters);
    on<LoadCategoriesEvent>(_onLoadCategories);
    on<UpdateProductsAfterDeleteEvent>(_onUpdateProductAfterDelete);
    on<UpdateProductsEvent>(_onUpdateProducts);
  }

  Future<void> _onLoadProducts(
    LoadProductsEvent event,
    Emitter<ProductListState> emit,
  ) async {
    emit(ProductListState.loading());
    await _loadData(emit);
  }

  Future<void> _onRefreshProducts(
    RefreshProductsEvent event,
    Emitter<ProductListState> emit,
  ) async {
    emit(state.copyWith(isRefreshing: true));
    await _loadData(emit);
  }

  Future<void> _onSearchProducts(
    SearchProductsEvent event,
    Emitter<ProductListState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, searchQuery: event.query));
    await _loadData(emit, query: event.query.isEmpty ? null : event.query);
  }

  Future<void> _onFilterByCategory(
    FilterByCategoryEvent event,
    Emitter<ProductListState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    await _loadData(emit, categoryId: event.categoryId);
  }

  Future<void> _onSortProducts(
    SortProductsEvent event,
    Emitter<ProductListState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    await _loadData(emit, sortType: event.sortType);
  }

  Future<void> _onClearFilters(
    ClearFiltersEvent event,
    Emitter<ProductListState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    await _loadData(emit);
  }

  Future<void> _onLoadCategories(
    LoadCategoriesEvent event,
    Emitter<ProductListState> emit,
  ) async {
    final result = await getCategories(NoParams());
    result.fold(
      (failure) =>
          emit(state.copyWith(errorMessage: _mapFailureToMessage(failure))),
      (categories) => emit(state.copyWith(categories: categories)),
    );
  }

  Future<void> _onUpdateProducts(
    UpdateProductsEvent event,
    Emitter<ProductListState> emit,
  ) async {
    if (event.type == ProductChangeType.addProduct) {
      emit(
        state.copyWith(
          products: List<Product>.from(state.products)..add(event.product),
        ),
      );
    } else {
      final updatedList = List<Product>.from(state.products);
      final index = updatedList.indexWhere((p) => p.id == event.product.id);
      if (index != -1) {
        updatedList[index] = event.product;

        emit(state.copyWith(products: updatedList));
      }
    }
  }

  Future<void> _onUpdateProductAfterDelete(
    UpdateProductsAfterDeleteEvent event,
    Emitter<ProductListState> emit,
  ) async {
    final updatedProducts =
        state.products
            .where((product) => product.id != event.productId)
            .toList();
    emit(state.copyWith(products: updatedProducts));
  }

  Future<void> _loadData(
    Emitter<ProductListState> emit, {
    String? query,
    int? categoryId,
    ProductSortType? sortType,
  }) async {
    if (emit.isDone) return;

    final effectiveQuery = query ?? state.searchQuery;
    final effectiveCategoryId = categoryId;
    final effectiveSortType = sortType ?? state.sortType;

    print(effectiveCategoryId);

    final results = await Future.wait([
      getProducts(
        GetProductsParams(
          query: effectiveQuery,
          categoryId: effectiveCategoryId,
        ),
      ),
      getCategories(NoParams()),
    ]);

    if (emit.isDone) return;

    final productsResult = results[0];
    final categoriesResult = results[1];

    productsResult.fold(
      (failure) => emit(ProductListState.error(_mapFailureToMessage(failure))),
      (products) {
        final sortedProducts = _sortProducts(
          products as List<Product>,
          effectiveSortType,
        );

        final categories = categoriesResult.fold(
          (failure) => state.categories,
          (categories) => categories as List<Category>,
        );

        emit(
          ProductListState.loaded(
            products: sortedProducts,
            categories: categories,
            searchQuery: effectiveQuery,
            selectedCategoryId: effectiveCategoryId,
            sortType: effectiveSortType,
          ),
        );
      },
    );
  }

  List<Product> _sortProducts(
    List<Product> products,
    ProductSortType sortType,
  ) {
    final sortedProducts = List<Product>.from(products);

    switch (sortType) {
      case ProductSortType.priceHighToLow:
        sortedProducts.sort((a, b) => b.price.compareTo(a.price));
      case ProductSortType.priceLowToHigh:
        sortedProducts.sort((a, b) => a.price.compareTo(b.price));
      case ProductSortType.stockHighToLow:
        sortedProducts.sort((a, b) => b.stock.compareTo(a.stock));
      case ProductSortType.stockLowToHigh:
        sortedProducts.sort((a, b) => a.stock.compareTo(b.stock));
      case ProductSortType.nameAToZ:
        sortedProducts.sort((a, b) => a.name.compareTo(b.name));
      case ProductSortType.nameZToA:
        sortedProducts.sort((a, b) => b.name.compareTo(a.name));
      case ProductSortType.none:
      default:
        break;
    }
    return sortedProducts;
  }

  String _mapFailureToMessage(Failure failure) {
    return switch (failure.runtimeType) {
      ServerFailure _ => 'Server Failure',
      CacheFailure _ => 'Cache Failure',
      NetworkFailure _ => 'Network Failure - Showing cached data',
      _ => 'Unexpected Error',
    };
  }
}
