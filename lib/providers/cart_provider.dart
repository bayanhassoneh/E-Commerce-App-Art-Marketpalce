import 'package:art_marketplace/models/cartItemModel.dart';
import 'package:art_marketplace/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:art_marketplace/models/post.dart';
import 'package:art_marketplace/services/cart_service.dart';

class CartProvider extends ChangeNotifier {
  final cartservice _service;
  CartProvider(this._service);
  List<Post> cartItems = [];
  List<Cartitemmodel> localItems = [];

  AuthProvider _authProvider = AuthProvider();
  String errorMessage = '';
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  Future<void> addToCart(Post item) async {
    if (!isIncart(item)) {
      try {
        await _service.addToCart(
          item: item,
          userid: _authProvider.currentUserId,
        );
        cartItems.add(item);
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
      cartItems.remove(item);
    } on Exception catch (e) {
      errorMessage = 'failed to remove the item: $e';
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchCartItems() async {
    _isLoading = true;
    notifyListeners();
    try {
      cartItems = await _service.fetchCartItems(
        userid: _authProvider.currentUserId!,
      );
      try {
        await _service.saveLocalItems(cartItems);
      } catch (e) {
        print(e);
      }
    } on Exception catch (e) {
      try {
        cartItems = await _service.readLocalItems();
        errorMessage =
            'an error acured.'; ////////////////////////////////////////////////////
      } on Exception catch (e) {
        errorMessage = 'Failed to load latest updates.';
      }
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
