import 'package:flutter/material.dart';
import 'package:art_marketplace/models/post.dart';

class CartProvider extends ChangeNotifier {
  List<Post> cartItems = [];

  void addToCart(Post item) {
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
}
