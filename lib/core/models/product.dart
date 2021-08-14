import 'dart:convert';

List<Product> productFromJson(String str) =>
    List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

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
}
