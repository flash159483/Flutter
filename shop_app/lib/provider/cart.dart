import 'package:flutter/foundation.dart';

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
  Map<String, CartItem> _cart = {};

  Map<String, CartItem> get cart {
    return {..._cart};
  }

  void updateCart(String id, String title, double price) {
    if (_cart.containsKey(id)) {
      _cart.update(
        id,
        (value) => CartItem(
          id: value.id,
          price: value.price,
          title: value.title,
          quantity: value.quantity + 1,
        ),
      );
    } else {
      _cart.putIfAbsent(
        id,
        () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          price: price,
          quantity: 1,
        ),
      );
      notifyListeners();
    }
  }

  int get cartLen {
    return _cart.length;
  }

  double get totalPrice {
    double total = 0;
    _cart.forEach((key, value) {
      total += value.price * value.quantity;
    });
    return total;
  }

  void deleteItem(String id) {
    _cart.remove(id);
    notifyListeners();
  }

  void removeItem(String id) {
    if (!_cart.containsKey(id)) {
      return;
    } else if (_cart[id].quantity > 1) {
      _cart.update(
        id,
        (value) => CartItem(
            id: value.id,
            price: value.price,
            title: value.title,
            quantity: value.quantity - 1),
      );
    } else {
      _cart.remove(id);
    }
    notifyListeners();
  }

  void clearCart() {
    _cart = {};
    notifyListeners();
  }
}
