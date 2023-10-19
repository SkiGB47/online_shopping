import 'dart:convert';

import 'package:sembast/sembast.dart';

List<ProductModel> productModelFromJson(String str) =>
    (jsonDecode(str)['product_items'] as List<dynamic>).map((e) => ProductModel.fromJson(e)).toList();

class ProductModel {
  ProductModel({
    required this.id,
    required this.name,
    required this.imgUrl,
    required this.price,
    required this.quentity,
  });

  int? id;
  String? name;
  String? imgUrl;
  int? price;
  int quentity;

  Map<String, dynamic> toJson() => {"id": id, "name": name, "image_url": imgUrl, "price": price, "quentity": quentity};

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["id"],
        name: json["name"],
        imgUrl: json["image_url"],
        price: json["price"],
        quentity: json["quentity"] ?? 0,
      );

  factory ProductModel.fromSnapshot(RecordSnapshot<int, Map<String, Object?>> record) => ProductModel(
        id: record["id"] as int,
        name: record["name"] as String,
        imgUrl: record["image_url"] as String,
        price: record["price"] as int,
        quentity: (record["quentity"] ?? 0) as int,
      );
}
