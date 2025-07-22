import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:product_management_client/core/error/failures.dart';
import 'package:product_management_client/core/usecase/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class AddProduct implements UseCase<Product, AddProductParams> {
  final ProductRepository repository;

  AddProduct(this.repository);

  @override
  Future<Either<Failure, Product>> call(AddProductParams params) async {
    return await repository.addProduct(params.product);
  }
}

class AddProductParams extends Equatable {
  final Product product;

  const AddProductParams({required this.product});

  @override
  List<Object> get props => [product];
}
