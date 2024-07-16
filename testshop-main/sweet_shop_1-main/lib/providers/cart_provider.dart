import 'package:flutter/foundation.dart';
import 'package:sweet_shop/models/cart_model.dart';

class CartProvider extends ChangeNotifier {
  List<Cart> _cartItems = [];

  List<Cart> get cartItems => _cartItems;

  void setCartItemsFromModel(List<Cart> cartItems) {
    _cartItems = cartItems;
  }
}
