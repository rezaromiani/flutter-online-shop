import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nike_store/data/product.dart';

final FavoriteManager favoriteManager = FavoriteManager();

class FavoriteManager {
  static const _boxname = 'favorites';
  final _box = Hive.box<ProductEntity>(_boxname);
  ValueListenable<Box<ProductEntity>> get listenable =>
      Hive.box<ProductEntity>(_boxname).listenable();
  void addFavorite(ProductEntity productEntity) {
    _box.put(productEntity.id, productEntity);
  }

  void delete(ProductEntity productEntity) {
    _box.delete(productEntity.id);
  }

  List<ProductEntity> get getAll => _box.values.toList();

  bool isFavorite(ProductEntity productEntity) {
    return _box.containsKey(productEntity.id);
  }

  static init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ProductEntityAdapter());
    Hive.openBox<ProductEntity>(_boxname);
  }
}
