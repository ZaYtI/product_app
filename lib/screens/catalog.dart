import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:product_app/providers/catalog_provider.dart';
import 'package:product_app/widgets/product_list_section.dart';

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final catalog = context.watch<CatalogProvider>();

    return ProductListSection(
      title: 'Les produits',
      subtitle: '${catalog.products.length} produits à découvrir',
      canDelete: true,
      products: catalog.products,
      favoriteIds: catalog.favoriteIds,
      onToggleFavorite: catalog.toggleFavorite,
      onDeleteSelected: catalog.removeProducts,
    );
  }
}
