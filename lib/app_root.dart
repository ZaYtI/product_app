import 'package:flutter/material.dart';
import 'package:product_app/screens/catalog.dart';
import 'package:product_app/screens/favorite.dart';
import 'package:product_app/utils/has_fab.dart';
import 'package:provider/provider.dart';

import 'providers/catalog_provider.dart';

class AppRoot extends StatefulWidget {
  const AppRoot({super.key});
  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  int currentIndex = 0;

  static const screens = [CatalogScreen(), FavoritesScreen()];

  @override
  Widget build(BuildContext context) {
    final catalog = context.watch<CatalogProvider>();

    if (catalog.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final screen = screens[currentIndex];
    final fabScreen = screen is HasFloatingActionButton
        ? screen as HasFloatingActionButton
        : null;
    final favoriteCount = catalog.favoriteIds.length;

    return Scaffold(
      body: SafeArea(child: screen),
      floatingActionButton: fabScreen?.buildFloatingActionButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (i) => setState(() => currentIndex = i),
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.grid_view),
            label: 'Catalogue',
          ),
          NavigationDestination(
            icon: Badge(
              label: Text('$favoriteCount'),
              isLabelVisible: favoriteCount > 0,
              child: const Icon(Icons.favorite),
            ),
            label: 'Favoris',
          ),
        ],
      ),
    );
  }
}
