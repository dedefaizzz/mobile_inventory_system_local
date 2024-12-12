import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:mobile_inventory_system/controllers/DatabaseController.dart';
import 'package:mobile_inventory_system/models/item_model.dart';

class AddHistoryPage extends StatefulWidget {
  final Item item;
  const AddHistoryPage({super.key, required this.item});

  @override
  State<AddHistoryPage> createState() => _AddHistoryPageState();
}

class _AddHistoryPageState extends State<AddHistoryPage> {
  final _formKey = GlobalKey<FormState>();
  String _transactionType = 'Masuk';
  final _quantityController = TextEditingController();
  final dbController = DatabaseController.instance;

  Future<Void> saveHistory() async {
    if (_formKey.currentState!.validate()) {
      final quantity = int.tryParse(_quantityController.text) ?? 0;
      final isIncoming = _transactionType == 'Masuk';

      // update stok barang
      final newStock = widget.item.stock + (isIncoming ? quantity : -quantity);
      if (newStock < 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Stok tidak mencukupi!')),
        );
      }

      final db = await dbController.database;
      await db.update(
        'items',
        {'Stock': newStock},
        where: 'id = ?',
        whereArgs: [widget.item.id],
      );

      // simpan riwayat transaksi
      await dbController.insertHistory(
        itemId: widget.item.id!,
        type: _transactionType,
        quantity: quantity,
        dateTime: DateTime.now(),
      );
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Riwayat Barang')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: _transactionType,
                items: const [
                  DropdownMenuItem(value: 'Masuk', child: Text('Masuk')),
                  DropdownMenuItem(value: 'Keluar', child: Text('Keluar')),
                ],
                onChanged: (value) => setState(() {
                  _transactionType = value!;
                }),
                decoration: const InputDecoration(labelText: 'Jenis Transaksi'),
              ),
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(labelText: 'Jumlah'),
                keyboardType: TextInputType.number,
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Jumlah wajib diisi'
                    : null,
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: saveHistory,
                child: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
