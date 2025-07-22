import 'package:equatable/equatable.dart';
import 'package:product_management_client/features/product/domain/entities/product.dart';

abstract class ProductDetailEvent extends Equatable {
  const ProductDetailEvent();

  @override
  List<Object?> get props => [];
}

class LoadProductDetailEvent extends ProductDetailEvent {
  final int productId;
  const LoadProductDetailEvent(this.productId);

  @override
  List<Object> get props => [productId];
}

class UpdateProductDetailEvent extends ProductDetailEvent {
  final Product product;
  const UpdateProductDetailEvent(this.product);

  @override
  List<Object> get props => [product];
}

class DeleteProductEvent extends ProductDetailEvent {
  final int productId;

  const DeleteProductEvent(this.productId);

  @override
  List<Object> get props => [productId];
}

class RefreshProductDetailEvent extends ProductDetailEvent {
  final int productId;

  const RefreshProductDetailEvent(this.productId);

  @override
  List<Object> get props => [productId];
}
