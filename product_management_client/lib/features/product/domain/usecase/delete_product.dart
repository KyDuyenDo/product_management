import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:product_management_client/core/error/failures.dart';
import 'package:product_management_client/core/usecase/usecase.dart';
import '../repositories/product_repository.dart';

class DeleteProduct implements UseCase<void, DeleteProductParams> {
  final ProductRepository repository;

  DeleteProduct(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteProductParams params) async {
    return await repository.deleteProduct(params.id);
  }
}

class DeleteProductParams extends Equatable {
  final int id;

  const DeleteProductParams({required this.id});

  @override
  List<Object> get props => [id];
}
