import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:product_management_client/core/enum/product_change_type.dart';
import 'package:product_management_client/features/product/domain/entities/product.dart';

abstract class ProductListEvent extends Equatable {
  const ProductListEvent();

  @override
  List<Object?> get props => [];
}

class UpdateProductsAfterDeleteEvent extends ProductListEvent {
  final int productId;
  const UpdateProductsAfterDeleteEvent(this.productId);

  @override
  List<Object> get props => [productId];
}

class UpdateProductsEvent extends ProductListEvent {
  final Product product;
  final ProductChangeType type;
  const UpdateProductsEvent(this.product, this.type);

  @override
  List<Object> get props => [product, type];
}

class LoadProductsEvent extends ProductListEvent {}

class RefreshProductsEvent extends ProductListEvent {}

class SearchProductsEvent extends ProductListEvent {
  final String query;

  const SearchProductsEvent(this.query);

  @override
  List<Object> get props => [query];
}

class FilterByCategoryEvent extends ProductListEvent {
  final int? categoryId;

  const FilterByCategoryEvent(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
}

class SortProductsEvent extends ProductListEvent {
  final ProductSortType sortType;

  const SortProductsEvent(this.sortType);

  @override
  List<Object> get props => [sortType];
}

class ClearFiltersEvent extends ProductListEvent {}

class LoadCategoriesEvent extends ProductListEvent {}

enum ProductSortType {
  none,
  priceHighToLow,
  priceLowToHigh,
  stockHighToLow,
  stockLowToHigh,
  nameAToZ,
  nameZToA,
}

extension ProductSortTypeExtension on ProductSortType {
  String get displayName {
    switch (this) {
      case ProductSortType.none:
        return 'Default';
      case ProductSortType.priceHighToLow:
        return 'Price: High to Low';
      case ProductSortType.priceLowToHigh:
        return 'Price: Low to High';
      case ProductSortType.stockHighToLow:
        return 'Stock: High to Low';
      case ProductSortType.stockLowToHigh:
        return 'Stock: Low to High';
      case ProductSortType.nameAToZ:
        return 'Name: A to Z';
      case ProductSortType.nameZToA:
        return 'Name: Z to A';
    }
  }

  IconData get icon {
    switch (this) {
      case ProductSortType.none:
        return Icons.sort;
      case ProductSortType.priceHighToLow:
        return Icons.trending_down;
      case ProductSortType.priceLowToHigh:
        return Icons.trending_up;
      case ProductSortType.stockHighToLow:
        return Icons.inventory_2;
      case ProductSortType.stockLowToHigh:
        return Icons.inventory_outlined;
      case ProductSortType.nameAToZ:
        return Icons.sort_by_alpha;
      case ProductSortType.nameZToA:
        return Icons.sort_by_alpha;
    }
  }
}
