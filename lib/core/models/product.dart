// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';

List<Product> productFromJson(String str) =>
    List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

String productToJson(List<Product> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Product {
  Product({
    required this.id,
    required this.parentId,
    required this.picture,
    required this.name,
  });

  int id;
  int parentId;
  String picture;
  String name;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        parentId: json["parentId"] == null ? -1 : json["parentId"],
        picture: json["picture"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        // ignore: unnecessary_null_comparison
        "parentId": parentId == null ? -1 : parentId,
        "picture": picture,
        "name": name,
      };
}
