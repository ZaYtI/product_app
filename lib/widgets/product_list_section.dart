import 'package:flutter/material.dart';
import 'package:product_app/models/product.dart';
import 'package:product_app/widgets/product_card.dart';

class ProductListSection extends StatefulWidget {
  final String title;
  final String subtitle;
  final bool canDelete;
  final List<Product> products;
  final Set<String> favoriteIds;
  final void Function(String id) onToggleFavorite;
  final Future<void> Function(Set<String> ids)? onDeleteSelected;
  final Future<void> Function(Set<String> ids)? onAddSelectedToFavorites;
  final Widget? emptyState;

  const ProductListSection({
    super.key,
    required this.title,
    required this.subtitle,
    this.canDelete = false,
    required this.products,
    required this.favoriteIds,
    required this.onToggleFavorite,
    this.onDeleteSelected,
    this.onAddSelectedToFavorites,
    this.emptyState,
  });

  @override
  State<ProductListSection> createState() => _ProductListSectionState();
}

class _ProductListSectionState extends State<ProductListSection> {
  bool isCompact = false;
  bool isSelectionMode = false;
  Set<String> selectedIds = {};

  void _toggleSelectionMode() {
    setState(() {
      isSelectionMode = !isSelectionMode;
      selectedIds = {};
    });
  }

  void _toggleSelected(String id) {
    setState(() {
      if (selectedIds.contains(id)) {
        selectedIds.remove(id);
      } else {
        selectedIds.add(id);
      }
    });
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer les produits'),
        content: Text(
          'Voulez-vous vraiment supprimer ${selectedIds.length} produit(s) ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await widget.onDeleteSelected?.call(selectedIds);
      setState(() {
        isSelectionMode = false;
        selectedIds = {};
      });
    }
  }

  Future<void> _addSelectedToFavorites() async {
    await widget.onAddSelectedToFavorites?.call(selectedIds);
    setState(() {
      isSelectionMode = false;
      selectedIds = {};
    });
  }

  bool get _canSelect =>
      widget.canDelete || widget.onAddSelectedToFavorites != null;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (_canSelect)
                    TextButton.icon(
                      onPressed: _toggleSelectionMode,
                      icon: Icon(
                        isSelectionMode ? Icons.close : Icons.checklist,
                        size: 18,
                      ),
                      label: Text(isSelectionMode ? 'Annuler' : 'Sélectionner'),
                    ),
                ],
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
                        isSelectionMode: isSelectionMode,
                        isSelected: selectedIds.contains(product.id),
                        onTap: () => _toggleSelected(product.id),
                      ),
                    );
                  },
                ),
        ),
        if (isSelectionMode && selectedIds.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                if (widget.onAddSelectedToFavorites != null)
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: _addSelectedToFavorites,
                      icon: const Icon(Icons.favorite),
                      label: Text('Ajouter (${selectedIds.length})'),
                    ),
                  ),
                if (widget.onAddSelectedToFavorites != null &&
                    widget.onDeleteSelected != null)
                  const SizedBox(width: 12),
                if (widget.onDeleteSelected != null)
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: _confirmDelete,
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      icon: const Icon(Icons.delete),
                      label: Text('Supprimer (${selectedIds.length})'),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
