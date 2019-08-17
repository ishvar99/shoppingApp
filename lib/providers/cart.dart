import 'package:flutter/material.dart';

class CartItem {
  String id;
  String title;
  double price;
  int quantity;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.price,
    @required this.quantity,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((id, item) {
      total += item.price * item.quantity;
    });
    return total;
  }

  void removeItem(String itemId) {
    _items.removeWhere((id, item) => item.id == itemId);
    notifyListeners();
  }

  void addItem(product) {
    if (_items.containsKey(product.id)) {
      _items.update(
        product.id,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
          product.id,
          () => CartItem(
                id: DateTime.now().toString(),
                title: product.title,
                price: product.price,
                quantity: 1,
              ));
    }
    notifyListeners();
  }

  void removeSingleItem(productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId].quantity > 1) {
      _items.update(productId, (existingProduct)=>
        CartItem(
            id: existingProduct.id,
            price: existingProduct.price,
            title: existingProduct.title,
            quantity: existingProduct.quantity - 1)
      );
    }
    else{
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
