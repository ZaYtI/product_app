import 'package:flutter/material.dart';
import 'package:product_app/utils/has_fab.dart';
import 'package:provider/provider.dart';

import 'package:product_app/providers/catalog_provider.dart';
import 'package:product_app/screens/add_favorite.dart';
import 'package:product_app/widgets/empty_state.dart';
import 'package:product_app/widgets/product_list_section.dart';

class FavoritesScreen extends StatelessWidget
    implements HasFloatingActionButton {
  const FavoritesScreen({super.key});

  @override
  Widget buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      shape: const CircleBorder(),
      onPressed: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const AddFavoriteScreen()),
      ),
      child: const Icon(Icons.add),
    );
  }

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
