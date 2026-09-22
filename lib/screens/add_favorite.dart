import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:product_app/providers/catalog_provider.dart';

class AddFavoriteScreen extends StatefulWidget {
  const AddFavoriteScreen({super.key});

  @override
  State<AddFavoriteScreen> createState() => _AddFavoriteScreenState();
}

class _AddFavoriteScreenState extends State<AddFavoriteScreen> {
  final Set<String> _selectedIds = {};

  Future<void> _confirm() async {
    await context.read<CatalogProvider>().addFavorites(_selectedIds);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final catalog = context.watch<CatalogProvider>();
    final available = catalog.products
        .where((p) => !catalog.favoriteIds.contains(p.id))
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter des favoris')),
      body: available.isEmpty
          ? const Center(child: Text('Tous les produits sont déjà en favoris.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: available.length,
              itemBuilder: (context, index) {
                final product = available[index];
                final isSelected = _selectedIds.contains(product.id);
                return CheckboxListTile(
                  value: isSelected,
                  onChanged: (checked) {
                    setState(() {
                      if (checked == true) {
                        _selectedIds.add(product.id);
                      } else {
                        _selectedIds.remove(product.id);
                      }
                    });
                  },
                  secondary: Icon(product.icon, color: Colors.indigo),
                  title: Text(product.name),
                  subtitle: Text('${product.price.toStringAsFixed(2)} €'),
                );
              },
            ),
      bottomNavigationBar: _selectedIds.isEmpty
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: FilledButton.icon(
                  onPressed: _confirm,
                  icon: const Icon(Icons.favorite),
                  label: Text('Ajouter (${_selectedIds.length})'),
                ),
              ),
            ),
    );
  }
}
