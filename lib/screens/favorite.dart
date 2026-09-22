import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:product_app/providers/catalog_provider.dart';
import 'package:product_app/widgets/empty_state.dart';
import 'package:product_app/widgets/product_list_section.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final catalog = context.watch<CatalogProvider>();
    final favoriteProducts = catalog.favoriteProducts;

    return ProductListSection(
      title: 'Mes favoris',
      subtitle: '${favoriteProducts.length} produits enregistrés',
      products: favoriteProducts,
      favoriteIds: catalog.favoriteIds,
      onToggleFavorite: catalog.toggleFavorite,
      emptyState: const EmptyFavoritesState(),
    );
  }
}
