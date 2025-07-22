import 'package:dartz/dartz.dart';
import 'package:product_management_client/core/error/failures.dart';
import 'package:product_management_client/features/product/domain/entities/category.dart';
import 'package:product_management_client/features/product/domain/entities/product.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<Product>>> getProducts({
    String? query,
    int? categoryId,
  });
  Future<Either<Failure, Product>> getProductById(int id);
  Future<Either<Failure, Product>> addProduct(Product product);
  Future<Either<Failure, Product>> updateProduct(Product product);
  Future<Either<Failure, void>> deleteProduct(int id);
  Future<Either<Failure, List<Category>>> getCategories();
  Future<Either<Failure, List<String>>> uploadImage(
    int productId,
    List<String> imagePaths,
  );
}
