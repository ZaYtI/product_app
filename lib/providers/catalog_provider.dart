import 'package:flutter/foundation.dart';
import 'package:product_app/models/product.dart';

class CatalogProvider extends ChangeNotifier {
  List<Product> _products = [];
  Set<String> _favoriteIds = {};
  bool isLoading = true;

  List<Product> get products => _products;
  Set<String> get favoriteIds => _favoriteIds;

  List<Product> get favoriteProducts =>
      _products.where((p) => _favoriteIds.contains(p.id)).toList();

  bool isFavorite(String id) => _favoriteIds.contains(id);

  Future<void> load() async {
    _products = await Product.loadAll();
    _favoriteIds = await Product.loadFavoriteIds();
    isLoading = false;
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    await product.insert();
    _products = [..._products, product];
    notifyListeners();
  }

  Future<void> removeProducts(Set<String> ids) async {
    for (final id in ids) {
      final product = _products.firstWhere((p) => p.id == id);
      await product.delete();
      _favoriteIds.remove(id);
    }
    _products = _products.where((p) => !ids.contains(p.id)).toList();
    notifyListeners();
  }

  Future<void> toggleFavorite(String id) async {
    final product = _products.firstWhere((p) => p.id == id);

    if (_favoriteIds.contains(id)) {
      _favoriteIds.remove(id);
      await product.removeFromFavorites();
    } else {
      _favoriteIds.add(id);
      await product.addToFavorites();
    }
    notifyListeners();
  }
}
