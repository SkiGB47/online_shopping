import 'package:get/get.dart';
import 'package:online_shopping/database/favorite_db.dart';
import 'package:online_shopping/homepage/model/product_model.dart';

class ProductController extends GetxController {
  final favoriteDB = FavoriteDB(dbName: 'favorite.db');
  RxBool isFavorite = false.obs;

  checkFavorite(ProductModel productModel) async {
    await favoriteDB.getFavorite(productModel).then((value) => (value != null) ? isFavorite(true) : null);
  }

  toggleFavorite(ProductModel productModel) async {
    if (isFavorite.value) {
      await favoriteDB.removeFavorite(productModel);
    } else {
      await favoriteDB.insertFavorite(productModel);
    }
    isFavorite(!isFavorite.value);
  }
}
