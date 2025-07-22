import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final int id;
  final String name;
  final String thumbnail;
  final List<String> images;
  final String description;
  final int price;
  final int categoryId;
  final String categoryName;
  final int stock;
  final String stockStatus;

  const Product({
    required this.id,
    required this.name,
    required this.thumbnail,
    required this.images,
    required this.description,
    required this.price,
    required this.categoryId,
    required this.categoryName,
    required this.stock,
    required this.stockStatus,
  });

  @override
  List<Object> get props => [
    id,
    name,
    thumbnail,
    images,
    description,
    price,
    categoryId,
    categoryName,
    stock,
    stockStatus,
  ];
}
