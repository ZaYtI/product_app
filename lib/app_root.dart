import 'package:flutter/material.dart';
import 'package:product_app/screens/add_product.dart';
import 'package:product_app/screens/catalog.dart';
import 'package:product_app/screens/favorite.dart';
import 'package:provider/provider.dart';

import 'providers/catalog_provider.dart';

class AppRoot extends StatefulWidget {
  const AppRoot({super.key});
  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  int currentIndex = 0;

  static const titles = ['Mon mini-catalogue', 'Mes favoris'];
  static const screens = [CatalogScreen(), FavoritesScreen()];

  @override
  Widget build(BuildContext context) {
    final catalog = context.watch<CatalogProvider>();

    if (catalog.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final favoriteCount = catalog.favoriteIds.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[currentIndex]),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                const Icon(Icons.favorite, color: Colors.indigo),
                const SizedBox(width: 4),
                Text('$favoriteCount'),
              ],
            ),
          ),
        ],
      ),
      body: screens[currentIndex],
      floatingActionButton: currentIndex == 0
          ? FloatingActionButton(
              shape: const CircleBorder(),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const AddProductScreen()),
              ),
              child: const Icon(Icons.add),
            )
          : null,
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (i) => setState(() => currentIndex = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.grid_view),
            label: 'Catalogue',
          ),
          NavigationDestination(icon: Icon(Icons.favorite), label: 'Favoris'),
        ],
      ),
    );
  }
}
