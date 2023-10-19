import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:online_shopping/homepage/model/banner_model.dart';
import 'package:online_shopping/homepage/model/product_model.dart';

class HomeController extends GetxController {
  RxList<BannerModel> bannerList = <BannerModel>[].obs;
  RxInt bannerIndex = 0.obs;

  RxList<ProductModel> productList = <ProductModel>[].obs;

  callBannerList() {
    bannerList.clear();
    rootBundle.loadString('assets/json/appendix_a.json').then((jsonStr) async {
      debugPrint('json Str : $jsonStr');
      final bannerModel = bannerModelFromJson(jsonStr);
      for (final bannerIndex in bannerModel) {
        final checkImgExits = await validateImage(bannerIndex.imgUrl ?? '');
        if (!checkImgExits) {
          bannerIndex.imgUrl = 'https://t4.ftcdn.net/jpg/04/73/25/49/360_F_473254957_bxG9yf4ly7OBO5I0O5KABlN930GwaMQz.jpg';
        }
      }
      bannerList.addAll(bannerModel);

      bannerList.refresh();
    });
  }

  callProductList() {
    productList.clear();
    rootBundle.loadString('assets/json/appendix_b.json').then((jsonStr) async {
      final productModel = productModelFromJson(jsonStr);
      for (final productIndex in productModel) {
        final checkImgExits = await validateImage(productIndex.imgUrl ?? '');
        if (!checkImgExits) {
          productIndex.imgUrl = 'https://t4.ftcdn.net/jpg/04/73/25/49/360_F_473254957_bxG9yf4ly7OBO5I0O5KABlN930GwaMQz.jpg';
        }
      }
      productList.addAll(productModel);
      productList.refresh();
    });
  }

  Future<bool> validateImage(String imageUrl) async {
    http.Response res;
    try {
      res = await http.get(Uri.parse(imageUrl));
    } catch (e) {
      return false;
    }

    if (res.statusCode != 200) return false;
    Map<String, dynamic> data = res.headers;
    if (data['content-type'] == 'image/jpeg' || data['content-type'] == 'image/png' || data['content-type'] == 'image/gif') {
      return true;
    }
    return false;
  }
}
