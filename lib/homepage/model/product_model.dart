import 'dart:convert';

import 'package:sembast/sembast.dart';

List<ProductModel> productModelFromJson(String str) =>
    (jsonDecode(str)['product_items'] as List<dynamic>).map((e) => ProductModel.fromJson(e)).toList();

class ProductModel {
  ProductModel({
    this.id,
    this.name,
    this.imgUrl,
    this.price,
  });

  int? id;
  String? name;
  String? imgUrl;
  int? price;

  Map<String, dynamic> toJson() => {"id": id, "name": name, "image_url": imgUrl, "price": price};

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["id"],
        name: json["name"],
        imgUrl: json["image_url"],
        price: json["price"],
      );

  factory ProductModel.fromSnapshot(RecordSnapshot<int, Map<String, Object?>> record) => ProductModel(
        id: record["id"] as int,
        name: record["name"] as String,
        imgUrl: record["image_url"] as String,
        price: record["price"] as int,
      );
}
