import 'dart:convert';
import 'package:product_management_client/core/error/exceptions.dart';
import 'package:product_management_client/core/services/database.dart';
import '../models/product_model.dart';
import '../models/category_model.dart';

abstract class ProductLocalDataSource {
  Future<List<ProductModel>> getCachedProducts();
  Future<void> cacheProducts(List<ProductModel> products);
  Future<List<CategoryModel>> getCachedCategories();
  Future<void> cacheCategories(List<CategoryModel> categories);
  Future<void> clearCache();
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final DatabaseHelper databaseHelper;

  ProductLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<List<ProductModel>> getCachedProducts() async {
    try {
      final db = await databaseHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'products',
        orderBy: 'updated_at DESC',
      );

      return maps.map((map) {
        final productMap = Map<String, dynamic>.from(map);
        productMap['images'] = json.decode(map['images'] as String);
        return ProductModel.fromJson(productMap);
      }).toList();
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheProducts(List<ProductModel> products) async {
    try {
      final db = await databaseHelper.database;
      final batch = db.batch();

      await db.delete('products');

      for (final product in products) {
        final productMap = product.toJson();
        productMap['images'] = json.encode(product.images);
        productMap['created_at'] = DateTime.now().millisecondsSinceEpoch;
        productMap['updated_at'] = DateTime.now().millisecondsSinceEpoch;

        batch.insert('products', productMap);
      }

      await batch.commit();
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<List<CategoryModel>> getCachedCategories() async {
    try {
      final db = await databaseHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'categories',
        orderBy: 'name ASC',
      );

      return maps.map((map) => CategoryModel.fromJson(map)).toList();
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheCategories(List<CategoryModel> categories) async {
    try {
      final db = await databaseHelper.database;
      final batch = db.batch();

      await db.delete('categories');

      for (final category in categories) {
        final categoryMap = category.toJson();
        categoryMap['created_at'] = DateTime.now().millisecondsSinceEpoch;
        categoryMap['updated_at'] = DateTime.now().millisecondsSinceEpoch;

        batch.insert('categories', categoryMap);
      }

      await batch.commit();
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await databaseHelper.clearAllTables();
    } catch (e) {
      throw CacheException();
    }
  }
}
