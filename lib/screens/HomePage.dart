import 'package:flutter/material.dart';
import 'package:mobile_inventory_system/controllers/DatabaseController.dart';
import 'package:mobile_inventory_system/models/item_model.dart';
import 'package:mobile_inventory_system/screens/AddItemPage.dart';
import 'package:mobile_inventory_system/screens/ItemDetailPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseController dbController = DatabaseController.instance;
  List<Item> items = [];

  @override
  void initState() {
    super.initState();
    fetchItems();
  }

  Future<void> fetchItems() async {
    final db = await dbController.database;
    final result = await db.query('items');
    setState(() {
      items = result.map((json) => Item.fromJson(json)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: items.isEmpty
          ? const Center(
              child: Text('Belum ada barang'),
            )
          : ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  leading: item.imagePath != null
                      ? Image.memory(item.imagePath!)
                      : const Icon(Icons.image_not_supported),
                  title: Text(item.name),
                  subtitle:
                      Text('Kategori: ${item.category}, Stok: ${item.stock}'),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ItemDetailPage(item: item),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddItemPage()),
          );
          if (result == true) fetchItems();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
