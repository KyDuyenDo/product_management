import 'package:dartz/dartz.dart';
import 'package:product_management_client/core/error/exceptions.dart';
import 'package:product_management_client/core/error/failures.dart';
import 'package:product_management_client/core/network/network_info.dart';
import 'package:product_management_client/features/product/data/datasources/product_local_data_source.dart';
import 'package:product_management_client/features/product/data/datasources/product_remote_data_source.dart';
import 'package:product_management_client/features/product/data/models/product_model.dart';
import 'package:product_management_client/features/product/domain/entities/category.dart';
import 'package:product_management_client/features/product/domain/entities/product.dart';
import 'package:product_management_client/features/product/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Product>>> getProducts({
    String? query,
    int? categoryId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteProducts = await remoteDataSource.getProducts(
          query: query,
          categoryId: categoryId,
        );
        if (query == null && categoryId == null) {
          await localDataSource.cacheProducts(remoteProducts);
        }
        return Right(remoteProducts);
      } on ServerException {
        return Left(ServerFailure());
      } on NetworkException {
        return Left(NetworkFailure());
      }
    } else {
      try {
        final localProducts = await localDataSource.getCachedProducts();
        List<ProductModel> filteredProducts = localProducts;

        if (query != null && query.isNotEmpty) {
          filteredProducts =
              filteredProducts
                  .where(
                    (product) => product.name.toLowerCase().contains(
                      query.toLowerCase(),
                    ),
                  )
                  .toList();
        }

        if (categoryId != null) {
          filteredProducts =
              filteredProducts
                  .where((product) => product.categoryId == categoryId)
                  .toList();
        }
        return Right(filteredProducts);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, Product>> getProductById(int id) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteProduct = await remoteDataSource.getProductById(id);
        return Right(remoteProduct);
      } on ServerException {
        return Left(ServerFailure());
      } on NetworkException {
        return Left(NetworkFailure());
      }
    } else {
      try {
        final localProducts = await localDataSource.getCachedProducts();
        final product = localProducts.firstWhere((p) => p.id == id);
        return Right(product);
      } on CacheException {
        return Left(CacheFailure());
      } catch (e) {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, Product>> addProduct(Product product) async {
    if (await networkInfo.isConnected) {
      try {
        final productModel = ProductModel.fromEntity(product);
        final remoteProduct = await remoteDataSource.createProduct(
          productModel,
        );
        return Right(remoteProduct);
      } on ServerException {
        return Left(ServerFailure());
      } on NetworkException {
        return Left(NetworkFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Product>> updateProduct(Product product) async {
    if (await networkInfo.isConnected) {
      try {
        final productModel = ProductModel.fromEntity(product);
        final remoteProduct = await remoteDataSource.updateProduct(
          productModel,
        );
        return Right(remoteProduct);
      } on ServerException {
        return Left(ServerFailure());
      } on NetworkException {
        return Left(NetworkFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteProduct(int id) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteProduct(id);
        return const Right(null);
      } on ServerException {
        return Left(ServerFailure());
      } on NetworkException {
        return const Right(null);
      } catch (e) {
        return const Right(null);
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<String>>> uploadImage(
    int productId,
    List<String> imagePaths,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final imageUrls = await remoteDataSource.uploadProductImages(
          productId,
          imagePaths,
        );
        return Right(imageUrls);
      } on ServerException {
        return Left(ServerFailure());
      } on NetworkException {
        return Left(NetworkFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<Category>>> getCategories() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCategories = await remoteDataSource.getCategories();
        await localDataSource.cacheCategories(remoteCategories);
        return Right(remoteCategories);
      } on ServerException {
        return Left(ServerFailure());
      } on NetworkException {
        return Left(NetworkFailure());
      }
    } else {
      try {
        final localCategories = await localDataSource.getCachedCategories();
        return Right(localCategories);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
