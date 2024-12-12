import 'package:flutter/material.dart';
import 'package:mobile_inventory_system/colors.dart';
import 'package:mobile_inventory_system/controllers/DatabaseController.dart';
import 'package:mobile_inventory_system/models/item_model.dart';
import 'package:mobile_inventory_system/screens/AddHistoryPage.dart';

class ItemDetailPage extends StatefulWidget {
  final Item item;
  const ItemDetailPage({super.key, required this.item});

  @override
  State<ItemDetailPage> createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {
  final DatabaseController dbController = DatabaseController.instance;
  List<Map<String, dynamic>> history = [];

  @override
  void initState() {
    super.initState();
    fetchHistory();
  }

  Future<void> fetchHistory() async {
    final db = await dbController.database;
    final result = await db.query(
      'history',
      where: 'itemId = ?',
      whereArgs: [widget.item.id],
      orderBy: 'date DESC',
    );
    setState(() {
      history = result;
    });
  }

  Future<void> deleteItem() async {
    final db = await dbController.database;
    await db.delete('items', where: 'id = ?', whereArgs: [widget.item.id]);
    await db
        .delete('history', where: 'itemId = ?', whereArgs: [widget.item.id]);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.item.name)),
      body: Column(
        children: [
          ListTile(
            leading: widget.item.imagePath != null
                ? Image.memory(widget.item.imagePath!)
                : const Icon(Icons.image),
            title: Text(widget.item.name),
            subtitle: Text(widget.item.description),
            trailing: Text('Stok: ${widget.item.stock}'),
          ),
          const Divider(),
          const Text('Riwayat Stok', style: TextStyle(fontSize: 18)),
          Expanded(
            child: history.isEmpty
                ? const Center(child: Text('Belum ada riwayat stok'))
                : ListView.builder(
                    itemCount: history.length,
                    itemBuilder: (context, index) {
                      final record = history[index];
                      return ListTile(
                        title: Text(
                          '${record['type']} (${record['quantity']})',
                        ),
                        subtitle: Text(record['date']),
                      );
                    },
                  ),
          ),
          ElevatedButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddHistoryPage(item: widget.item),
                ),
              );
              if (result == true) fetchHistory();
            },
            child: const Text('Tambah Riwayat'),
          ),
          ElevatedButton(
            onPressed: deleteItem,
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.deleteColor),
            child: const Text('Hapus Barang'),
          ),
        ],
      ),
    );
  }
}
