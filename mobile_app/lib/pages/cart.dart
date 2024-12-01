import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/firestore_service.dart';
import '../models/item.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final firestoreService = context.read<FirestoreService>();

    return Scaffold(
      appBar: AppBar(title: const Text('Panier')),
      body: StreamBuilder<List<Item>>(
        stream: firestoreService.getCartItems(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text('Erreur: ${snapshot.error}');
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final cartItems = snapshot.data!;
          if (cartItems.isEmpty) {
            return const Center(child: Text('Votre panier est vide.'));
          }
          return ListView.builder(
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              final cartItem = cartItems[index];
              return ListTile(
                title: Text(cartItem.name),
                subtitle: Text('Prix: ${cartItem.price}€'),
                leading: IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: cartItem.quantity > 1
                      ? () {
                          firestoreService.updateCartItemQuantity(
                              cartItem.id, cartItem.quantity - 1);
                        }
                      : null,
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Quantité: ${cartItem.quantity}'),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        firestoreService.updateCartItemQuantity(
                            cartItem.id, cartItem.quantity + 1);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        firestoreService.deleteCartItem(cartItem.id);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
