import 'package:flutter/material.dart';

import '../models/product.dart';

final List<Product> sampleProducts = [
  const Product(
    id: 'keyboard',
    name: 'Clavier compact',
    price: 49.90,
    description: 'Un clavier léger et peu encombrant, idéal pour travailler au quotidien.',
    icon: Icons.keyboard,
  ),
  const Product(
    id: 'headphones',
    name: 'Casque audio',
    price: 79.90,
    description:
        'Un casque confortable pour écouter de la musique et suivre vos cours.',
    icon: Icons.headphones,
  ),
  const Product(
    id: 'mouse',
    name: 'Souris sans fil',
    price: 29.90,
    description:
        'Une souris précise, facile à transporter et agréable à utiliser.',
    icon: Icons.mouse,
  ),
];
