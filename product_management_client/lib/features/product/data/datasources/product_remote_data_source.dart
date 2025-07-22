import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:product_management_client/core/error/exceptions.dart';
import '../models/product_model.dart';
import '../models/category_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts({String? query, int? categoryId});
  Future<ProductModel> getProductById(int id);
  Future<ProductModel> createProduct(ProductModel product);
  Future<ProductModel> updateProduct(ProductModel product);
  Future<void> deleteProduct(int id);
  Future<List<String>> uploadProductImages(
    int productId,
    List<String> imagePaths,
  );
  Future<List<CategoryModel>> getCategories();
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final http.Client client;

  ProductRemoteDataSourceImpl({required this.client});

  final baseUrl = "https://mock-api-bjd9.onrender.com";

  @override
  Future<List<ProductModel>> getProducts({
    String? query,
    int? categoryId,
  }) async {
    final queryParams = <String, String>{};
    if (query != null && query.isNotEmpty) {
      queryParams['q'] = query;
      queryParams['search'] = query;
    }
    if (categoryId != null) {
      queryParams['categoryId'] = categoryId.toString();
      queryParams['category_id'] = categoryId.toString();
    }

    final uri = Uri.parse(
      '$baseUrl/products',
    ).replace(queryParameters: queryParams);

    try {
      final response = await client
          .get(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final dynamic decodedResponse = json.decode(response.body);
        List<dynamic> jsonList;

        if (decodedResponse is Map<String, dynamic>) {
          if (decodedResponse.containsKey('products')) {
            jsonList = decodedResponse['products'] as List<dynamic>;
          } else if (decodedResponse.containsKey('product')) {
            jsonList = decodedResponse['product'] as List<dynamic>;
          } else {
            throw ServerException();
          }
        } else if (decodedResponse is List<dynamic>) {
          jsonList = decodedResponse;
        } else {
          throw ServerException();
        }

        final products =
            jsonList.map((json) => ProductModel.fromJson(json)).toList();

        if (query != null && query.isNotEmpty) {
          return products.where((product) {
            final searchQuery = query.toLowerCase();
            return product.name.toLowerCase().contains(searchQuery) ||
                product.description.toLowerCase().contains(searchQuery) ||
                product.categoryName.toLowerCase().contains(searchQuery);
          }).toList();
        }

        if (categoryId != null) {
          return products
              .where((product) => product.categoryId == categoryId)
              .toList();
        }

        return products;
      } else {
        throw ServerException();
      }
    } on SocketException {
      throw NetworkException();
    } on HttpException {
      throw NetworkException();
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<ProductModel> getProductById(int id) async {
    try {
      final response = await client
          .get(
            Uri.parse('$baseUrl/products/$id'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);
        Map<String, dynamic> productData;

        if (responseData is Map<String, dynamic>) {
          if (responseData.containsKey('product')) {
            productData = responseData['product'] as Map<String, dynamic>;
          } else {
            productData = responseData;
          }
        } else {
          throw ServerException();
        }

        return ProductModel.fromJson(productData);
      } else {
        throw ServerException();
      }
    } on SocketException {
      throw NetworkException();
    } on HttpException {
      throw NetworkException();
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<ProductModel> createProduct(ProductModel product) async {
    try {
      final response = await client
          .post(
            Uri.parse('$baseUrl/products'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: json.encode(product.toJson()),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 201) {
        final dynamic responseData = json.decode(response.body);
        Map<String, dynamic> productData;

        if (responseData is Map<String, dynamic>) {
          if (responseData.containsKey('product')) {
            productData = responseData['product'] as Map<String, dynamic>;
          } else {
            productData = responseData;
          }
        } else {
          throw ServerException();
        }

        return ProductModel.fromJson(productData);
      } else {
        throw ServerException();
      }
    } on SocketException {
      throw NetworkException();
    } on HttpException {
      throw NetworkException();
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<ProductModel> updateProduct(ProductModel product) async {
    try {
      final response = await client
          .put(
            Uri.parse('$baseUrl/products/${product.id}'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: json.encode(product.toJson()),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);
        Map<String, dynamic> productData;

        if (responseData is Map<String, dynamic>) {
          if (responseData.containsKey('product')) {
            productData = responseData['product'] as Map<String, dynamic>;
          } else {
            productData = responseData;
          }
        } else {
          throw ServerException();
        }

        return ProductModel.fromJson(productData);
      } else {
        throw ServerException();
      }
    } on SocketException {
      throw NetworkException();
    } on HttpException {
      throw NetworkException();
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<void> deleteProduct(int id) async {
    try {
      final response = await client
          .delete(
            Uri.parse('$baseUrl/products/$id'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200 ||
          response.statusCode == 204 ||
          response.statusCode == 404) {
        return;
      } else {
        throw ServerException();
      }
    } on SocketException {
      throw NetworkException();
    } on HttpException {
      throw NetworkException();
    } catch (e) {
      if (e.toString().contains('Connection reset by peer') ||
          e.toString().contains('errno = 104')) {
        return;
      }
      throw ServerException();
    }
  }

  @override
  Future<List<String>> uploadProductImages(
    int productId,
    List<String> imagePaths,
  ) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/products/$productId/images'),
      );

      for (String imagePath in imagePaths) {
        request.files.add(
          await http.MultipartFile.fromPath('images', imagePath),
        );
      }

      final streamedResponse = await client.send(request);
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);
        List<String> imageList;

        if (responseData is Map<String, dynamic> &&
            responseData.containsKey('images')) {
          imageList = List<String>.from(responseData['images']);
        } else if (responseData is List) {
          imageList = List<String>.from(responseData);
        } else {
          throw ServerException();
        }

        return imageList;
      } else {
        throw ServerException();
      }
    } on SocketException {
      throw NetworkException();
    } on HttpException {
      throw NetworkException();
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await client
          .get(
            Uri.parse('$baseUrl/categories'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);
        List<dynamic> jsonList;

        if (responseData is Map<String, dynamic>) {
          if (responseData.containsKey('categories')) {
            jsonList = responseData['categories'] as List<dynamic>;
          } else {
            throw ServerException();
          }
        } else if (responseData is List<dynamic>) {
          jsonList = responseData;
        } else {
          throw ServerException();
        }

        return jsonList.map((json) => CategoryModel.fromJson(json)).toList();
      } else {
        throw ServerException();
      }
    } on SocketException {
      throw NetworkException();
    } on HttpException {
      throw NetworkException();
    } catch (e) {
      throw ServerException();
    }
  }
}
