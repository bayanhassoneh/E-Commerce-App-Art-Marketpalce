import 'package:art_marketplace/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:art_marketplace/models/post.dart';
import 'package:art_marketplace/services/cart_service.dart';

class CartProvider extends ChangeNotifier {
  List<Post> cartItems = [];
  final cartservice _service = cartservice();
  AuthProvider _authProvider = AuthProvider();
  String errorMessage = '';
  Future<void> addToCart(Post item) async {
    if (!isIncart(item)) {
      try {
        await _service.addToCart(
          item: item,
          userid: _authProvider.currentUserId,
        );
        try {
          cartItems.add(item);
        } catch (e) {}
      } on Exception catch (e) {
        errorMessage = 'failed to add the item: $e';
      } finally {
        notifyListeners();
      }
    }
  }

  Future<void> removeFromCart(Post item) async {
    try {
      await _service.removeFromCart(
        item: item,
        userid: _authProvider.currentUserId,
      );
      try {
        cartItems.remove(item);
      } catch (e) {}
    } on Exception catch (e) {
      errorMessage = 'failed to remove the item: $e';
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchCartItems() async {
    try {
      cartItems = await _service.fetchCartItems(
        userid: _authProvider.currentUserId!,
      );
    } on Exception catch (e) {
      errorMessage = 'failed to load the items: $e';
    } finally {
      notifyListeners();
    }
  }

  bool isIncart(Post item) {
    return cartItems.any((cartItem) => cartItem.id == item.id);
  }

  double get totalPrice {
    return cartItems.fold(0.0, (total, item) => total + item.price);
  }
}
