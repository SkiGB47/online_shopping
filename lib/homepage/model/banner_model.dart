import 'dart:convert';

List<BannerModel> bannerModelFromJson(String str) {
  return (jsonDecode(str)['banner_items'] as List<dynamic>).map((e) => BannerModel.fromJson(e)).toList();
}

class BannerModel {
  BannerModel({
    this.id,
    this.imgUrl,
  });

  int? id;
  String? imgUrl;

  factory BannerModel.fromJson(Map<String, dynamic> json) => BannerModel(
        id: json["id"],
        imgUrl: json["image_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image_url": imgUrl,
      };
}
