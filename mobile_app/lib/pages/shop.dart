import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/firestore_service.dart';
import '../models/item.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    final firestoreService = context.read<FirestoreService>();

    return StreamBuilder<List<Item>>(
      stream: firestoreService.getItems(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return Text('Erreur: ${snapshot.error}');
        if (!snapshot.hasData) return const CircularProgressIndicator();

        final items = snapshot.data!;
        return GridView.builder(
          padding: const EdgeInsets.all(8.0),
          gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ListTile(
                    title: Text(item.name),
                    subtitle: Text(item.description),
                  ),
                  Text('${item.price}€'),
                  IconButton(
                    icon: const Icon(FontAwesomeIcons.cartPlus),
                    onPressed: () {
                      firestoreService.addItemToCart(item);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${item.name} ajouté au panier')),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
