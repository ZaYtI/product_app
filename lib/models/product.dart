import 'package:flutter/material.dart';

class Product {
  final String id;
  final String name;
  final double price;
  final String description;
  final IconData icon;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.icon,
  });
}
