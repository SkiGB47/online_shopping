// ignore_for_file: depend_on_referenced_packages

import 'package:online_shopping/homepage/model/product_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:synchronized/synchronized.dart';

class CartDB {
  final _lock = Lock();
  String dbName;

  CartDB({required this.dbName});

  Future<String> dbPath() async {
    final appDirectory = await getApplicationDocumentsDirectory();
    await appDirectory.create(recursive: true);
    final path = join(appDirectory.path, dbName);

    return path;
  }

  clearDB() async {
    String path = await dbPath();
    await databaseFactoryIo.deleteDatabase(path);
  }

  Future<Database> openDatabase() async {
    final path = await dbPath();
    final Database db = await databaseFactoryIo.openDatabase(path);

    return db;
  }

  Future<int> insertCart(ProductModel productModel) async {
    int keyId = 0;
    final itemCart = await getCart(productModel);
    return _lock.synchronized(() async {
      final db = await openDatabase();
      final store = intMapStoreFactory.store('cart');
      productModel.quentity++;
      if (itemCart != null) {
        keyId = await store.update(db, productModel.toJson());
      } else {
        keyId = await store.add(db, productModel.toJson());
      }
      db.close();

      return keyId;
    });
  }

  Future<List<ProductModel>> loadCartData() async {
    return _lock.synchronized(() async {
      final db = await openDatabase();
      final store = intMapStoreFactory.store('cart');

      final snapShot = await store.find(db);
      List<ProductModel> result = snapShot
          .map(
            (item) => ProductModel.fromSnapshot(item),
          )
          .toList();

      db.close();

      return result;
    });
  }

  Future<ProductModel?> getCart(ProductModel productModel) async {
    loadCartData();
    return _lock.synchronized(() async {
      final db = await openDatabase();
      final store = intMapStoreFactory.store('cart');

      final finder = Finder(filter: Filter.equals('id', productModel.id));

      final snapShot = await store.find(db, finder: finder);
      List<ProductModel> result = snapShot
          .map(
            (item) => ProductModel.fromSnapshot(item),
          )
          .toList();

      db.close();

      return result.isEmpty ? null : result.first;
    });
  }

  removeCart(ProductModel productModel) async {
    _lock.synchronized(() async {
      final db = await openDatabase();
      final store = intMapStoreFactory.store('cart');

      final finder = Finder(filter: Filter.equals('id', productModel.id));

      await store.delete(db, finder: finder);
      db.close();
    });
  }
}
