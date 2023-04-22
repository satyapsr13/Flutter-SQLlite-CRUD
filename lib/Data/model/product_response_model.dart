// To parse this JSON data, do
//
//     final welcome = welcomeFromMap(jsonString);

import 'dart:convert';

import 'package:meta/meta.dart';

class ProductResponse {
  ProductResponse({
    required this.status,
    required this.message,
    required this.totalRecord,
    required this.totalPage,
    required this.data,
  });

  final int status;
  final String message;
  final int totalRecord;
  final int totalPage;
  final List<Product> data;

  factory ProductResponse.fromMap(Map<String, dynamic> json) => ProductResponse(
        status: json["status"],
        message: json["message"],
        totalRecord: json["totalRecord"],
        totalPage: json["totalPage"],
        data: List<Product>.from(json["data"].map((x) => Product.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "message": message,
        "totalRecord": totalRecord,
        "totalPage": totalPage,
        "data": List<dynamic>.from(data.map((x) => x.toMap())),
      };
}

class Product {
  Product({
    required this.id,
    required this.slug,
    required this.title,
    required this.quantity,
    required this.description,
    required this.price,
    required this.featuredImage,
    // required this.status,
    // required this.createdAt,
  });

  final int id;
  int quantity;
  final String slug;
  final String title;
  final String description;
  final num price;
  final String featuredImage;
  // final String status;
  // final DateTime createdAt;

  factory Product.fromMap(Map<String, dynamic> json) => Product(
        id: json["id"],
        slug: json["slug"],
        title: json["title"],
        quantity: json["quantity"] ?? 0,
        description: json["description"],
        price: json["price"],
        featuredImage: json["featured_image"],
        // status: json["status"],
        // createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "slug": slug,
        "title": title,
        "description": description,
        "quantity": quantity,
        "price": price,
        "featured_image": featuredImage,
        // "status": status,
        // "created_at": createdAt.toIso8601String(),
      };

  @override
  String toString() {
    return 'Product(id: $id, slug: $slug, title: $title, description: $description, price: $price, featuredImage: $featuredImage ,quantity:$quantity)';
  }
}
