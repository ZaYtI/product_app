import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:product_app/models/product.dart';
import 'package:product_app/providers/catalog_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final catalog = context.watch<CatalogProvider>();
    final isFavorite = catalog.isFavorite(product.id);

    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: product.image != null
                ? Image.memory(product.image!, height: 250, fit: BoxFit.cover)
                : Container(
                    height: 250,
                    color: Colors.indigo.shade50,
                    child: Icon(product.icon, size: 96, color: Colors.indigo),
                  ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                '${product.price.toStringAsFixed(2)} €',
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(product.description),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => catalog.toggleFavorite(product.id),
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
            label: Text(
              isFavorite ? 'Retirer des favoris' : 'Ajouter aux favoris',
            ),
          ),
        ],
      ),
    );
  }
}
