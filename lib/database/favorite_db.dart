// ignore_for_file: depend_on_referenced_packages

import 'package:online_shopping/product/model/product_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:synchronized/synchronized.dart';

class FavoriteDB {
  final _lock = Lock();
  String dbName;

  FavoriteDB({required this.dbName});

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

  Future<int> insertFavorite(ProductModel productModel) async {
    return _lock.synchronized(() async {
      final db = await openDatabase();
      final store = intMapStoreFactory.store('favorite');
      final keyId = store.add(db, productModel.toJson());
      db.close();

      return keyId;
    });
  }

  Future<List<ProductModel>> loadFavoriteData() async {
    return _lock.synchronized(() async {
      final db = await openDatabase();
      final store = intMapStoreFactory.store('favorite');

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

  Future<ProductModel?> getFavorite(ProductModel productModel) async {
    loadFavoriteData();
    return _lock.synchronized(() async {
      final db = await openDatabase();
      final store = intMapStoreFactory.store('favorite');

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

  removeFavorite(ProductModel productModel) async {
    _lock.synchronized(() async {
      final db = await openDatabase();
      final store = intMapStoreFactory.store('favorite');

      final finder = Finder(filter: Filter.equals('id', productModel.id));

      await store.delete(db, finder: finder);
      db.close();
    });
  }
}
