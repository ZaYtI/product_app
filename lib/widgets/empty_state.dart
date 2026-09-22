import 'package:flutter/material.dart';

class EmptyFavoritesState extends StatelessWidget {
  const EmptyFavoritesState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.favorite_border, size: 64, color: Colors.indigo.shade200),
          const SizedBox(height: 16),
          const Text(
            'Aucun produit favori pour le moment.',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            'Désactivez le filtre pour retrouver\nle catalogue et choisir vos favoris.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}
