import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:product_app/data/app_database.dart';
import 'package:product_app/data/sample_product.dart';
import 'package:sqflite/sqflite.dart';

class Product {
  final String id;
  final String name;
  final double price;
  final String description;
  final IconData icon;
  final Uint8List? image;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.icon,
    this.image,
  });

  factory Product.fromMap(Map<String, Object?> map) {
    return Product(
      id: map['id'] as String,
      name: map['name'] as String,
      price: map['price'] as double,
      description: map['description'] as String,
      icon: IconData(
        // ignore: non_const_argument_for_const_parameter
        map['icon_code_point'] as int,
        fontFamily: 'MaterialIcons',
      ),
      image: map['image'] as Uint8List?,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'description': description,
      'icon_code_point': icon.codePoint,
      'image': image,
    };
  }

  static Future<List<Product>> loadAll() async {
    final db = await appDatabase;
    final rows = await db.query('products');

    if (rows.isEmpty) {
      for (final product in sampleProducts) {
        await db.insert('products', product.toMap());
      }
      return sampleProducts;
    }

    return rows.map(Product.fromMap).toList();
  }

  static Future<Set<String>> loadFavoriteIds() async {
    final db = await appDatabase;
    final rows = await db.query('favorites');
    return rows.map((row) => row['product_id'] as String).toSet();
  }

  Future<void> addToFavorites() async {
    final db = await appDatabase;
    await db.insert('favorites', {
      'product_id': id,
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<void> removeFromFavorites() async {
    final db = await appDatabase;
    await db.delete('favorites', where: 'product_id = ?', whereArgs: [id]);
  }

  Future<void> insert() async {
    final db = await appDatabase;
    await db.insert('products', toMap());
  }

  Future<void> delete() async {
    final db = await appDatabase;
    await db.delete('favorites', where: 'product_id = ?', whereArgs: [id]);
    await db.delete('products', where: 'id = ?', whereArgs: [id]);
  }
}
