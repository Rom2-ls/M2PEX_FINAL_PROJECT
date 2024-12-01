import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/firestore_service.dart';
import '../models/item.dart';
import '../widgets/item_form.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final firestoreService = context.read<FirestoreService>();

    return Scaffold(
      appBar: AppBar(title: const Text('Admin')),
      body: StreamBuilder<List<Item>>(
        stream: firestoreService.getItems(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text('Erreur: ${snapshot.error}');
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final items = snapshot.data!;
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                title: Text(item.name),
                subtitle: Text('${item.price}€'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        _showItemForm(context, item);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        await _confirmDelete(context, item);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showItemForm(context, null); // Open ItemForm for new item
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showItemForm(BuildContext context, Item? item) {
    showDialog(
      context: context,
      builder: (context) {
        return ItemForm(item: item);
      },
    );
  }

  Future<void> _confirmDelete(BuildContext context, Item item) async {
    final firestoreService = context.read<FirestoreService>();

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Supprimer l\'article'),
          content: Text('Voulez-vous vraiment supprimer "${item.name}"?'),
          actions: [
            TextButton(
              child: const Text('Annuler'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: const Text('Supprimer'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      await firestoreService.deleteItem(item.id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Article supprimé')),
      );
    }
  }
}
