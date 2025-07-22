import 'package:dartz/dartz.dart';
import 'package:product_management_client/core/error/failures.dart';
import 'package:product_management_client/core/usecase/usecase.dart';
import '../entities/category.dart';
import '../repositories/product_repository.dart';

class GetCategories implements UseCase<List<Category>, NoParams> {
  final ProductRepository repository;

  GetCategories(this.repository);

  @override
  Future<Either<Failure, List<Category>>> call(NoParams params) async {
    return await repository.getCategories();
  }
}
