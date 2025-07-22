import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:product_management_client/core/error/failures.dart';
import 'package:product_management_client/core/usecase/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProducts implements UseCase<List<Product>, GetProductsParams> {
  final ProductRepository repository;

  GetProducts(this.repository);

  @override
  Future<Either<Failure, List<Product>>> call(GetProductsParams params) async {
    return await repository.getProducts(
      query: params.query,
      categoryId: params.categoryId,
    );
  }
}

class GetProductsParams extends Equatable {
  final String? query;
  final int? categoryId;

  const GetProductsParams({this.query, this.categoryId});

  @override
  List<Object?> get props => [query, categoryId];
}
