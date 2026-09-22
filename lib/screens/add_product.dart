import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:product_app/models/product.dart';
import 'package:product_app/providers/catalog_provider.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  static const availableIcons = [
    Icons.devices_other,
    Icons.keyboard,
    Icons.headphones,
    Icons.mouse,
    Icons.laptop,
    Icons.watch,
    Icons.camera_alt,
    Icons.speaker,
  ];

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  IconData _selectedIcon = availableIcons.first;
  Uint8List? _image;
  bool _isSaving = false;

  Future<void> _pickImage() async {
    final file = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      imageQuality: 80,
    );
    if (file == null) return;
    final bytes = await file.readAsBytes();
    setState(() => _image = bytes);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final product = Product(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      price: double.parse(_priceController.text.replaceAll(',', '.')),
      description: _descriptionController.text.trim(),
      icon: _selectedIcon,
      image: _image,
    );

    await context.read<CatalogProvider>().addProduct(product);

    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nouveau produit')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nom'),
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? 'Le nom est requis'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: 'Prix (€)'),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Le prix est requis';
                }
                final parsed = double.tryParse(value.replaceAll(',', '.'));
                if (parsed == null || parsed < 0) {
                  return 'Prix invalide';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? 'La description est requise'
                  : null,
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Icône',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: availableIcons.map((icon) {
                final isSelected = icon == _selectedIcon;
                return InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () => setState(() => _selectedIcon = icon),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.indigo.shade100
                          : Colors.indigo.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: isSelected
                          ? Border.all(color: Colors.indigo, width: 2)
                          : null,
                    ),
                    child: Icon(icon, color: Colors.indigo),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            if (_image != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.memory(_image!, height: 180, fit: BoxFit.cover),
              ),
              const SizedBox(height: 8),
            ],
            OutlinedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.image_outlined),
              label: Text(
                _image == null ? 'Ajouter une image' : "Changer l'image",
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _isSaving ? null : _submit,
              child: _isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Ajouter le produit'),
            ),
          ],
        ),
      ),
    );
  }
}
