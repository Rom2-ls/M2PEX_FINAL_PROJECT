import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  String id;
  String name;
  String description;
  double price;
  int quantity;
  String? userId;

  Item({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    this.userId,
  });

  factory Item.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Item(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      quantity: data['quantity'] ?? 0,
      userId: data['userId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'quantity': quantity,
      if (userId != null) 'userId': userId,
    };
  }
}

class CartItem {
  String id;
  String itemId;
  String name;
  double price;
  int quantity;
  String userId;

  CartItem({
    required this.id,
    required this.itemId,
    required this.name,
    required this.price,
    required this.quantity,
    required this.userId,
  });

  factory CartItem.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CartItem(
      id: doc.id,
      itemId: data['itemId'] ?? '',
      name: data['name'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      quantity: data['quantity'] ?? 1,
      userId: data['userId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'itemId': itemId,
      'name': name,
      'price': price,
      'quantity': quantity,
      'userId': userId,
    };
  }
}
