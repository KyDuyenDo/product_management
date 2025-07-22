import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:product_management_client/core/enum/product_change_type.dart';
import 'package:product_management_client/features/product/domain/entities/product.dart';

abstract class ProductFormEvent extends Equatable {
  const ProductFormEvent();

  @override
  List<Object?> get props => [];
}

class LoadProductFormEvent extends ProductFormEvent {
  final int productId;
  final ProductChangeType type;
  const LoadProductFormEvent(this.productId, this.type);

  @override
  List<Object> get props => [productId, type];
}

class AddProductEvent extends ProductFormEvent {
  final Product product;
  final List<XFile> images;

  const AddProductEvent(this.product, this.images);

  @override
  List<Object> get props => [product, images];
}

class EditProductEvent extends ProductFormEvent {
  final Product product;
  final int productId;
  final List<XFile> images;

  const EditProductEvent(this.product, this.productId, this.images);

  @override
  List<Object> get props => [product, productId, images];
}

class LoadCategoriesFormEvent extends ProductFormEvent {}
