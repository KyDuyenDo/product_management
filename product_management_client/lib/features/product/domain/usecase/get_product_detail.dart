import 'package:dartz/dartz.dart';
import 'package:product_management_client/core/error/failures.dart';
import 'package:product_management_client/core/usecase/usecase.dart';
import 'package:product_management_client/features/product/domain/entities/product.dart';
import 'package:product_management_client/features/product/domain/repositories/product_repository.dart';

class GetProductDetail implements UseCase {
  final ProductRepository repository;

  GetProductDetail(this.repository);

  @override
  Future<Either<Failure, Product>> call(dynamic productId) async {
    return await repository.getProductById(productId as int);
  }
}
