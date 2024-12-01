import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/item.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<Item>> getItems() {
    return _db.collection('items').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Item.fromFirestore(doc)).toList());
  }

  Future<void> addItemToCart(Item item) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Not authenticated');

    final cartItemQuery = await _db
        .collection('carts')
        .where('userId', isEqualTo: user.uid)
        .where('itemId', isEqualTo: item.id)
        .get();

    if (cartItemQuery.docs.isNotEmpty) {
      final cartItemDoc = cartItemQuery.docs.first;
      final currentQuantity = cartItemDoc['quantity'] ?? 1;
      await cartItemDoc.reference.update({'quantity': currentQuantity + 1});
    } else {
      final cartItem = {
        'itemId': item.id,
        'name': item.name,
        'price': item.price,
        'quantity': 1,
        'userId': user.uid,
      };
      await _db.collection('carts').add(cartItem);
    }
  }

  Stream<List<Item>> getCartItems() {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Not authenticated');

    return _db
        .collection('carts')
        .where('userId', isEqualTo: user.uid)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => Item.fromFirestore(doc)).toList());
  }

  Future<bool> isAdmin() async {
    final user = _auth.currentUser;
    if (user == null) return false;

    final roles = await _db
        .collection('roles')
        .where('userId', isEqualTo: user.uid)
        .get();
    if (roles.docs.isNotEmpty) {
      return roles.docs.first.data()['role'] == 'ADMIN';
    }
    return false;
  }

  Future<void> addItem(Item item) async {
    await _db.collection('items').add(item.toMap());
  }

  Future<void> updateItem(Item item) async {
    await _db.collection('items').doc(item.id).update(item.toMap());
  }

  Future<void> deleteItem(String itemId) async {
    await _db.collection('items').doc(itemId).delete();
  }

  Future<void> deleteCartItem(String cartItemId) async {
    await _db.collection('carts').doc(cartItemId).delete();
  }

  Future<void> updateCartItemQuantity(String cartItemId, int quantity) async {
    if (quantity > 0) {
      await _db.collection('carts').doc(cartItemId).update(
          {'quantity': quantity});
    } else {
      await deleteItem(cartItemId);
    }
  }

  Stream<List<CartItem>> getGroupedCartItems() {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Not authenticated');

    return _db
        .collection('carts')
        .where('userId', isEqualTo: user.uid)
        .snapshots()
        .map((snapshot) {
      Map<String, CartItem> groupedItems = {};
      for (var doc in snapshot.docs) {
        var cartItem = CartItem.fromFirestore(doc);
        if (groupedItems.containsKey(cartItem.itemId)) {
          groupedItems[cartItem.itemId]!.quantity += cartItem.quantity;
        } else {
          groupedItems[cartItem.itemId] = cartItem;
        }
      }
      return groupedItems.values.toList();
    });
  }
}
