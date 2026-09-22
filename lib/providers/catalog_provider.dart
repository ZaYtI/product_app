import 'package:flutter/foundation.dart';
import 'package:product_app/data/sample_product.dart';
import 'package:product_app/models/product.dart';

class CatalogProvider extends ChangeNotifier {
  final List<Product> products = sampleProducts;
  final Set<String> _favoriteIds = {};

  Set<String> get favoriteIds => _favoriteIds;

  List<Product> get favoriteProducts =>
      products.where((p) => _favoriteIds.contains(p.id)).toList();

  bool isFavorite(String id) => _favoriteIds.contains(id);

  void toggleFavorite(String id) {
    if (_favoriteIds.contains(id)) {
      _favoriteIds.remove(id);
    } else {
      _favoriteIds.add(id);
    }
    notifyListeners();
  }
}
