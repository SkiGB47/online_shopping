import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:online_shopping/database/cart_db.dart';
import 'package:online_shopping/product/model/product_model.dart';

class CartController extends GetxController {
  final cartDB = CartDB(dbName: 'cart.db');
  RxList<ProductModel> productList = <ProductModel>[].obs;
  RxBool isCheckingImageUrl = false.obs;

  getCartList() async {
    productList.clear();
    final cartList = await cartDB.loadCartData();
    productList.addAll(cartList);
    productList.refresh();
  }

  manageCartQuentity(ProductModel productModel, bool isPlus) async {
    if (isPlus) {
      await cartDB.insertCart(productModel);
    } else {
      await cartDB.minusCart(productModel);
    }
    getCartList();
  }

  removeCartItem(ProductModel productModel) async {
    await cartDB.removeCart(productModel);
    getCartList();
  }

  Future<bool> validateImage(String imageUrl) async {
    isCheckingImageUrl(true);
    http.Response res;
    try {
      res = await http.get(Uri.parse(imageUrl));
    } catch (e) {
      isCheckingImageUrl(false);
      return false;
    }

    if (res.statusCode != 200) return false;
    Map<String, dynamic> data = res.headers;
    if (data['content-type'] == 'image/jpeg' || data['content-type'] == 'image/png' || data['content-type'] == 'image/gif') {
      isCheckingImageUrl(false);
      return true;
    }
    isCheckingImageUrl(false);
    return false;
  }
}
