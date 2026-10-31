import 'package:flutter/material.dart';
import 'package:art_marketplace/models/post.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartProvider extends ChangeNotifier {
  List<Post> cartItems = [];

  void addToCart(Post item) async {
    cartItems.add(item);
    notifyListeners();
  }

  void removeFromCart(Post item) {
    cartItems.remove(item);
    notifyListeners();
  }

  bool isIncart(Post item) {
    return cartItems.any((cartItem) => cartItem.id == item.id);
  }

  double get totalPrice {
    return cartItems.fold(0.0, (total, item) => total + item.price);
  }
}
