import 'package:get/get.dart';
import 'package:online_shopping/database/cart_db.dart';
import 'package:online_shopping/product/model/product_model.dart';

class CartController extends GetxController {
  final cartDB = CartDB(dbName: 'cart.db');
  RxList<ProductModel> productList = <ProductModel>[].obs;

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
}
