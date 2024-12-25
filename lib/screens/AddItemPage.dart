import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_inventory_system/controllers/DatabaseController.dart';
import 'package:mobile_inventory_system/models/item_model.dart';

class AddItemPage extends StatefulWidget {
  final Item? item;
  const AddItemPage({super.key, this.item});

  @override
  State<AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _categoryController = TextEditingController();
  final _priceController = TextEditingController();
  final DatabaseController _dbHelper = DatabaseController.instance;
  Uint8List? _image;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // final bytes = await File(pickedFile.path).readAsBytes();
      final imagesBytes = await pickedFile.readAsBytes();
      setState(() {
        // _image = bytes;
        _image = Uint8List.fromList(imagesBytes);
        // _image = Uint8List.fromList(await pickedFile.readAsBytes());
      });
    }
  }

  // Future<void> saveItem() async {
  //   if (_formKey.currentState!.validate()) {
  //     final db = await DatabaseController.instance.database;
  //     await db.insert('items', {
  //       'name': _nameController.text,
  //       'description': _descController.text,
  //       'category': _categoryController.text,
  //       'price': double.tryParse(_priceController.text) ?? 0.0,
  //       'stock': 0,
  //       'imagePath': _image,
  //     });
  //     Navigator.pop(context, true);
  //   }
  // }

  void saveItem() async {
    if (_formKey.currentState!.validate() && _image != null) {
      _formKey.currentState!.save();

      final newItem = Item(
        id: widget.item?.id, // Jika item sudah ada, gunakan ID-nya.
        name: _nameController.text,
        description: _descController.text,
        category: _categoryController.text,
        price: double.tryParse(_priceController.text) ?? 0.0,
        imagePath: _image,
      );

      if (widget.item == null) {
        // Tambah item baru.
        await _dbHelper.insertItem(newItem);
      } else {
        // Perbarui item yang ada.
        await _dbHelper.updateItem(newItem);
      }

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gambar belum dipilih!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _image != null
                  ? Image.memory(_image!, height: 100)
                  : const Text('Belum ada gambar'),
              ElevatedButton(
                onPressed: pickImage,
                child: const Text('Pilih Gambar'),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nama Barang'),
                validator: (value) =>
                    value!.isEmpty ? 'Nama wajib diisi' : null,
              ),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(labelText: 'Deskripsi'),
              ),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Kategori'),
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Harga'),
                keyboardType: TextInputType.number,
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: saveItem,
                child: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
