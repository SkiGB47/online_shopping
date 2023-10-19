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
    rootBundle.loadString('assets/json/appendix_a.json').then((jsonStr) {
      debugPrint('json Str : $jsonStr');
      bannerList.addAll(bannerModelFromJson(jsonStr));
      bannerList.refresh();
    });
  }

  callProductList() {
    productList.clear();
    rootBundle.loadString('assets/json/appendix_b.json').then((jsonStr) {
      productList.addAll(productModelFromJson(jsonStr));
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
