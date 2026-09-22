import 'package:flutter/material.dart';
import 'package:product_app/models/product.dart';
import 'package:product_app/widgets/product_card.dart';

class ProductListSection extends StatefulWidget {
  final String title;
  final String subtitle;
  final List<Product> products;
  final Set<String> favoriteIds;
  final void Function(String id) onToggleFavorite;
  final Widget? emptyState;

  const ProductListSection({
    super.key,
    required this.title,
    required this.subtitle,
    required this.products,
    required this.favoriteIds,
    required this.onToggleFavorite,
    this.emptyState,
  });

  @override
  State<ProductListSection> createState() => _ProductListSectionState();
}

class _ProductListSectionState extends State<ProductListSection> {
  bool isCompact = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.subtitle,
                style: TextStyle(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: () => setState(() => isCompact = !isCompact),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                    icon: Icon(
                      isCompact
                          ? Icons.view_agenda_outlined
                          : Icons.view_list_outlined,
                      size: 18,
                    ),
                    label: Text(
                      isCompact ? 'Affichage détaillé' : 'Affichage compact',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: widget.products.isEmpty && widget.emptyState != null
              ? widget.emptyState!
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  itemCount: widget.products.length,
                  itemBuilder: (context, index) {
                    final product = widget.products[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: ProductCard(
                        product: product,
                        isCompact: isCompact,
                        isFavorite: widget.favoriteIds.contains(product.id),
                        onToggleFavorite: () =>
                            widget.onToggleFavorite(product.id),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
