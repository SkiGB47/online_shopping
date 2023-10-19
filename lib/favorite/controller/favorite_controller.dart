import 'package:get/get.dart';
import 'package:online_shopping/database/cart_db.dart';
import 'package:online_shopping/database/favorite_db.dart';
import 'package:online_shopping/product/model/product_model.dart';

class FavoriteController extends GetxController {
  final favoriteDB = FavoriteDB(dbName: 'favorite.db');
  final cartDB = CartDB(dbName: 'cart.db');
  RxList<ProductModel> productList = <ProductModel>[].obs;

  getFavoriteList() async {
    productList.clear();
    final cartList = await cartDB.loadCartData();
    final favoriteList = await favoriteDB.loadFavoriteData();
    for (final favoriteItem in favoriteList) {
      final cartMath = cartList.firstWhereOrNull((element) => element.id == favoriteItem.id);
      if (cartMath == null) {
        favoriteItem.quentity = 0;
      } else {
        favoriteItem.quentity = cartMath.quentity;
      }
    }
    productList.addAll(favoriteList);
    productList.refresh();
  }

  removeFavorite(ProductModel productModel) async {
    await favoriteDB.removeFavorite(productModel);
    getFavoriteList();
  }

  removeAllFavorite() async {
    await favoriteDB.clearDB();
    productList.clear();
    productList.refresh();
  }
}
