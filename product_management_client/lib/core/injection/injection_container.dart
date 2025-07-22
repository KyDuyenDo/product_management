import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:product_management_client/core/network/network_info.dart';
import 'package:product_management_client/core/services/database.dart';
import 'package:product_management_client/core/services/upload_api_image.dart';
import 'package:product_management_client/features/product/data/datasources/product_local_data_source.dart';
import 'package:product_management_client/features/product/data/datasources/product_remote_data_source.dart';
import 'package:product_management_client/features/product/data/repositories/product_repository_impl.dart';
import 'package:product_management_client/features/product/domain/repositories/product_repository.dart';
import 'package:product_management_client/features/product/domain/usecase/add_product.dart';
import 'package:product_management_client/features/product/domain/usecase/delete_product.dart';
import 'package:product_management_client/features/product/domain/usecase/get_category.dart';
import 'package:product_management_client/features/product/domain/usecase/get_product.dart';
import 'package:product_management_client/features/product/domain/usecase/get_product_detail.dart';
import 'package:product_management_client/features/product/domain/usecase/update_product.dart';
import 'package:product_management_client/features/product/presentation/bloc/product_detail_bloc/product_detail_bloc.dart';
import 'package:product_management_client/features/product/presentation/bloc/product_form_bloc/product_form_bloc.dart';
import 'package:product_management_client/features/product/presentation/bloc/product_list_bloc/product_list_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // BLoCs
  sl.registerFactory(
    () => ProductListBloc(getProducts: sl(), getCategories: sl()),
  );

  sl.registerFactory(
    () => ProductDetailBloc(getProductDetail: sl(), deleteProduct: sl()),
  );

  sl.registerFactory(
    () => ProductFormBloc(
      getProductDetail: sl(),
      addProduct: sl(),
      updateProduct: sl(),
      getCategories: sl(),
      uploadApiImage: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetProducts(sl()));
  sl.registerLazySingleton(() => GetCategories(sl()));
  sl.registerLazySingleton(() => GetProductDetail(sl()));
  sl.registerLazySingleton(() => UpdateProduct(sl()));
  sl.registerLazySingleton(() => DeleteProduct(sl()));
  sl.registerLazySingleton(() => AddProduct(sl()));

  // Repository
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data Sources
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton<ProductLocalDataSource>(
    () => ProductLocalDataSourceImpl(databaseHelper: sl()),
  );

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());

  // Services
  sl.registerLazySingleton(() => ImgBBUploadService());

  // Database
  sl.registerLazySingleton(() => DatabaseHelper());

  // External
  sl.registerLazySingleton(() => http.Client());
}
