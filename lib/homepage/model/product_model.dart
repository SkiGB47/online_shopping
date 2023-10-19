import 'dart:convert';

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

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["id"],
        name: json["name"],
        imgUrl: json["image_url"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {"id": id, "name": name, "image_url": imgUrl, "price": price};
}
