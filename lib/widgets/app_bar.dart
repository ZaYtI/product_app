import 'package:flutter/material.dart';
import 'package:product_app/providers/catalog_provider.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final catalog = context.watch<CatalogProvider>();
    final favoriteCount = catalog.favoriteIds.length;
    return AppBar(
      title: Text(title),
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
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
