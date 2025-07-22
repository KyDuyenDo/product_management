import '../../domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.name,
    required super.description,
    required super.thumbnail,
    required super.images,
    required super.stockStatus,
    required super.categoryId,
    required super.categoryName,
    required super.price,
    required super.stock,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: _parseInt(json['id']),
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      thumbnail: json['thumbnail']?.toString() ?? 'https://via.placeholder.com/300',
      images: json['images'] != null 
          ? List<String>.from(json['images'].map((x) => x.toString()))
          : [],
      stockStatus: json['stock_status']?.toString() ?? 'Unknown',
      categoryId: _parseInt(json['category_id']),
      categoryName: json['category_name']?.toString() ?? '',
      price: _parseInt(json['price']),
      stock: _parseInt(json['stock']),
    );
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'thumbnail': thumbnail,
      'images': images,
      'stock_status': stockStatus,
      'category_id': categoryId,
      'category_name': categoryName,
      'price': price,
      'stock': stock,
    };
  }

  factory ProductModel.fromEntity(Product product) {
    return ProductModel(
      id: product.id,
      name: product.name,
      description: product.description,
      thumbnail: product.thumbnail,
      images: product.images,
      stockStatus: product.stockStatus,
      categoryId: product.categoryId,
      categoryName: product.categoryName,
      price: product.price,
      stock: product.stock,
    );
  }
}
