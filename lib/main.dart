import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_root.dart';
import 'providers/catalog_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CatalogProvider()..load(),
      child: MaterialApp(
        title: 'Mon mini-catalogue',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          useMaterial3: true,
        ),
        home: const AppRoot(),
      ),
    );
  }
}
