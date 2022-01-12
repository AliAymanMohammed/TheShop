import 'package:flutter/material.dart';

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  void addItem(String productId, String productTitle, double productPrice) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (existingProduct) => CartItem(
              cId: existingProduct.cId,
              cTitle: existingProduct.cTitle,
              cPrice: existingProduct.cPrice,
              cQuantity: existingProduct.cQuantity + 1));
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
              cId: DateTime.now().toString(),
              cTitle: productTitle,
              cPrice: productPrice,
              cQuantity: 1));
    }
    notifyListeners();
  }

  int get itemCount {
    return items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.cPrice * cartItem.cQuantity;
    });
    return total;
  }

  int get itemQuantity {
    int quantity = 0;
    _items.forEach((key, cartItem) {
      quantity += cartItem.cQuantity;
    });
    return quantity;
  }

  void deleteCartItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId].cQuantity > 1) {
      _items.update(
          productId,
          (existingCartItem) => CartItem(
              cId: existingCartItem.cId,
              cTitle: existingCartItem.cTitle,
              cPrice: existingCartItem.cPrice,
              cQuantity: existingCartItem.cQuantity - 1));
    }else{
      _items.remove(productId);
    }
    notifyListeners();
  }
}

class CartItem {
  final String cId;
  final String cTitle;
  final double cPrice;
  final int cQuantity;

  CartItem({
    @required this.cId,
    @required this.cTitle,
    @required this.cPrice,
    @required this.cQuantity,
  });
}
