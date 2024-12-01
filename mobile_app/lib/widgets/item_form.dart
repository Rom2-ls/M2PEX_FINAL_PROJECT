import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/firestore_service.dart';
import '../models/item.dart';

class ItemForm extends StatefulWidget {
  final Item? item;

  const ItemForm({super.key, this.item});

  @override
  _ItemFormState createState() => _ItemFormState();
}

class _ItemFormState extends State<ItemForm> {
  final _formKey = GlobalKey<FormState>();
  late String name;
  late String description;
  late double price;
  late int quantity;

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      name = widget.item!.name;
      description = widget.item!.description;
      price = widget.item!.price;
      quantity = widget.item!.quantity;
    } else {
      name = '';
      description = '';
      price = 0.0;
      quantity = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final firestoreService = context.read<FirestoreService>();

    return AlertDialog(
      title: Text(widget.item != null ? 'Modifier l\'article' : 'Nouvel article'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                initialValue: name,
                decoration: const InputDecoration(labelText: 'Nom'),
                onSaved: (value) => name = value ?? '',
                validator: (value) => value!.isEmpty ? 'Champ requis' : null,
              ),
              TextFormField(
                initialValue: description,
                decoration: const InputDecoration(labelText: 'Description'),
                onSaved: (value) => description = value ?? '',
                validator: (value) => value!.isEmpty ? 'Champ requis' : null,
              ),
              TextFormField(
                initialValue: price.toString(),
                decoration: const InputDecoration(labelText: 'Prix'),
                keyboardType: TextInputType.number,
                onSaved: (value) => price = double.parse(value ?? '0'),
                validator: (value) =>
                    value!.isEmpty ? 'Champ requis' : null,
              ),
              TextFormField(
                initialValue: quantity.toString(),
                decoration: const InputDecoration(labelText: 'Quantité'),
                keyboardType: TextInputType.number,
                onSaved: (value) => quantity = int.parse(value ?? '0'),
                validator: (value) =>
                    value!.isEmpty ? 'Champ requis' : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Annuler'),
          onPressed: () => Navigator.pop(context),
        ),
        ElevatedButton(
          child: const Text('Enregistrer'),
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();

              final item = Item(
                id: widget.item?.id ?? '',
                name: name,
                description: description,
                price: price,
                quantity: quantity,
              );

              if (widget.item == null) {
                await firestoreService.addItem(item);
              } else {
                await firestoreService.updateItem(item);
              }

              Navigator.pop(context);
            }
          },
        ),
      ],
    );
  }
}
