import 'package:flutter/material.dart';
import 'package:product_app/models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final bool isFavorite;
  final bool isCompact;
  final VoidCallback onToggleFavorite;

  const ProductCard({
    super.key,
    required this.product,
    required this.isFavorite,
    required this.isCompact,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(product.icon, color: Colors.indigo),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    product.name,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                Text('${product.price.toStringAsFixed(2)} €'),
              ],
            ),
            if (!isCompact) ...[
              const SizedBox(height: 8),
              Text(
                product.description,
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: onToggleFavorite,
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  size: 18,
                ),
                label: Text(
                  isFavorite ? 'Retirer des favoris' : 'Ajouter aux favoris',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
